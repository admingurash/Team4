import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as app_user;

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "YOUR_API_KEY",
        authDomain: "your-app.firebaseapp.com",
        projectId: "your-project-id",
        storageBucket: "your-app.appspot.com",
        messagingSenderId: "your-sender-id",
        appId: "your-app-id",
      ),
    );
  }

  // Authentication methods
  static Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // User management
  static Future<app_user.User> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) throw 'No user logged in';

    final userDoc =
        await _firestore.collection('users').doc(firebaseUser.uid).get();

    if (!userDoc.exists) throw 'User data not found';

    final userData = userDoc.data()!;
    return app_user.User(
      id: firebaseUser.uid,
      name: userData['name'] ?? '',
      email: firebaseUser.email ?? '',
      role: _parseUserRole(userData['role']),
      department: userData['department'] ?? '',
      permissions: Map<String, bool>.from(userData['permissions'] ?? {}),
    );
  }

  // Real-time updates
  static Stream<List<Map<String, dynamic>>> getRecentActivities() {
    return _firestore
        .collection('activities')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'type': doc.data()['type'],
                'description': doc.data()['description'],
                'timestamp': doc.data()['timestamp'],
                'userId': doc.data()['userId'],
              })
          .toList();
    });
  }

  static Stream<List<Map<String, dynamic>>> getAttendanceRecords() {
    return _firestore
        .collection('attendance')
        .orderBy('checkIn', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'userId': doc.data()['userId'],
                'userName': doc.data()['userName'],
                'checkIn': doc.data()['checkIn'],
                'checkOut': doc.data()['checkOut'],
              })
          .toList();
    });
  }

  // Helper methods
  static app_user.UserRole _parseUserRole(String? role) {
    switch (role?.toLowerCase()) {
      case 'admin':
        return app_user.UserRole.admin;
      case 'manager':
        return app_user.UserRole.manager;
      case 'worker':
        return app_user.UserRole.worker;
      default:
        return app_user.UserRole.guest;
    }
  }

  static String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email';
        case 'wrong-password':
          return 'Wrong password provided';
        case 'user-disabled':
          return 'This user account has been disabled';
        case 'invalid-email':
          return 'Invalid email address';
        default:
          return 'Authentication failed: ${error.message}';
      }
    }
    return 'An unexpected error occurred';
  }

  // Admin methods
  static Future<void> updateUserRole(
    String userId,
    app_user.UserRole newRole,
  ) async {
    await _firestore.collection('users').doc(userId).update({
      'role': newRole.toString().split('.').last,
    });
  }

  static Future<void> updateUserPermissions(
    String userId,
    Map<String, bool> permissions,
  ) async {
    await _firestore.collection('users').doc(userId).update({
      'permissions': permissions,
    });
  }

  // Worker methods
  static Future<void> recordAttendance(
    String userId,
    String userName,
  ) async {
    await _firestore.collection('attendance').add({
      'userId': userId,
      'userName': userName,
      'checkIn': FieldValue.serverTimestamp(),
      'checkOut': null,
    });
  }

  static Future<void> updateAttendance(
    String recordId,
    DateTime checkOut,
  ) async {
    await _firestore.collection('attendance').doc(recordId).update({
      'checkOut': checkOut,
    });
  }

  // Activity logging
  static Future<void> logActivity(
    String userId,
    String type,
    String description,
  ) async {
    await _firestore.collection('activities').add({
      'userId': userId,
      'type': type,
      'description': description,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
