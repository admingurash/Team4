const jwt = require('jsonwebtoken');
const { promisify } = require('util');
const config = require('../config/config');
const User = require('../models/user');
const { AppError } = require('./error');
const rateLimit = require('express-rate-limit');
const admin = require('firebase-admin');

// Rate limiting middleware
const apiLimiter = rateLimit({
  windowMs: config.rateLimit.windowMs,
  max: config.rateLimit.max,
  message: {
    status: 'error',
    message: 'Too many requests from this IP, please try again later.'
  }
});

// Protect routes - Authentication middleware
const auth = async (req, res, next) => {
  try {
    // 1) Getting token and check if it exists
    let token;
    if (
      req.headers.authorization &&
      req.headers.authorization.startsWith('Bearer')
    ) {
      token = req.headers.authorization.split(' ')[1];
    }

    if (!token) {
      return next(new AppError('Please authenticate', 401));
    }

    // 2) Verify token
    const decoded = jwt.verify(token, config.jwt.secret);

    // 3) Check if user still exists
    const user = await User.findById(decoded.userId);
    if (!user) {
      return next(new AppError('The user belonging to this token no longer exists.', 401));
    }

    // 4) Check if user changed password after the token was issued
    if (user.passwordChangedAt && decoded.iat < user.passwordChangedAt.getTime() / 1000) {
      return next(new AppError('User recently changed password! Please log in again.', 401));
    }

    // Grant access to protected route
    req.user = user;
    next();
  } catch (error) {
    next(new AppError('Please authenticate', 401));
  }
};

// Restrict to certain roles
const restrictTo = (...roles) => {
  return (req, res, next) => {
    if (!roles.includes(req.user.role)) {
      return next(new AppError('You do not have permission to perform this action', 403));
    }
    next();
  };
};

const verifyToken = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        message: 'No token provided'
      });
    }

    const token = authHeader.split(' ')[1];
    const decodedToken = await admin.auth().verifyIdToken(token);
    const user = await User.findByFirebaseUid(decodedToken.uid);

    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'User not found'
      });
    }

    req.user = user;
    next();
  } catch (error) {
    console.error('Auth middleware error:', error);
    res.status(401).json({
      success: false,
      message: 'Invalid token'
    });
  }
};

const checkPermission = (permission) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({
        success: false,
        message: 'User not authenticated'
      });
    }

    if (!req.user.permissions[permission]) {
      return res.status(403).json({
        success: false,
        message: 'Permission denied'
      });
    }

    next();
  };
};

const checkRole = (roles) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({
        success: false,
        message: 'User not authenticated'
      });
    }

    if (!roles.includes(req.user.role)) {
      return res.status(403).json({
        success: false,
        message: 'Role not authorized'
      });
    }

    next();
  };
};

module.exports = {
  auth,
  restrictTo,
  apiLimiter,
  verifyToken,
  checkPermission,
  checkRole
}; 