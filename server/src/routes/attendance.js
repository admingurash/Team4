const express = require('express');
const Attendance = require('../models/attendance');
const { auth } = require('../middleware/auth');
const { AppError } = require('../middleware/error');

const router = express.Router();

// Get all attendance records with pagination and filters
router.get('/', auth, async (req, res, next) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;
    const search = req.query.search || '';
    const status = req.query.status || '';
    const workLocation = req.query.workLocation || '';
    const startDate = req.query.startDate ? new Date(req.query.startDate) : null;
    const endDate = req.query.endDate ? new Date(req.query.endDate) : null;

    // Build query
    const query = {};
    if (search) {
      query.$or = [
        { 'user.name': { $regex: search, $options: 'i' } },
        { 'user.email': { $regex: search, $options: 'i' } }
      ];
    }
    if (status) query.status = status;
    if (workLocation) query.workLocation = workLocation;
    if (startDate || endDate) {
      query.date = {};
      if (startDate) query.date.$gte = startDate;
      if (endDate) query.date.$lte = endDate;
    }

    // Execute query with pagination
    const attendance = await Attendance.find(query)
      .populate('userId', 'name email photo')
      .populate('approvedBy', 'name email')
      .sort({ date: -1, checkIn: -1 })
      .skip(skip)
      .limit(limit);

    // Get total count for pagination
    const total = await Attendance.countDocuments(query);

    res.json({
      status: 'success',
      data: {
        attendance,
        pagination: {
          total,
          page,
          pages: Math.ceil(total / limit),
          limit
        }
      }
    });
  } catch (error) {
    next(error);
  }
});

// Get attendance record by ID
router.get('/:id', auth, async (req, res, next) => {
  try {
    const attendance = await Attendance.findById(req.params.id)
      .populate('userId', 'name email photo')
      .populate('approvedBy', 'name email');

    if (!attendance) {
      return next(new AppError('Attendance record not found', 404));
    }

    res.json({
      status: 'success',
      data: { attendance }
    });
  } catch (error) {
    next(error);
  }
});

// Check in
router.post('/check-in', auth, async (req, res, next) => {
  try {
    // Check if already checked in today
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    const existingRecord = await Attendance.findOne({
      userId: req.user._id,
      date: { $gte: today }
    });

    if (existingRecord) {
      return next(new AppError('Already checked in today', 400));
    }

    const attendance = new Attendance({
      userId: req.user._id,
      date: new Date(),
      checkIn: new Date(),
      workLocation: req.body.workLocation || 'office',
      notes: req.body.notes,
      location: req.body.location
    });

    await attendance.save();

    res.status(201).json({
      status: 'success',
      data: { attendance }
    });
  } catch (error) {
    next(error);
  }
});

// Check out
router.post('/check-out/:id', auth, async (req, res, next) => {
  try {
    const attendance = await Attendance.findById(req.params.id);
    
    if (!attendance) {
      return next(new AppError('Attendance record not found', 404));
    }

    if (attendance.userId.toString() !== req.user._id.toString()) {
      return next(new AppError('Not authorized to check out this record', 403));
    }

    if (attendance.checkOut) {
      return next(new AppError('Already checked out', 400));
    }

    attendance.checkOut = new Date();
    attendance.breakTime = req.body.breakTime || 0;
    attendance.notes = req.body.notes || attendance.notes;
    await attendance.save();

    res.json({
      status: 'success',
      data: { attendance }
    });
  } catch (error) {
    next(error);
  }
});

// Update attendance record (for admins and supervisors)
router.patch('/:id', auth, async (req, res, next) => {
  try {
    if (!['admin', 'supervisor'].includes(req.user.role)) {
      return next(new AppError('Not authorized to update attendance records', 403));
    }

    const attendance = await Attendance.findByIdAndUpdate(
      req.params.id,
      {
        ...req.body,
        approvedBy: req.user._id,
        approvalDate: new Date()
      },
      { new: true, runValidators: true }
    );

    if (!attendance) {
      return next(new AppError('Attendance record not found', 404));
    }

    res.json({
      status: 'success',
      data: { attendance }
    });
  } catch (error) {
    next(error);
  }
});

// Get attendance statistics
router.get('/stats/summary', auth, async (req, res, next) => {
  try {
    const { startDate, endDate } = req.query;
    const start = startDate ? new Date(startDate) : new Date(new Date().setDate(1));
    const end = endDate ? new Date(endDate) : new Date();

    const stats = await Attendance.aggregate([
      {
        $match: {
          date: { $gte: start, $lte: end },
          ...(req.user.role !== 'admin' && { userId: req.user._id })
        }
      },
      {
        $group: {
          _id: null,
          totalDays: { $sum: 1 },
          presentDays: {
            $sum: { $cond: [{ $eq: ['$status', 'present'] }, 1, 0] }
          },
          lateDays: {
            $sum: { $cond: [{ $eq: ['$status', 'late'] }, 1, 0] }
          },
          totalHours: { $sum: '$totalHours' },
          totalOvertime: { $sum: '$overtime' },
          avgCheckInTime: { $avg: { $hour: '$checkIn' } }
        }
      }
    ]);

    res.json({
      status: 'success',
      data: {
        stats: stats[0] || {
          totalDays: 0,
          presentDays: 0,
          lateDays: 0,
          totalHours: 0,
          totalOvertime: 0,
          avgCheckInTime: 0
        }
      }
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router; 