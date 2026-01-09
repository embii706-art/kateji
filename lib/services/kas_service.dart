import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/kas_model.dart';

class KasService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference _collection = FirebaseFirestore.instance.collection('kas');

  Future<String> createKas(KasModel kas) async {
    try {
      final doc = await _collection.add(kas.toMap());
      return doc.id;
    } catch (e) {
      print('Error creating kas: $e');
      rethrow;
    }
  }

  Future<void> updateKas(String id, Map<String, dynamic> data) async {
    try {
      await _collection.doc(id).update(data);
    } catch (e) {
      print('Error updating kas: $e');
      rethrow;
    }
  }

  Future<void> deleteKas(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (e) {
      print('Error deleting kas: $e');
      rethrow;
    }
  }

  Stream<List<KasModel>> getKasStream() {
    return _collection
        .orderBy('tanggal', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => KasModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Future<double> getSaldo() async {
    try {
      final snapshot = await _collection.get();
      double saldo = 0;
      for (var doc in snapshot.docs) {
        final kas = KasModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        if (kas.jenis == 'masuk') {
          saldo += kas.jumlah;
        } else {
          saldo -= kas.jumlah;
        }
      }
      return saldo;
    } catch (e) {
      print('Error getting saldo: $e');
      return 0;
    }
  }

  Future<Map<String, double>> getKasBulanan(int month, int year) async {
    try {
      final startDate = DateTime(year, month, 1);
      final endDate = DateTime(year, month + 1, 0);

      final snapshot = await _collection
          .where('tanggal', isGreaterThanOrEqualTo: startDate)
          .where('tanggal', isLessThanOrEqualTo: endDate)
          .get();

      double masuk = 0;
      double keluar = 0;

      for (var doc in snapshot.docs) {
        final kas = KasModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        if (kas.jenis == 'masuk') {
          masuk += kas.jumlah;
        } else {
          keluar += kas.jumlah;
        }
      }

      return {'masuk': masuk, 'keluar': keluar};
    } catch (e) {
      print('Error getting kas bulanan: $e');
      return {'masuk': 0, 'keluar': 0};
    }
  }
}
