const express = require('express');
const router = express.Router();
const { auth, restrictTo } = require('../middleware/auth');
const { Task } = require('../models/task');
const { Request } = require('../models/request');
const { Activity } = require('../models/activity');

// Middleware to ensure user is a worker
router.use(auth, restrictTo('worker'));

// Fetch assigned tasks
router.get('/tasks', async (req, res) => {
  try {
    const { status, priority } = req.query;
    const query = { assignedTo: req.user.id };

    // Add filters if provided
    if (status) query.status = status;
    if (priority) query.priority = priority;

    const tasks = await Task.find(query)
      .sort({ dueDate: 1, priority: -1 })
      .populate('assignedBy', 'name')
      .populate('relatedRequests');

    res.json({
      success: true,
      data: tasks,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching tasks',
      error: error.message,
    });
  }
});

// Approve/Deny user requests
router.put('/verify/:id', async (req, res) => {
  try {
    const { approved, notes } = req.body;
    const request = await Request.findById(req.params.id);

    if (!request) {
      return res.status(404).json({
        success: false,
        message: 'Request not found',
      });
    }

    // Update request status
    request.status = approved ? 'approved' : 'denied';
    request.processedBy = req.user.id;
    request.processedAt = new Date();
    request.notes = notes;

    await request.save();

    // If approved, create a task for the worker
    if (approved) {
      const task = new Task({
        title: `Process ${request.type} request`,
        description: `Handle ${request.type} request for ${request.location}`,
        assignedTo: req.user.id,
        assignedBy: req.user.id, // Self-assigned
        status: 'pending',
        priority: 'medium',
        dueDate: new Date(Date.now() + 24 * 60 * 60 * 1000), // 24 hours from now
        relatedRequests: [request._id],
      });

      await task.save();
    }

    // Log activity
    await Activity.create({
      userId: req.user.id,
      type: 'request_processed',
      details: `${approved ? 'Approved' : 'Denied'} ${request.type} request for ${request.location}`,
      timestamp: new Date(),
    });

    res.json({
      success: true,
      data: request,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error processing request',
      error: error.message,
    });
  }
});

// View assigned logs
router.get('/logs', async (req, res) => {
  try {
    const { startDate, endDate } = req.query;
    const query = { userId: req.user.id };

    // Add date filters if provided
    if (startDate || endDate) {
      query.timestamp = {};
      if (startDate) query.timestamp.$gte = new Date(startDate);
      if (endDate) query.timestamp.$lte = new Date(endDate);
    }

    const logs = await Activity.find(query)
      .sort({ timestamp: -1 })
      .limit(50);

    res.json({
      success: true,
      data: logs,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching logs',
      error: error.message,
    });
  }
});

module.exports = router; 