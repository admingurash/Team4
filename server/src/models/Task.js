const mongoose = require('mongoose');

const taskSchema = new mongoose.Schema({
  workerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'Task must be assigned to a worker'],
  },
  title: {
    type: String,
    required: [true, 'Please provide a task title'],
    trim: true,
  },
  description: {
    type: String,
    required: [true, 'Please provide a task description'],
  },
  status: {
    type: String,
    enum: ['Pending', 'In Progress', 'Completed', 'Cancelled'],
    default: 'Pending',
  },
  priority: {
    type: String,
    enum: ['Low', 'Medium', 'High', 'Urgent'],
    default: 'Medium',
  },
  dueDate: {
    type: Date,
    required: [true, 'Please specify the due date'],
  },
  assignedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'Task must have an assigner'],
  },
  relatedRequests: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'AccessLog',
  }],
  notes: {
    type: String,
    trim: true,
  },
  completedAt: {
    type: Date,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true },
});

// Indexes for better query performance
taskSchema.index({ workerId: 1, status: 1 });
taskSchema.index({ dueDate: 1 });
taskSchema.index({ priority: 1 });

// Virtual populate with worker details
taskSchema.virtual('worker', {
  ref: 'User',
  foreignField: '_id',
  localField: 'workerId',
  justOne: true,
});

// Virtual populate with assigner details
taskSchema.virtual('assigner', {
  ref: 'User',
  foreignField: '_id',
  localField: 'assignedBy',
  justOne: true,
});

const Task = mongoose.model('Task', taskSchema);

module.exports = { Task }; 