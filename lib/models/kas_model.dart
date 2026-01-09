class KasModel {
  final String id;
  final String jenis; // masuk / keluar
  final double jumlah;
  final String kategori;
  final String keterangan;
  final DateTime tanggal;
  final String? buktiUrl;
  final String createdBy;
  final DateTime createdAt;

  KasModel({
    required this.id,
    required this.jenis,
    required this.jumlah,
    required this.kategori,
    required this.keterangan,
    required this.tanggal,
    this.buktiUrl,
    required this.createdBy,
    required this.createdAt,
  });

  factory KasModel.fromMap(Map<String, dynamic> map, String id) {
    return KasModel(
      id: id,
      jenis: map['jenis'] ?? 'masuk',
      jumlah: (map['jumlah'] ?? 0).toDouble(),
      kategori: map['kategori'] ?? '',
      keterangan: map['keterangan'] ?? '',
      tanggal: map['tanggal']?.toDate() ?? DateTime.now(),
      buktiUrl: map['buktiUrl'],
      createdBy: map['createdBy'] ?? '',
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jenis': jenis,
      'jumlah': jumlah,
      'kategori': kategori,
      'keterangan': keterangan,
      'tanggal': tanggal,
      'buktiUrl': buktiUrl,
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
  }
}
