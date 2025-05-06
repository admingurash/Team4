const mongoose = require('mongoose');

const activityLogSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  action: {
    type: String,
    required: true,
    enum: [
      'login',
      'logout',
      'create_request',
      'update_request',
      'approve_request',
      'deny_request',
      'create_task',
      'update_task',
      'complete_task',
      'create_user',
      'update_user',
      'delete_user',
      'view_report',
      'export_data'
    ]
  },
  details: {
    type: Map,
    of: mongoose.Schema.Types.Mixed
  },
  ipAddress: String,
  userAgent: String,
  timestamp: {
    type: Date,
    default: Date.now
  },
  affectedUser: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  affectedResource: {
    type: mongoose.Schema.Types.ObjectId,
    refPath: 'resourceType'
  },
  resourceType: {
    type: String,
    enum: ['Request', 'Task', 'User']
  }
}, {
  timestamps: true
});

// Indexes for better query performance
activityLogSchema.index({ userId: 1, timestamp: -1 });
activityLogSchema.index({ action: 1, timestamp: -1 });
activityLogSchema.index({ affectedUser: 1, timestamp: -1 });

module.exports = mongoose.model('ActivityLog', activityLogSchema); 