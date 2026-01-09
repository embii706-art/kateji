class BeritaModel {
  final String id;
  final String judul;
  final String konten;
  final String? imageUrl;
  final String kategori; // pengumuman / berita
  final bool isPublic;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  BeritaModel({
    required this.id,
    required this.judul,
    required this.konten,
    this.imageUrl,
    this.kategori = 'berita',
    this.isPublic = true,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
  });

  factory BeritaModel.fromMap(Map<String, dynamic> map, String id) {
    return BeritaModel(
      id: id,
      judul: map['judul'] ?? '',
      konten: map['konten'] ?? '',
      imageUrl: map['imageUrl'],
      kategori: map['kategori'] ?? 'berita',
      isPublic: map['isPublic'] ?? true,
      createdBy: map['createdBy'] ?? '',
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'konten': konten,
      'imageUrl': imageUrl,
      'kategori': kategori,
      'isPublic': isPublic,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? DateTime.now(),
    };
  }
}
