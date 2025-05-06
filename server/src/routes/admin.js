const express = require('express');
const router = express.Router();
const { auth, restrictTo } = require('../middleware/auth');
const { User } = require('../models/user');
const { Task } = require('../models/task');
const { Activity } = require('../models/activity');

// Middleware to ensure user is an admin
router.use(auth, restrictTo('admin'));

// View all users & workers
router.get('/users', async (req, res) => {
  try {
    const { role, department } = req.query;
    const query = {};

    // Add filters if provided
    if (role) query.role = role;
    if (department) query.department = department;

    const users = await User.find(query)
      .select('-password')
      .sort({ createdAt: -1 });

    res.json({
      success: true,
      data: users,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching users',
      error: error.message,
    });
  }
});

// Remove a user
router.delete('/user/:id', async (req, res) => {
  try {
    const user = await User.findById(req.params.id);

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    // Prevent deleting admin users
    if (user.role === 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Cannot delete admin users',
      });
    }

    await user.remove();

    // Log activity
    await Activity.create({
      userId: req.user.id,
      type: 'user_deleted',
      details: `Deleted user: ${user.email}`,
      timestamp: new Date(),
    });

    res.json({
      success: true,
      message: 'User deleted successfully',
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error deleting user',
      error: error.message,
    });
  }
});

// View full system logs
router.get('/logs', async (req, res) => {
  try {
    const { type, startDate, endDate, userId } = req.query;
    const query = {};

    // Add filters if provided
    if (type) query.type = type;
    if (userId) query.userId = userId;
    if (startDate || endDate) {
      query.timestamp = {};
      if (startDate) query.timestamp.$gte = new Date(startDate);
      if (endDate) query.timestamp.$lte = new Date(endDate);
    }

    const logs = await Activity.find(query)
      .sort({ timestamp: -1 })
      .populate('userId', 'name email')
      .limit(100);

    res.json({
      success: true,
      data: logs,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching system logs',
      error: error.message,
    });
  }
});

// Assign worker tasks
router.post('/assign-worker', async (req, res) => {
  try {
    const { workerId, task } = req.body;

    // Verify worker exists
    const worker = await User.findOne({ _id: workerId, role: 'worker' });
    if (!worker) {
      return res.status(404).json({
        success: false,
        message: 'Worker not found',
      });
    }

    // Create new task
    const newTask = new Task({
      ...task,
      assignedTo: workerId,
      assignedBy: req.user.id,
      status: 'pending',
    });

    await newTask.save();

    // Log activity
    await Activity.create({
      userId: req.user.id,
      type: 'task_assigned',
      details: `Assigned task to worker: ${worker.name}`,
      timestamp: new Date(),
    });

    res.status(201).json({
      success: true,
      data: newTask,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error assigning task',
      error: error.message,
    });
  }
});

module.exports = router; 