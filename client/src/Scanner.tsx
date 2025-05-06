import React, { useState, useEffect } from 'react';
import './Scanner.css';

// Use your computer's IP address
const SERVER_URL = 'http://10.201.5.85:3000';

const Scanner: React.FC = () => {
  const [cardId, setCardId] = useState('');
  const [message, setMessage] = useState('');
  const [scans, setScans] = useState<any[]>([]);
  const [isLoading, setIsLoading] = useState(false);

  const handleScan = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    try {
      const response = await fetch(`${SERVER_URL}/api/scan?cardId=${cardId}`);
      const data = await response.json();
      if (data.success) {
        setMessage('Card scanned successfully!');
        setCardId('');
        fetchRecentScans();
      } else {
        setMessage('Scan failed. Please try again.');
      }
    } catch (error) {
      setMessage('Error connecting to server. Please try again.');
    }
    setIsLoading(false);
  };

  const fetchRecentScans = async () => {
    try {
      const response = await fetch(`${SERVER_URL}/api/scans`);
      const data = await response.json();
      setScans(data);
    } catch (error) {
      console.error('Error fetching scans:', error);
    }
  };

  useEffect(() => {
    fetchRecentScans();
    const interval = setInterval(fetchRecentScans, 5000); // Refresh every 5 seconds
    return () => clearInterval(interval);
  }, []);

  return (
    <div className="scanner-container">
      <h1>Card Scanner</h1>
      
      <form onSubmit={handleScan} className="scan-form">
        <input
          type="text"
          value={cardId}
          onChange={(e) => setCardId(e.target.value)}
          placeholder="Enter or Scan Card ID"
          required
          className="card-input"
          autoFocus
        />
        <button type="submit" disabled={isLoading} className="scan-button">
          {isLoading ? 'Scanning...' : 'Scan Card'}
        </button>
      </form>

      {message && (
        <div className={`message ${message.includes('successfully') ? 'success' : 'error'}`}>
          {message}
        </div>
      )}

      <div className="recent-scans">
        <h2>Recent Scans</h2>
        <div className="scans-list">
          {scans.map((scan) => (
            <div key={scan.id} className="scan-item">
              <div className="scan-time">
                {new Date(scan.timestamp).toLocaleTimeString()}
              </div>
              <div className="scan-id">
                Card ID: {scan.cardId}
              </div>
              <div className="scan-status">
                Status: {scan.status}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default Scanner; 