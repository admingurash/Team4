require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
const helmet = require('helmet');
const mongoSanitize = require('express-mongo-sanitize');
const xss = require('xss-clean');
const compression = require('compression');
const morgan = require('morgan');
const admin = require('firebase-admin');

const config = require('./config/config');
const errorHandler = require('./middleware/error');
const { apiLimiter } = require('./middleware/auth');

// Import routes
const authRoutes = require('./routes/auth');
const attendanceRoutes = require('./routes/attendance');
const userRoutes = require('./routes/user');
const requestsRoutes = require('./routes/requests');
const tasksRoutes = require('./routes/tasks');
const reportsRoutes = require('./routes/reports');

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  databaseURL: process.env.FIREBASE_DATABASE_URL
});

const app = express();

// Set security HTTP headers
app.use(helmet());

// Development logging
if (config.env === 'development') {
  app.use(morgan('dev'));
}

// Rate limiting
app.use('/api', apiLimiter);

// Body parser, reading data from body into req.body
app.use(express.json({ limit: '10kb' }));
app.use(express.urlencoded({ extended: true, limit: '10kb' }));

// Data sanitization against NoSQL query injection
app.use(mongoSanitize());

// Data sanitization against XSS
app.use(xss());

// CORS configuration
app.use(cors(config.cors));

// Compression middleware
app.use(compression());

// Health check endpoint
app.get('/health', (req, res) => {
  const mongoStatus = mongoose.connection.readyState === 1 ? 'connected' : 'disconnected';
  res.status(mongoStatus === 'connected' ? 200 : 503).json({
    status: mongoStatus === 'connected' ? 'success' : 'error',
    message: `Server is running, MongoDB is ${mongoStatus}`,
    timestamp: new Date().toISOString(),
    mongoStatus
  });
});

// Basic route for testing
app.get('/', (req, res) => {
  const mongoStatus = mongoose.connection.readyState === 1 ? 'connected' : 'disconnected';
  res.json({ 
    message: 'AI Attendance System API is running',
    version: '1.0.0',
    environment: config.env,
    mongoStatus
  });
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/attendance', attendanceRoutes);
app.use('/api/users', userRoutes);
app.use('/api/requests', requestsRoutes);
app.use('/api/tasks', tasksRoutes);
app.use('/api/reports', reportsRoutes);

// Handle undefined routes
app.all('*', (req, res, next) => {
  res.status(404).json({
    status: 'error',
    message: `Can't find ${req.originalUrl} on this server!`
  });
});

// Global error handling middleware
app.use(errorHandler);

// Graceful shutdown
const gracefulShutdown = () => {
  console.log('🔄 Received shutdown signal. Starting graceful shutdown...');
  if (mongoose.connection.readyState === 1) {
    mongoose.connection.close(false, () => {
      console.log('📥 MongoDB connection closed.');
      process.exit(0);
    });
  } else {
    process.exit(0);
  }
};

// Handle process termination
process.on('SIGTERM', gracefulShutdown);
process.on('SIGINT', gracefulShutdown);

// Unhandled rejections
process.on('unhandledRejection', (err) => {
  console.error('UNHANDLED REJECTION! 💥 Shutting down...');
  console.error(err.name, err.message);
  process.exit(1);
});

// Uncaught exceptions
process.on('uncaughtException', (err) => {
  console.error('UNCAUGHT EXCEPTION! 💥 Shutting down...');
  console.error(err.name, err.message);
  process.exit(1);
});

// Function to connect to MongoDB with retries
const connectWithRetry = async (retries = 5, interval = 5000) => {
  for (let i = 0; i < retries; i++) {
    try {
      await mongoose.connect(config.mongoUri, config.mongo.options);
      console.log('📦 Connected to MongoDB at:', config.mongoUri);
      return true;
    } catch (err) {
      console.error(`❌ MongoDB connection attempt ${i + 1} failed:`, err.message);
      if (i < retries - 1) {
        console.log(`Retrying in ${interval/1000} seconds...`);
        await new Promise(resolve => setTimeout(resolve, interval));
      }
    }
  }
  return false;
};

// Start server
const startServer = async () => {
  // Try to connect to MongoDB
  const isConnected = await connectWithRetry();
  
  // Start the server even if MongoDB connection fails
  app.listen(config.port, () => {
    console.log(`🚀 Server is running on port ${config.port}`);
    console.log(`🌍 Environment: ${config.env}`);
    if (!isConnected) {
      console.warn('⚠️ Warning: Server started without MongoDB connection');
      console.warn('Some features may not work until MongoDB is available');
    }
  });
};

startServer(); 