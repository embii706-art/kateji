class KegiatanModel {
  final String id;
  final String judul;
  final String deskripsi;
  final DateTime tanggal;
  final String waktu;
  final String lokasi;
  final String? kategori;
  final int? maxPeserta;
  final List<String> pesertaIds;
  final List<String> absensiIds;
  final List<String> fotoUrls;
  final String status; // dijadwalkan, berlangsung, selesai, dibatalkan
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  KegiatanModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.tanggal,
    required this.waktu,
    required this.lokasi,
    this.kategori,
    this.maxPeserta,
    this.pesertaIds = const [],
    this.absensiIds = const [],
    this.fotoUrls = const [],
    this.status = 'dijadwalkan',
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
  });

  factory KegiatanModel.fromMap(Map<String, dynamic> map, String id) {
    return KegiatanModel(
      id: id,
      judul: map['judul'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      tanggal: map['tanggal']?.toDate() ?? DateTime.now(),
      waktu: map['waktu'] ?? '',
      lokasi: map['lokasi'] ?? '',
      kategori: map['kategori'],
      maxPeserta: map['maxPeserta'],
      pesertaIds: List<String>.from(map['pesertaIds'] ?? []),
      absensiIds: List<String>.from(map['absensiIds'] ?? []),
      fotoUrls: List<String>.from(map['fotoUrls'] ?? []),
      status: map['status'] ?? 'dijadwalkan',
      createdBy: map['createdBy'] ?? '',
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'deskripsi': deskripsi,
      'tanggal': tanggal,
      'waktu': waktu,
      'lokasi': lokasi,
      'kategori': kategori,
      'maxPeserta': maxPeserta,
      'pesertaIds': pesertaIds,
      'absensiIds': absensiIds,
      'fotoUrls': fotoUrls,
      'status': status,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? DateTime.now(),
    };
  }
}
