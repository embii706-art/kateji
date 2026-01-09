class AspirasiModel {
  final String id;
  final String judul;
  final String isi;
  final String kategori;
  final String status; // pending / diproses / selesai / ditolak
  final String? balasan;
  final String createdBy;
  final String? createdByName;
  final String? dibalasOleh;
  final DateTime createdAt;
  final DateTime? updatedAt;

  AspirasiModel({
    required this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    this.status = 'pending',
    this.balasan,
    required this.createdBy,
    this.createdByName,
    this.dibalasOleh,
    required this.createdAt,
    this.updatedAt,
  });

  factory AspirasiModel.fromMap(Map<String, dynamic> map, String id) {
    return AspirasiModel(
      id: id,
      judul: map['judul'] ?? '',
      isi: map['isi'] ?? '',
      kategori: map['kategori'] ?? '',
      status: map['status'] ?? 'pending',
      balasan: map['balasan'],
      createdBy: map['createdBy'] ?? '',
      createdByName: map['createdByName'],
      dibalasOleh: map['dibalasOleh'],
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'isi': isi,
      'kategori': kategori,
      'status': status,
      'balasan': balasan,
      'createdBy': createdBy,
      'createdByName': createdByName,
      'dibalasOleh': dibalasOleh,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? DateTime.now(),
    };
  }
}
