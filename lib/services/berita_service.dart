import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/berita_model.dart';

class BeritaService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection('berita');

  Future<String> createBerita(BeritaModel berita) async {
    try {
      final doc = await _collection.add(berita.toMap());
      return doc.id;
    } catch (e) {
      print('Error creating berita: $e');
      rethrow;
    }
  }

  Future<void> updateBerita(String id, Map<String, dynamic> data) async {
    try {
      await _collection.doc(id).update(data);
    } catch (e) {
      print('Error updating berita: $e');
      rethrow;
    }
  }

  Future<void> deleteBerita(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (e) {
      print('Error deleting berita: $e');
      rethrow;
    }
  }

  Stream<List<BeritaModel>> getBeritaStream({bool? isPublic}) {
    Query query = _collection.orderBy('createdAt', descending: true);
    
    if (isPublic != null) {
      query = query.where('isPublic', isEqualTo: isPublic);
    }
    
    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => BeritaModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Future<BeritaModel?> getBerita(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (doc.exists) {
        return BeritaModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting berita: $e');
      return null;
    }
  }
}
