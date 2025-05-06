const mongoose = require('mongoose');

const attendanceSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'Attendance must belong to a user']
  },
  date: {
    type: Date,
    required: [true, 'Attendance must have a date'],
    default: Date.now
  },
  checkIn: {
    type: Date,
    required: [true, 'Check-in time is required']
  },
  checkOut: {
    type: Date
  },
  status: {
    type: String,
    enum: ['present', 'late', 'early-leave', 'absent', 'half-day'],
    default: 'present'
  },
  workLocation: {
    type: String,
    enum: ['office', 'remote', 'hybrid'],
    required: [true, 'Work location is required']
  },
  notes: {
    type: String,
    trim: true,
    maxlength: [500, 'Notes cannot be longer than 500 characters']
  },
  totalHours: {
    type: Number,
    min: [0, 'Total hours cannot be negative']
  },
  breakTime: {
    type: Number,
    default: 0,
    min: [0, 'Break time cannot be negative']
  },
  overtime: {
    type: Number,
    default: 0,
    min: [0, 'Overtime cannot be negative']
  },
  approvedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  approvalStatus: {
    type: String,
    enum: ['pending', 'approved', 'rejected'],
    default: 'pending'
  },
  approvalDate: Date,
  approvalNotes: String,
  location: {
    type: {
      type: String,
      enum: ['Point'],
      default: 'Point'
    },
    coordinates: {
      type: [Number],
      required: true
    },
    address: String
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Indexes
attendanceSchema.index({ userId: 1, date: -1 });
attendanceSchema.index({ location: '2dsphere' });

// Virtual field for duration
attendanceSchema.virtual('duration').get(function() {
  if (!this.checkOut) return 0;
  return (this.checkOut - this.checkIn) / (1000 * 60 * 60); // Duration in hours
});

// Middleware to calculate total hours before save
attendanceSchema.pre('save', function(next) {
  if (this.checkIn && this.checkOut) {
    this.totalHours = (this.checkOut - this.checkIn) / (1000 * 60 * 60);
    
    // Subtract break time if any
    if (this.breakTime) {
      this.totalHours -= this.breakTime;
    }
    
    // Calculate overtime (assuming 8-hour workday)
    if (this.totalHours > 8) {
      this.overtime = this.totalHours - 8;
    }

    // Update status based on check-in time
    const checkInHour = this.checkIn.getHours();
    if (checkInHour >= 10) { // Assuming work starts at 9 AM
      this.status = 'late';
    }
  }
  next();
});

// Static method to get attendance statistics
attendanceSchema.statics.getStats = async function(userId, startDate, endDate) {
  return this.aggregate([
    {
      $match: {
        userId: mongoose.Types.ObjectId(userId),
        date: { $gte: startDate, $lte: endDate }
      }
    },
    {
      $group: {
        _id: null,
        totalDays: { $sum: 1 },
        presentDays: {
          $sum: {
            $cond: [{ $eq: ['$status', 'present'] }, 1, 0]
          }
        },
        lateDays: {
          $sum: {
            $cond: [{ $eq: ['$status', 'late'] }, 1, 0]
          }
        },
        totalHours: { $sum: '$totalHours' },
        totalOvertime: { $sum: '$overtime' }
      }
    }
  ]);
};

const Attendance = mongoose.model('Attendance', attendanceSchema);

module.exports = Attendance; 