import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Route, Routes, Navigate } from 'react-router-dom';
import Scanner from './Scanner';
import AdminDashboard from './components/AdminDashboard';
import './App.css';

interface AttendanceRecord {
  id: string;
  timestamp: string;
  status: string;
  userId: string;
  cardId: string;
  userName?: string;
  department?: string;
}

interface User {
  userId: string;
  cardId: string;
  name: string;
  department: string;
  password: string;
}

// Simulated user database
const MOCK_USERS: { [key: string]: User } = {
  '12345678': {
    userId: '12345678',
    cardId: 'CARD001',
    name: 'John Doe',
    department: 'Computer Science',
    password: '1234'
  },
  '87654321': {
    userId: '87654321',
    cardId: 'CARD002',
    name: 'Jane Smith',
    department: 'Engineering',
    password: '4321'
  }
};

function App() {
  const isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
  const [records, setRecords] = useState<AttendanceRecord[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);
  const [user, setUser] = useState<User | null>(null);
  const [cardInput, setCardInput] = useState('');
  const [password, setPassword] = useState('');
  const [scanning, setScanning] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [isLocked, setIsLocked] = useState(true);
  const [foundUser, setFoundUser] = useState<User | null>(null);
  const [qrCode, setQrCode] = useState<string>('');

  useEffect(() => {
    if (user) {
      const fetchRecords = async () => {
        try {
          const response = await fetch('http://localhost:3000/api/attendance');
          const data = await response.json();
          setRecords(data);
          setLoading(false);
        } catch (err) {
          console.error('Error fetching records:', err);
          setError('Failed to fetch attendance records');
          setLoading(false);
        }
      };

      const interval = setInterval(fetchRecords, 5000);
      fetchRecords();

      return () => clearInterval(interval);
    }
  }, [user]);

  useEffect(() => {
    const generateQRCode = async () => {
      if (user) {
        try {
          const response = await fetch(`http://localhost:3000/api/qr?data=${encodeURIComponent(JSON.stringify({
            userId: user.userId,
            name: user.name,
            department: user.department
          }))}`);
          const data = await response.json();
          setQrCode(data.qrCode);
        } catch (err) {
          console.error('Error generating QR code:', err);
          setError('Failed to generate QR code');
        }
      }
    };

    generateQRCode();
  }, [user]);

  const simulateCardScan = () => {
    setScanning(true);
    // Simulate card scanning process
    setTimeout(() => {
      const randomUser = Object.values(MOCK_USERS)[Math.floor(Math.random() * Object.values(MOCK_USERS).length)];
      setFoundUser(randomUser);
      setShowPassword(true);
      setScanning(false);
    }, 1500);
  };

  const handleManualLogin = (e: React.FormEvent) => {
    e.preventDefault();
    const user = MOCK_USERS[cardInput];
    if (user) {
      setFoundUser(user);
      setShowPassword(true);
    } else {
      setError('Invalid card or user ID');
    }
  };

  const handlePasswordSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (foundUser && password === foundUser.password) {
      setIsLocked(false);
      // Simulate unlock animation
      setTimeout(() => {
        handleLogin(foundUser);
      }, 1000);
    } else {
      setError('Invalid password');
      setPassword('');
    }
  };

  const handleLogin = (user: User) => {
    setUser(user);
    setError(null);
    recordAttendance(user);
    // Reset states
    setFoundUser(null);
    setPassword('');
    setShowPassword(false);
    setIsLocked(true);
  };

  const recordAttendance = async (user: User) => {
    try {
      const response = await fetch('http://localhost:3000/api/attendance', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          timestamp: new Date().toISOString(),
          status: 'Present',
          userId: user.userId,
          cardId: user.cardId,
          userName: user.name,
          department: user.department
        }),
      });

      if (!response.ok) {
        throw new Error('Failed to record attendance');
      }

      const newRecord = await response.json();
      setRecords(prev => [newRecord, ...prev]);
    } catch (err) {
      console.error('Error recording attendance:', err);
      setError('Failed to record attendance');
    }
  };

  const handleLogout = () => {
    setUser(null);
    setRecords([]);
    setCardInput('');
    setPassword('');
    setShowPassword(false);
    setIsLocked(true);
    setQrCode('');
  };

  return (
    <Router>
      <div className="App">
        <Routes>
          <Route path="/scanner" element={<Scanner />} />
          <Route path="/admin" element={<AdminDashboard />} />
          <Route path="/" element={
            isMobile ? <Navigate to="/scanner" /> : <Navigate to="/admin" />
          } />
        </Routes>
        {user && qrCode && (
          <div className="qr-code-container">
            <h3>Your QR Code</h3>
            <img src={qrCode} alt="QR Code" />
          </div>
        )}
      </div>
    </Router>
  );
}

export default App; 