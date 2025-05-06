import React, { useState, useEffect } from 'react';
import { Grid, Paper } from '@mui/material';
import {
  ResponsiveContainer,
  ScatterChart,
  Scatter,
  CartesianGrid,
  XAxis,
  YAxis,
  Tooltip,
  TooltipProps
} from 'recharts';
import '../Admin.css';

interface Scan {
  id: string;
  cardId: string;
  timestamp: string;
  status: string;
}

interface ScatterDataPoint {
  x: number;
  y: number;
  status: string;
  cardId: string;
}

const AdminPanel: React.FC = () => {
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

  // Transform scan data for the scatter plot
  const scatterData: ScatterDataPoint[] = scans.map(scan => ({
    x: new Date(scan.timestamp).getTime(),
    y: scan.status === 'success' ? 1 : 0,
    status: scan.status,
    cardId: scan.cardId
  }));

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

      <Grid container spacing={3}>
        <Grid item xs={12} sm={4}>
          <Paper className="stat-card" elevation={2}>
            <h3>Total Scans</h3>
            <p>{scans.length}</p>
          </Paper>
        </Grid>
        <Grid item xs={12} sm={4}>
          <Paper className="stat-card" elevation={2}>
            <h3>Successful Scans</h3>
            <p>{scans.filter(scan => scan.status === 'success').length}</p>
          </Paper>
        </Grid>
        <Grid item xs={12} sm={4}>
          <Paper className="stat-card" elevation={2}>
            <h3>Failed Scans</h3>
            <p>{scans.filter(scan => scan.status !== 'success').length}</p>
          </Paper>
        </Grid>
      </Grid>

      <div style={{ width: '100%', height: 300 }}>
        <ResponsiveContainer>
          <ScatterChart
            margin={{ top: 20, right: 20, bottom: 20, left: 20 }}
          >
            <CartesianGrid />
            <XAxis
              type="number"
              dataKey="x"
              name="Time"
              domain={['auto', 'auto']}
              tickFormatter={(unixTime: number) => new Date(unixTime).toLocaleTimeString()}
            />
            <YAxis
              type="number"
              dataKey="y"
              name="Status"
              domain={[0, 1]}
              tickFormatter={(value: number) => value === 1 ? 'Success' : 'Failed'}
            />
            <Tooltip
              cursor={{ strokeDasharray: '3 3' }}
              content={(props: TooltipProps<number, string>) => {
                const { payload } = props;
                if (payload && payload[0]) {
                  const data = payload[0].payload as ScatterDataPoint;
                  return (
                    <div className="custom-tooltip">
                      <p>Time: {new Date(data.x).toLocaleString()}</p>
                      <p>Status: {data.status}</p>
                      <p>Card ID: {data.cardId}</p>
                    </div>
                  );
                }
                return null;
              }}
            />
            <Scatter
              data={scatterData}
              fill="#8884d8"
            />
          </ScatterChart>
        </ResponsiveContainer>
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

export default AdminPanel; 