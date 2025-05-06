const mongoose = require('mongoose');

const accessLogSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'Access log must belong to a user'],
  },
  action: {
    type: String,
    required: [true, 'Please specify the action'],
    enum: ['Unlock Door', 'Lock Door', 'Access Request', 'Access Denied'],
  },
  status: {
    type: String,
    required: [true, 'Please specify the status'],
    enum: ['Approved', 'Pending', 'Denied'],
    default: 'Pending',
  },
  location: {
    type: String,
    required: [true, 'Please specify the location'],
  },
  deviceId: {
    type: String,
    required: [true, 'Please specify the device ID'],
  },
  metadata: {
    type: Map,
    of: mongoose.Schema.Types.Mixed,
  },
  processedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
  },
  processedAt: {
    type: Date,
  },
  timestamp: {
    type: Date,
    default: Date.now,
  },
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true },
});

// Indexes for better query performance
accessLogSchema.index({ userId: 1, timestamp: -1 });
accessLogSchema.index({ status: 1, timestamp: -1 });
accessLogSchema.index({ deviceId: 1, timestamp: -1 });

// Virtual populate with user details
accessLogSchema.virtual('user', {
  ref: 'User',
  foreignField: '_id',
  localField: 'userId',
  justOne: true,
});

const AccessLog = mongoose.model('AccessLog', accessLogSchema);

module.exports = { AccessLog }; 