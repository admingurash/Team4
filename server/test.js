import fetch from 'node-fetch';

async function testEndpoints() {
  try {
    // Test main endpoint
    console.log('Testing main endpoint...');
    const mainResponse = await fetch('http://localhost:3001');
    const mainData = await mainResponse.json();
    console.log('Main endpoint response:', mainData);

    // Test attendance endpoint
    console.log('\nTesting attendance endpoint...');
    const attendanceResponse = await fetch('http://localhost:3001/api/attendance');
    const attendanceData = await attendanceResponse.json();
    console.log('Attendance records:', attendanceData);

    // Test authentication
    console.log('\nTesting authentication...');
    const authResponse = await fetch('http://localhost:3001/api/auth/verify', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        userId: '12345678',
        password: '1234'
      })
    });
    const authData = await authResponse.json();
    console.log('Authentication response:', authData);

  } catch (error) {
    console.error('Error testing endpoints:', error);
  }
}

testEndpoints(); 