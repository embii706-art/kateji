import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/kegiatan_model.dart';

class KegiatanService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference _collection = FirebaseFirestore.instance.collection('kegiatan');

  Future<String> createKegiatan(KegiatanModel kegiatan) async {
    try {
      final doc = await _collection.add(kegiatan.toMap());
      return doc.id;
    } catch (e) {
      print('Error creating kegiatan: $e');
      rethrow;
    }
  }

  Future<void> updateKegiatan(String id, Map<String, dynamic> data) async {
    try {
      await _collection.doc(id).update(data);
    } catch (e) {
      print('Error updating kegiatan: $e');
      rethrow;
    }
  }

  Future<void> deleteKegiatan(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (e) {
      print('Error deleting kegiatan: $e');
      rethrow;
    }
  }

  Stream<List<KegiatanModel>> getKegiatanStream() {
    return _collection
        .orderBy('tanggal', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => KegiatanModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Future<KegiatanModel?> getKegiatan(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (doc.exists) {
        return KegiatanModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting kegiatan: $e');
      return null;
    }
  }

  Future<void> daftarKegiatan(String kegiatanId, String userId) async {
    try {
      await _collection.doc(kegiatanId).update({
        'pesertaIds': FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      print('Error daftar kegiatan: $e');
      rethrow;
    }
  }

  Future<void> absenKegiatan(String kegiatanId, String userId) async {
    try {
      await _collection.doc(kegiatanId).update({
        'absensiIds': FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      print('Error absen kegiatan: $e');
      rethrow;
    }
  }
}
