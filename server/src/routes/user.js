const express = require('express');
const User = require('../models/user');
const { auth, restrictTo } = require('../middleware/auth');
const { AppError } = require('../middleware/error');
const { validateRequest } = require('../middleware/validation');
const { Request } = require('../models/request');
const { Activity } = require('../models/activity');

const router = express.Router();

// Get all users (admin only)
router.get('/', auth, restrictTo('admin'), async (req, res, next) => {
  try {
    const users = await User.find().select('-password');
    res.json({
      status: 'success',
      data: { users }
    });
  } catch (error) {
    next(error);
  }
});

// Get user by ID
router.get('/:id', auth, async (req, res, next) => {
  try {
    const user = await User.findById(req.params.id).select('-password');
    
    if (!user) {
      return next(new AppError('User not found', 404));
    }

    // Only admins can view other users' profiles
    if (req.user.role !== 'admin' && req.user._id.toString() !== req.params.id) {
      return next(new AppError('Not authorized to view this profile', 403));
    }

    res.json({
      status: 'success',
      data: { user }
    });
  } catch (error) {
    next(error);
  }
});

// Get user-specific data
router.get('/data', auth, async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select('-password');
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    // Get user's recent activity
    const recentRequests = await Request.find({ userId: req.user.id })
      .sort({ timestamp: -1 })
      .limit(5);

    res.json({
      success: true,
      data: {
        user,
        recentActivity: recentRequests,
      },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching user data',
      error: error.message,
    });
  }
});

// Update user profile
router.put('/update', auth, async (req, res) => {
  try {
    const { name, email, phone, department } = req.body;
    const user = await User.findById(req.user.id);

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    // Update fields if provided
    if (name) user.name = name;
    if (email) user.email = email;
    if (phone) user.phone = phone;
    if (department) user.department = department;

    await user.save();

    res.json({
      success: true,
      data: user,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error updating profile',
      error: error.message,
    });
  }
});

// Submit access request
router.post('/request', auth, validateRequest, async (req, res) => {
  try {
    const { type, location, notes, metadata } = req.body;

    const request = new Request({
      userId: req.user.id,
      type,
      location,
      notes,
      metadata,
      status: 'pending',
      timestamp: new Date(),
    });

    await request.save();

    // Log activity
    await Activity.create({
      userId: req.user.id,
      type: 'request_submitted',
      details: `Submitted ${type} request for ${location}`,
      timestamp: new Date(),
    });

    res.status(201).json({
      success: true,
      data: request,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error submitting request',
      error: error.message,
    });
  }
});

// View access history
router.get('/history', auth, async (req, res) => {
  try {
    const { status, startDate, endDate } = req.query;
    const query = { userId: req.user.id };

    // Add filters if provided
    if (status) query.status = status;
    if (startDate || endDate) {
      query.timestamp = {};
      if (startDate) query.timestamp.$gte = new Date(startDate);
      if (endDate) query.timestamp.$lte = new Date(endDate);
    }

    const requests = await Request.find(query)
      .sort({ timestamp: -1 })
      .populate('processedBy', 'name');

    res.json({
      success: true,
      data: requests,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching access history',
      error: error.message,
    });
  }
});

// Update password
router.patch('/update-password', auth, async (req, res, next) => {
  try {
    const { currentPassword, newPassword, passwordConfirm } = req.body;

    // Get user from collection
    const user = await User.findById(req.user._id).select('+password');

    // Check current password
    if (!(await user.correctPassword(currentPassword, user.password))) {
      return next(new AppError('Your current password is wrong', 401));
    }

    // Update password
    user.password = newPassword;
    user.passwordConfirm = passwordConfirm;
    await user.save();

    res.json({
      status: 'success',
      message: 'Password updated successfully'
    });
  } catch (error) {
    next(error);
  }
});

// Delete user (admin only)
router.delete('/:id', auth, restrictTo('admin'), async (req, res, next) => {
  try {
    const user = await User.findByIdAndDelete(req.params.id);

    if (!user) {
      return next(new AppError('User not found', 404));
    }

    res.json({
      status: 'success',
      message: 'User deleted successfully'
    });
  } catch (error) {
    next(error);
  }
});

// Helper function to filter object
const filterObj = (obj, ...allowedFields) => {
  const newObj = {};
  Object.keys(obj).forEach(el => {
    if (allowedFields.includes(el)) newObj[el] = obj[el];
  });
  return newObj;
};

module.exports = router; 