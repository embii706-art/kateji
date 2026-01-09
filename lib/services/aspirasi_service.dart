import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/aspirasi_model.dart';

class AspirasiService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection('aspirasi');

  Future<String> createAspirasi(AspirasiModel aspirasi) async {
    try {
      final doc = await _collection.add(aspirasi.toMap());
      return doc.id;
    } catch (e) {
      print('Error creating aspirasi: $e');
      rethrow;
    }
  }

  Future<void> updateAspirasi(String id, Map<String, dynamic> data) async {
    try {
      await _collection.doc(id).update(data);
    } catch (e) {
      print('Error updating aspirasi: $e');
      rethrow;
    }
  }

  Future<void> deleteAspirasi(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (e) {
      print('Error deleting aspirasi: $e');
      rethrow;
    }
  }

  Stream<List<AspirasiModel>> getAspirasiStream({String? userId, String? status}) {
    Query query = _collection;
    
    if (userId != null) {
      query = query.where('createdBy', isEqualTo: userId);
    }
    
    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }
    
    query = query.orderBy('createdAt', descending: true);
    
    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => AspirasiModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Future<void> balasAspirasi(String id, String balasan, String dibalasOleh) async {
    try {
      await _collection.doc(id).update({
        'balasan': balasan,
        'dibalasOleh': dibalasOleh,
        'status': 'selesai',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error balas aspirasi: $e');
      rethrow;
    }
  }
}
