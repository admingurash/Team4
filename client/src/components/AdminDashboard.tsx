import React, { useState, useEffect } from 'react';
import '../Admin.css';

interface Scan {
  id: string;
  cardId: string;
  timestamp: string;
  status: string;
}

const AdminDashboard: React.FC = () => {
  const [scans, setScans] = useState<Scan[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [timeRange, setTimeRange] = useState('today');

  const fetchScans = async () => {
    try {
      const response = await fetch('http://localhost:3000/api/scans');
      const data = await response.json();
      setScans(data.scans || []);
      setError('');
    } catch (err) {
      setError('Failed to fetch scan data');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchScans();
    const interval = setInterval(fetchScans, 5000); // Refresh every 5 seconds
    return () => clearInterval(interval);
  }, []);

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleString();
  };

  if (loading) {
    return <div className="loading">Loading...</div>;
  }

  return (
    <div className="admin-container">
      <header className="admin-header">
        <h1>Admin Dashboard</h1>
        <div className="time-range">
          <button 
            className={timeRange === 'today' ? 'active' : ''} 
            onClick={() => setTimeRange('today')}
          >
            Today
          </button>
          <button 
            className={timeRange === 'week' ? 'active' : ''} 
            onClick={() => setTimeRange('week')}
          >
            This Week
          </button>
          <button 
            className={timeRange === 'month' ? 'active' : ''} 
            onClick={() => setTimeRange('month')}
          >
            This Month
          </button>
        </div>
      </header>

      {error && <div className="error-message">{error}</div>}

      <div className="stats-container">
        <div className="stat-card">
          <h3>Total Scans</h3>
          <p>{scans.length}</p>
        </div>
        <div className="stat-card">
          <h3>Successful Scans</h3>
          <p>{scans.filter(scan => scan.status === 'success').length}</p>
        </div>
        <div className="stat-card">
          <h3>Failed Scans</h3>
          <p>{scans.filter(scan => scan.status !== 'success').length}</p>
        </div>
      </div>

      <div className="scans-table">
        <h2>Recent Scans</h2>
        <table>
          <thead>
            <tr>
              <th>Time</th>
              <th>Card ID</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            {scans.map((scan) => (
              <tr key={scan.id}>
                <td>{formatDate(scan.timestamp)}</td>
                <td>{scan.cardId}</td>
                <td className={`status ${scan.status}`}>{scan.status}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default AdminDashboard; 