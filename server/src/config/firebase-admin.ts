import * as admin from 'firebase-admin';
import { ServiceAccount } from 'firebase-admin';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

// Initialize Firebase Admin with your service account
const serviceAccount: ServiceAccount = {
  projectId: "team4-c25a5",
  privateKeyId: "e1e38620428826af6e58382cb7f901afe7a50766",
  clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
  privateKey: process.env.FIREBASE_PRIVATE_KEY,
};

// Initialize the admin app
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: "team4-c25a5.firebasestorage.app"
});

export const db = admin.firestore();
export const auth = admin.auth();
export const storage = admin.storage();

export default admin; 