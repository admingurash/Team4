import express from 'express';
import cors from 'cors';
import admin from 'firebase-admin';
import dotenv from 'dotenv';
import QRCode from 'qrcode';
import path from 'path';
import { fileURLToPath } from 'url';

dotenv.config();

const app = express();
const port = process.env.PORT || 3001;

// Get directory name in ES module
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Initialize Firebase Admin
const serviceAccount = {
  type: "service_account",
  project_id: process.env.FIREBASE_PROJECT_ID,
  private_key: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n'),
  client_email: process.env.FIREBASE_CLIENT_EMAIL,
};

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// Enable CORS for all routes
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST'],
  allowedHeaders: ['Content-Type']
}));

app.use(express.json());

// Serve static files from the public directory
app.use(express.static(path.join(__dirname, 'public')));

// Generate QR Code endpoint
app.get('/api/qr', async (req, res) => {
  try {
    const { data } = req.query;
    if (!data) {
      return res.status(400).json({ error: 'Data parameter is required' });
    }

    const qrCode = await QRCode.toDataURL(data);
    res.json({ qrCode });
  } catch (error) {
    console.error('Error generating QR code:', error);
    res.status(500).json({ error: 'Failed to generate QR code' });
  }
});

// Attendance endpoints
app.get('/api/attendance', async (req, res) => {
  try {
    const { startDate, endDate, method } = req.query;
    const attendanceRef = db.collection('attendance');
    let q = attendanceRef.orderBy('timestamp', 'desc');

    if (startDate && endDate) {
      q = attendanceRef.where('timestamp', '>=', startDate).where('timestamp', '<=', endDate);
    }

    if (method) {
      q = attendanceRef.where('method', '==', method);
    }

    const querySnapshot = await q.get();
    const records = [];
    querySnapshot.forEach((doc) => {
      records.push({ id: doc.id, ...doc.data() });
    });
    res.json(records);
  } catch (error) {
    console.error('Error getting attendance records:', error);
    res.status(500).json({ error: 'Failed to get attendance records' });
  }
});

app.get('/api/attendance/stats', async (req, res) => {
  try {
    const { date } = req.query;
    const startOfDay = new Date(date);
    startOfDay.setHours(0, 0, 0, 0);
    const endOfDay = new Date(date);
    endOfDay.setHours(23, 59, 59, 999);

    const attendanceRef = db.collection('attendance');
    const q = attendanceRef.where('timestamp', '>=', startOfDay.toISOString()).where('timestamp', '<=', endOfDay.toISOString());

    const querySnapshot = await q.get();
    const records = [];
    querySnapshot.forEach((doc) => {
      records.push(doc.data());
    });

    const totalPresent = records.filter(r => r.status === 'Present').length;
    const totalAbsent = records.filter(r => r.status === 'Absent').length;
    const total = records.length;

    res.json({
      totalPresent,
      totalAbsent,
      averageAttendance: total > 0 ? (totalPresent / total) * 100 : 0,
      lastUpdated: new Date().toISOString()
    });
  } catch (error) {
    console.error('Error getting attendance stats:', error);
    res.status(500).json({ error: 'Failed to get attendance stats' });
  }
});

app.post('/api/attendance', async (req, res) => {
  try {
    const { timestamp, status, userId, cardId, userName, department } = req.body;
    
    // Add attendance record to Firebase
    const attendanceRef = db.collection('attendance');
    const docRef = await attendanceRef.add({
      timestamp,
      status,
      userId,
      cardId,
      userName,
      department
    });

    res.json({ 
      id: docRef.id,
      timestamp, 
      status, 
      userId, 
      cardId, 
      userName, 
      department 
    });
  } catch (error) {
    console.error('Error recording attendance:', error);
    res.status(500).json({ error: 'Failed to record attendance' });
  }
});

// API endpoints
app.get('/api/scan', async (req, res) => {
  try {
    const cardId = req.query.cardId;
    const timestamp = new Date().toISOString();
    
    // Add scan record to Firebase
    const scanRef = db.collection('scans');
    await scanRef.add({
      cardId,
      timestamp,
      status: 'success'
    });

    res.json({ 
      success: true, 
      message: 'Card scanned successfully',
      timestamp 
    });
  } catch (error) {
    console.error('Error processing scan:', error);
    res.status(500).json({ 
      success: false, 
      error: 'Failed to process card scan' 
    });
  }
});

app.get('/api/scans', async (req, res) => {
  try {
    const scansRef = db.collection('scans');
    const q = scansRef.orderBy('timestamp', 'desc').limit(10);
    const querySnapshot = await q.get();
    const scans = [];
    querySnapshot.forEach((doc) => {
      scans.push({ id: doc.id, ...doc.data() });
    });
    res.json({ scans });
  } catch (error) {
    console.error('Error getting scans:', error);
    res.json({ scans: [] });
  }
});

// Start server
app.listen(port, '0.0.0.0', () => {
  console.log(`Server is running on port ${port}`);
  console.log(`Access the scanner at http://localhost:${port}`);
}); 