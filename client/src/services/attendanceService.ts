import { 
  collection,
  addDoc,
  query,
  where,
  getDocs,
  orderBy,
  Timestamp,
  DocumentData
} from 'firebase/firestore';
import { db } from '../firebase/config';

export interface AttendanceRecord {
  id: string;
  timestamp: string;
  userId: string;
  userName: string;
  method: 'Face' | 'RFID';
  status: string;
}

export interface AttendanceStats {
  totalPresent: number;
  totalAbsent: number;
  averageAttendance: number;
  lastUpdated: string;
}

export const addAttendanceRecord = async (data: Omit<AttendanceRecord, 'id' | 'timestamp'>) => {
  try {
    const docRef = await addDoc(collection(db, 'attendance'), {
      ...data,
      timestamp: Timestamp.now()
    });
    return docRef.id;
  } catch (error) {
    console.error('Error adding attendance record:', error);
    throw error;
  }
};

export const getAttendanceRecords = async (
  startDate: Date,
  endDate: Date,
  method?: 'Face' | 'RFID'
): Promise<AttendanceRecord[]> => {
  const params = new URLSearchParams({
    startDate: startDate.toISOString(),
    endDate: endDate.toISOString(),
    ...(method && { method }),
  });

  const response = await fetch(`http://localhost:3000/api/attendance?${params}`);
  if (!response.ok) {
    throw new Error('Failed to fetch attendance records');
  }
  return response.json();
};

export const getAttendanceStats = async (date: Date): Promise<AttendanceStats> => {
  const params = new URLSearchParams({
    date: date.toISOString(),
  });

  const response = await fetch(`http://localhost:3000/api/attendance/stats?${params}`);
  if (!response.ok) {
    throw new Error('Failed to fetch attendance stats');
  }
  return response.json();
}; 