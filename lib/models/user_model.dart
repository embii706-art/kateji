class UserModel {
  final String id;
  final String email;
  final String nama;
  final String? nik;
  final DateTime? tanggalLahir;
  final String? tempatLahir;
  final String? alamat;
  final String? noHp;
  final String role;
  final String? jabatan;
  final String status; // aktif / nonaktif
  final String? fotoUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.nama,
    this.nik,
    this.tanggalLahir,
    this.tempatLahir,
    this.alamat,
    this.noHp,
    required this.role,
    this.jabatan,
    this.status = 'aktif',
    this.fotoUrl,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      email: map['email'] ?? '',
      nama: map['nama'] ?? '',
      nik: map['nik'],
      tanggalLahir: map['tanggalLahir']?.toDate(),
      tempatLahir: map['tempatLahir'],
      alamat: map['alamat'],
      noHp: map['noHp'],
      role: map['role'] ?? 'warga',
      jabatan: map['jabatan'],
      status: map['status'] ?? 'aktif',
      fotoUrl: map['fotoUrl'],
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'nama': nama,
      'nik': nik,
      'tanggalLahir': tanggalLahir,
      'tempatLahir': tempatLahir,
      'alamat': alamat,
      'noHp': noHp,
      'role': role,
      'jabatan': jabatan,
      'status': status,
      'fotoUrl': fotoUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? DateTime.now(),
    };
  }

  UserModel copyWith({
    String? email,
    String? nama,
    String? nik,
    DateTime? tanggalLahir,
    String? tempatLahir,
    String? alamat,
    String? noHp,
    String? role,
    String? jabatan,
    String? status,
    String? fotoUrl,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id,
      email: email ?? this.email,
      nama: nama ?? this.nama,
      nik: nik ?? this.nik,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      alamat: alamat ?? this.alamat,
      noHp: noHp ?? this.noHp,
      role: role ?? this.role,
      jabatan: jabatan ?? this.jabatan,
      status: status ?? this.status,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
