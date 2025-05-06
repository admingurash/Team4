import React, { useState, useEffect } from 'react';
import './App.css';

interface User {
  id: string;
  name: string;
  email: string;
  cardId: string;
  department: string;
}

interface AttendanceRecord {
  id: string;
  date: string;
  user: string;
  action: string;
  status: string;
  location: string;
}

interface SystemLog {
  id: string;
  message: string;
  severity: 'info' | 'warning' | 'error';
  timestamp: string;
}

interface CloudStorage {
  used: number;
  total: number;
  backups: Array<{
    id: string;
    name: string;
    createdAt: string;
  }>;
}

function App() {
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [activeTab, setActiveTab] = useState('dashboard');
  const [users, setUsers] = useState<User[]>([]);
  const [attendance, setAttendance] = useState<AttendanceRecord[]>([]);
  const [systemLogs, setSystemLogs] = useState<SystemLog[]>([]);
  const [cloudStorage, setCloudStorage] = useState<CloudStorage | null>(null);
  const [timeRange, setTimeRange] = useState('7days');
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');

  // Mock data for demonstration
  useEffect(() => {
    if (isLoggedIn) {
      // Mock users
      setUsers([
        { id: '1', name: 'User 1', email: 'user1@example.com', cardId: 'CARD001', department: 'IT' },
        { id: '2', name: 'User 2', email: 'user2@example.com', cardId: 'CARD002', department: 'HR' },
      ]);

      // Mock attendance records
      setAttendance([
        { id: '1', date: '2024-03-01', user: 'User 1', action: 'Card Scan', status: 'Success', location: 'Location 1' },
        { id: '2', date: '2024-03-02', user: 'User 2', action: 'Card Scan', status: 'Pending', location: 'Location 2' },
      ]);

      // Mock system logs
      setSystemLogs([
        { id: '1', message: 'Sample log message for system event with info severity', severity: 'info', timestamp: '2024-03-01 10:00:00' },
        { id: '2', message: 'Sample log message for access event with warning severity', severity: 'warning', timestamp: '2024-03-01 11:00:00' },
        { id: '3', message: 'Sample log message for card event with error severity', severity: 'error', timestamp: '2024-03-01 12:00:00' },
      ]);

      // Mock cloud storage
      setCloudStorage({
        used: 7.5,
        total: 10,
        backups: [
          { id: '1', name: 'Backup 1', createdAt: '2024-03-01 10:00:00' },
          { id: '2', name: 'Backup 2', createdAt: '2024-03-02 10:00:00' },
          { id: '3', name: 'Backup 3', createdAt: '2024-03-03 10:00:00' },
        ]
      });
    }
  }, [isLoggedIn]);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const response = await fetch('http://localhost:3001/api/admin/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username, password }),
      });

      if (response.ok) {
        const data = await response.json();
        localStorage.setItem('adminToken', data.token);
        setIsLoggedIn(true);
        setError('');
      } else {
        setError('Invalid credentials');
      }
    } catch (err) {
      setError('Login failed');
    }
  };

  if (!isLoggedIn) {
    return (
      <div className="login-container">
        <div className="login-box">
          <h2>Admin Login</h2>
          {error && <div className="error">{error}</div>}
          <form onSubmit={handleLogin}>
            <input
              type="text"
              placeholder="Username"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
            />
            <input
              type="password"
              placeholder="Password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
            <button type="submit">Login</button>
          </form>
        </div>
      </div>
    );
  }

  return (
    <div className="admin-dashboard">
      <nav className="sidebar">
        <div className="logo">
          <h2>Admin Panel</h2>
        </div>
        <ul>
          <li className={activeTab === 'dashboard' ? 'active' : ''} onClick={() => setActiveTab('dashboard')}>
            Dashboard
          </li>
          <li className={activeTab === 'users' ? 'active' : ''} onClick={() => setActiveTab('users')}>
            Manage Users
          </li>
          <li className={activeTab === 'reports' ? 'active' : ''} onClick={() => setActiveTab('reports')}>
            Reports
          </li>
          <li className={activeTab === 'logs' ? 'active' : ''} onClick={() => setActiveTab('logs')}>
            System Logs
          </li>
          <li className={activeTab === 'storage' ? 'active' : ''} onClick={() => setActiveTab('storage')}>
            Cloud Storage
          </li>
          <li onClick={() => setIsLoggedIn(false)}>Logout</li>
        </ul>
      </nav>

      <main className="content">
        {activeTab === 'dashboard' && (
          <div className="dashboard">
            <h2>Dashboard</h2>
            <div className="chart-container">
              <h3>Access Trends</h3>
              {/* Add chart component here */}
            </div>
            <div className="recent-activity">
              <h3>Recent Activity</h3>
              <table>
                <thead>
                  <tr>
                    <th>User</th>
                    <th>Action</th>
                    <th>Status</th>
                    <th>Location</th>
                    <th>Time</th>
                  </tr>
                </thead>
                <tbody>
                  {attendance.map(record => (
                    <tr key={record.id}>
                      <td>{record.user}</td>
                      <td>{record.action}</td>
                      <td>{record.status}</td>
                      <td>{record.location}</td>
                      <td>{record.date}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}

        {activeTab === 'users' && (
          <div className="users">
            <div className="header">
              <h2>Manage Users</h2>
              <button className="create-user">Create User</button>
              <button className="export-users">Export Data</button>
            </div>
            <table>
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Email</th>
                  <th>Card ID</th>
                  <th>Department</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {users.map(user => (
                  <tr key={user.id}>
                    <td>{user.name}</td>
                    <td>{user.email}</td>
                    <td>{user.cardId}</td>
                    <td>{user.department}</td>
                    <td>
                      <button className="edit">Edit</button>
                      <button className="delete">Delete</button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}

        {activeTab === 'reports' && (
          <div className="reports">
            <div className="header">
              <h2>Reports</h2>
              <div className="time-range">
                <button className={timeRange === '7days' ? 'active' : ''} onClick={() => setTimeRange('7days')}>Last 7 Days</button>
                <button className={timeRange === '30days' ? 'active' : ''} onClick={() => setTimeRange('30days')}>Last 30 Days</button>
                <button className={timeRange === '90days' ? 'active' : ''} onClick={() => setTimeRange('90days')}>Last 90 Days</button>
              </div>
              <button className="generate-report">Generate Report</button>
            </div>
            <div className="chart-container">
              {/* Add chart component here */}
            </div>
            <div className="detailed-report">
              <h3>Detailed Report</h3>
              <table>
                <thead>
                  <tr>
                    <th>Date</th>
                    <th>User</th>
                    <th>Action</th>
                    <th>Status</th>
                    <th>Location</th>
                  </tr>
                </thead>
                <tbody>
                  {attendance.map(record => (
                    <tr key={record.id}>
                      <td>{record.date}</td>
                      <td>{record.user}</td>
                      <td>{record.action}</td>
                      <td>{record.status}</td>
                      <td>{record.location}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}

        {activeTab === 'logs' && (
          <div className="system-logs">
            <div className="header">
              <h2>System Logs</h2>
              <select>
                <option value="all">All Types</option>
                <option value="info">Info</option>
                <option value="warning">Warning</option>
                <option value="error">Error</option>
              </select>
            </div>
            <div className="logs-container">
              {systemLogs.map(log => (
                <div key={log.id} className={`log-entry ${log.severity}`}>
                  <span className="timestamp">{log.timestamp}</span>
                  <span className="message">{log.message}</span>
                </div>
              ))}
            </div>
          </div>
        )}

        {activeTab === 'storage' && (
          <div className="cloud-storage">
            <h2>Cloud Storage</h2>
            {cloudStorage && (
              <>
                <div className="storage-overview">
                  <div className="storage-chart">
                    <div className="storage-usage" style={{ '--percentage': `${(cloudStorage.used / cloudStorage.total) * 100}%` } as React.CSSProperties}>
                      <span>{Math.round((cloudStorage.used / cloudStorage.total) * 100)}%</span>
                    </div>
                  </div>
                  <div className="storage-details">
                    <p>Used: {cloudStorage.used}GB</p>
                    <p>Total: {cloudStorage.total}GB</p>
                  </div>
                </div>
                <div className="backup-settings">
                  <h3>Backup Settings</h3>
                  <div className="setting">
                    <label>Automatic Backup</label>
                    <input type="checkbox" />
                  </div>
                  <div className="setting">
                    <label>Backup Schedule</label>
                    <select>
                      <option>Every Hour</option>
                      <option>Daily</option>
                      <option>Weekly</option>
                    </select>
                  </div>
                </div>
                <div className="recent-backups">
                  <h3>Recent Backups</h3>
                  {cloudStorage.backups.map(backup => (
                    <div key={backup.id} className="backup-item">
                      <span>{backup.name}</span>
                      <span>{backup.createdAt}</span>
                    </div>
                  ))}
                </div>
              </>
            )}
          </div>
        )}
      </main>
    </div>
  );
}

export default App; 