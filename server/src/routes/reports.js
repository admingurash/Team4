const express = require('express');
const router = express.Router();
const { verifyToken, checkPermission } = require('../middleware/auth');
const Request = require('../models/Request');
const Task = require('../models/Task');
const ActivityLog = require('../models/ActivityLog');
const User = require('../models/User');

// Get system overview (Admin)
router.get('/overview', verifyToken, checkPermission('view_reports'), async (req, res) => {
  try {
    const [
      totalUsers,
      totalRequests,
      pendingRequests,
      totalTasks,
      pendingTasks,
      recentActivities
    ] = await Promise.all([
      User.countDocuments(),
      Request.countDocuments(),
      Request.countDocuments({ status: 'pending' }),
      Task.countDocuments(),
      Task.countDocuments({ status: 'pending' }),
      ActivityLog.find()
        .populate('userId', 'name email')
        .sort({ timestamp: -1 })
        .limit(10)
    ]);

    res.json({
      success: true,
      data: {
        totalUsers,
        totalRequests,
        pendingRequests,
        totalTasks,
        pendingTasks,
        recentActivities
      }
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message
    });
  }
});

// Get request statistics (Admin/Manager)
router.get('/requests', verifyToken, checkPermission('view_reports'), async (req, res) => {
  try {
    const { startDate, endDate } = req.query;
    const query = {};

    if (startDate || endDate) {
      query.timestamp = {};
      if (startDate) query.timestamp.$gte = new Date(startDate);
      if (endDate) query.timestamp.$lte = new Date(endDate);
    }

    const requests = await Request.aggregate([
      { $match: query },
      {
        $group: {
          _id: '$status',
          count: { $sum: 1 }
        }
      }
    ]);

    res.json({
      success: true,
      data: requests
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message
    });
  }
});

// Get task statistics (Admin/Manager)
router.get('/tasks', verifyToken, checkPermission('view_reports'), async (req, res) => {
  try {
    const { startDate, endDate } = req.query;
    const query = {};

    if (startDate || endDate) {
      query.dueDate = {};
      if (startDate) query.dueDate.$gte = new Date(startDate);
      if (endDate) query.dueDate.$lte = new Date(endDate);
    }

    const tasks = await Task.aggregate([
      { $match: query },
      {
        $group: {
          _id: '$status',
          count: { $sum: 1 }
        }
      }
    ]);

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

// Get user activity report (Admin)
router.get('/user-activity', verifyToken, checkPermission('view_reports'), async (req, res) => {
  try {
    const { userId, startDate, endDate } = req.query;
    const query = {};

    if (userId) query.userId = userId;
    if (startDate || endDate) {
      query.timestamp = {};
      if (startDate) query.timestamp.$gte = new Date(startDate);
      if (endDate) query.timestamp.$lte = new Date(endDate);
    }

    const activities = await ActivityLog.find(query)
      .populate('userId', 'name email')
      .populate('affectedUser', 'name email')
      .sort({ timestamp: -1 });

    res.json({
      success: true,
      data: activities
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message
    });
  }
});

// Export data (Admin)
router.get('/export', verifyToken, checkPermission('export_data'), async (req, res) => {
  try {
    const { type, startDate, endDate } = req.query;
    let data;

    switch (type) {
      case 'requests':
        data = await Request.find({
          timestamp: {
            $gte: new Date(startDate),
            $lte: new Date(endDate)
          }
        }).populate('userId', 'name email');
        break;
      case 'tasks':
        data = await Task.find({
          dueDate: {
            $gte: new Date(startDate),
            $lte: new Date(endDate)
          }
        }).populate('assignedTo', 'name email');
        break;
      case 'activities':
        data = await ActivityLog.find({
          timestamp: {
            $gte: new Date(startDate),
            $lte: new Date(endDate)
          }
        }).populate('userId', 'name email');
        break;
      default:
        return res.status(400).json({
          success: false,
          message: 'Invalid export type'
        });
    }

    // Log export activity
    await ActivityLog.create({
      userId: req.user._id,
      action: 'export_data',
      details: { type, startDate, endDate },
      ipAddress: req.ip,
      userAgent: req.get('user-agent')
    });

    res.json({
      success: true,
      data
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message
    });
  }
});

module.exports = router; 