import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { auth, db } from './config/firebase-admin';

// Load environment variables
dotenv.config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Authentication middleware
const authenticateAdmin = async (req: express.Request, res: express.Response, next: express.NextFunction) => {
  try {
    const token = req.headers.authorization?.split('Bearer ')[1];
    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    const decodedToken = await auth.verifyIdToken(token);
    const user = await auth.getUser(decodedToken.uid);
    
    // Check if user has admin custom claim
    if (!decodedToken.admin) {
      return res.status(403).json({ error: 'Not authorized' });
    }

    req.user = user;
    next();
  } catch (error) {
    res.status(401).json({ error: 'Invalid token' });
  }
};

// Routes
app.get('/api/attendance', authenticateAdmin, async (req, res) => {
  try {
    const { startDate, endDate, method } = req.query;
    
    let query = db.collection('attendance')
      .orderBy('timestamp', 'desc');
    
    if (startDate) {
      query = query.where('timestamp', '>=', new Date(startDate as string));
    }
    
    if (endDate) {
      query = query.where('timestamp', '<=', new Date(endDate as string));
    }
    
    if (method) {
      query = query.where('method', '==', method);
    }

    const snapshot = await query.get();
    const attendance = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    }));

    res.json(attendance);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch attendance records' });
  }
});

// Add admin claim to user
app.post('/api/users/make-admin', authenticateAdmin, async (req, res) => {
  try {
    const { uid } = req.body;
    await auth.setCustomUserClaims(uid, { admin: true });
    res.json({ message: 'Successfully set admin claim' });
  } catch (error) {
    res.status(500).json({ error: 'Failed to set admin claim' });
  }
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
}); 