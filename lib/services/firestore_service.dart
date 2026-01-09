import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Users
  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _db.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<void> createUser(String userId, UserModel user) async {
    try {
      await _db.collection('users').doc(userId).set(user.toMap());
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(userId).update(data);
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  Stream<List<UserModel>> getUsersStream() {
    return _db.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  // Check if this is the first user (for auto super admin)
  Future<bool> isFirstUser() async {
    try {
      final snapshot = await _db.collection('users').limit(1).get();
      return snapshot.docs.isEmpty;
    } catch (e) {
      print('Error checking first user: $e');
      return false;
    }
  }

  // Log Aktivitas
  Future<void> logActivity({
    required String userId,
    required String action,
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _db.collection('log_aktivitas').add({
        'userId': userId,
        'action': action,
        'description': description,
        'metadata': metadata,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error logging activity: $e');
    }
  }
}
