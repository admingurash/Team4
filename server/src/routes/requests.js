const express = require('express');
const router = express.Router();
const { verifyToken, checkPermission } = require('../middleware/auth');
const Request = require('../models/Request');
const ActivityLog = require('../models/ActivityLog');

// Create new request (User)
router.post('/', verifyToken, async (req, res) => {
  try {
    const request = await Request.create({
      ...req.body,
      userId: req.user._id
    });

    // Log activity
    await ActivityLog.create({
      userId: req.user._id,
      action: 'create_request',
      details: { requestId: request._id },
      ipAddress: req.ip,
      userAgent: req.get('user-agent')
    });

    res.status(201).json({
      success: true,
      data: request
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message
    });
  }
});

// Get user's requests (User)
router.get('/my-requests', verifyToken, async (req, res) => {
  try {
    const requests = await Request.find({ userId: req.user._id })
      .sort({ timestamp: -1 })
      .limit(50);

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

// Get pending requests (Worker)
router.get('/pending', verifyToken, checkPermission('verify_users'), async (req, res) => {
  try {
    const requests = await Request.find({ status: 'pending' })
      .populate('userId', 'name email')
      .sort({ timestamp: -1 });

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

// Process request (Worker)
router.patch('/:id/process', verifyToken, checkPermission('verify_users'), async (req, res) => {
  try {
    const { status, notes } = req.body;
    const request = await Request.findById(req.params.id);

    if (!request) {
      return res.status(404).json({
        success: false,
        message: 'Request not found'
      });
    }

    request.status = status;
    request.notes = notes;
    request.processedBy = req.user._id;
    request.processedAt = new Date();
    await request.save();

    // Log activity
    await ActivityLog.create({
      userId: req.user._id,
      action: `${status}_request`,
      details: { requestId: request._id },
      affectedUser: request.userId,
      affectedResource: request._id,
      resourceType: 'Request',
      ipAddress: req.ip,
      userAgent: req.get('user-agent')
    });

    res.json({
      success: true,
      data: request
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message
    });
  }
});

// Get all requests (Admin)
router.get('/', verifyToken, checkPermission('view_reports'), async (req, res) => {
  try {
    const { status, startDate, endDate } = req.query;
    const query = {};

    if (status) query.status = status;
    if (startDate || endDate) {
      query.timestamp = {};
      if (startDate) query.timestamp.$gte = new Date(startDate);
      if (endDate) query.timestamp.$lte = new Date(endDate);
    }

    const requests = await Request.find(query)
      .populate('userId', 'name email')
      .populate('processedBy', 'name email')
      .sort({ timestamp: -1 });

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

module.exports = router; 