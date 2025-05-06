const mongoose = require('mongoose');

const requestSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  type: {
    type: String,
    enum: ['rfid', 'door_unlock', 'access_card'],
    required: true
  },
  status: {
    type: String,
    enum: ['pending', 'approved', 'denied'],
    default: 'pending'
  },
  location: {
    type: String,
    required: true
  },
  timestamp: {
    type: Date,
    default: Date.now
  },
  processedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  processedAt: Date,
  notes: String,
  metadata: {
    type: Map,
    of: mongoose.Schema.Types.Mixed
  }
}, {
  timestamps: true
});

// Indexes for better query performance
requestSchema.index({ userId: 1, timestamp: -1 });
requestSchema.index({ status: 1, timestamp: -1 });
requestSchema.index({ processedBy: 1, timestamp: -1 });

module.exports = mongoose.model('Request', requestSchema); 