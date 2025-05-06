const express = require('express');
const router = express.Router();
const { verifyToken, checkPermission } = require('../middleware/auth');
const Task = require('../models/Task');
const ActivityLog = require('../models/ActivityLog');

// Create task (Admin/Manager)
router.post('/', verifyToken, checkPermission('edit_tasks'), async (req, res) => {
  try {
    const task = await Task.create({
      ...req.body,
      assignedBy: req.user._id
    });

    // Log activity
    await ActivityLog.create({
      userId: req.user._id,
      action: 'create_task',
      details: { taskId: task._id },
      affectedUser: task.assignedTo,
      affectedResource: task._id,
      resourceType: 'Task',
      ipAddress: req.ip,
      userAgent: req.get('user-agent')
    });

    res.status(201).json({
      success: true,
      data: task
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message
    });
  }
});

// Get assigned tasks (Worker)
router.get('/my-tasks', verifyToken, async (req, res) => {
  try {
    const tasks = await Task.find({ assignedTo: req.user._id })
      .populate('assignedBy', 'name email')
      .sort({ dueDate: 1 });

    res.json({
      success: true,
      data: tasks
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message
    });
  }
});

// Update task status (Worker)
router.patch('/:id/status', verifyToken, async (req, res) => {
  try {
    const { status } = req.body;
    const task = await Task.findById(req.params.id);

    if (!task) {
      return res.status(404).json({
        success: false,
        message: 'Task not found'
      });
    }

    // Check if user is assigned to this task
    if (task.assignedTo.toString() !== req.user._id.toString()) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to update this task'
      });
    }

    task.status = status;
    if (status === 'completed') {
      task.completedAt = new Date();
    }
    await task.save();

    // Log activity
    await ActivityLog.create({
      userId: req.user._id,
      action: 'update_task',
      details: { taskId: task._id, status },
      affectedResource: task._id,
      resourceType: 'Task',
      ipAddress: req.ip,
      userAgent: req.get('user-agent')
    });

    res.json({
      success: true,
      data: task
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message
    });
  }
});

// Get all tasks (Admin/Manager)
router.get('/', verifyToken, checkPermission('view_reports'), async (req, res) => {
  try {
    const { status, assignedTo, startDate, endDate } = req.query;
    const query = {};

    if (status) query.status = status;
    if (assignedTo) query.assignedTo = assignedTo;
    if (startDate || endDate) {
      query.dueDate = {};
      if (startDate) query.dueDate.$gte = new Date(startDate);
      if (endDate) query.dueDate.$lte = new Date(endDate);
    }

    const tasks = await Task.find(query)
      .populate('assignedTo', 'name email')
      .populate('assignedBy', 'name email')
      .sort({ dueDate: 1 });

    res.json({
      success: true,
      data: tasks
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message
    });
  }
});

// Update task (Admin/Manager)
router.patch('/:id', verifyToken, checkPermission('edit_tasks'), async (req, res) => {
  try {
    const task = await Task.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    );

    if (!task) {
      return res.status(404).json({
        success: false,
        message: 'Task not found'
      });
    }

    // Log activity
    await ActivityLog.create({
      userId: req.user._id,
      action: 'update_task',
      details: { taskId: task._id },
      affectedUser: task.assignedTo,
      affectedResource: task._id,
      resourceType: 'Task',
      ipAddress: req.ip,
      userAgent: req.get('user-agent')
    });

    res.json({
      success: true,
      data: task
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message
    });
  }
});

module.exports = router; 