import { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';
import { getAuth } from 'firebase/auth';
import { getAnalytics } from 'firebase/analytics';

const firebaseConfig = {
  apiKey: "AIzaSyBJwrKOHhwVaGW4k9tTHV5H9dGRhYEEiGY",
  authDomain: "team4-c25a5.firebaseapp.com",
  projectId: "team4-c25a5",
  storageBucket: "team4-c25a5.appspot.com",
  messagingSenderId: "1098127391764",
  appId: "1:1098127391764:web:e5c9899a728b458e9f68c4"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);
export const auth = getAuth(app);
export const analytics = getAnalytics(app);

export default app; 