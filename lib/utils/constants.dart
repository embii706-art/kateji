class UserRole {
  static const String admin = 'admin';
  static const String pengurus = 'pengurus';
  static const String anggota = 'anggota';
  static const String warga = 'warga';
  static const String ketuaRt = 'ketua_rt';
  
  static List<String> get allRoles => [admin, pengurus, anggota, warga, ketuaRt];
  
  static String getDisplayName(String role) {
    switch (role) {
      case admin:
        return 'Admin Utama';
      case pengurus:
        return 'Pengurus Karang Taruna';
      case anggota:
        return 'Anggota Karang Taruna';
      case warga:
        return 'Warga RT';
      case ketuaRt:
        return 'Ketua RT';
      default:
        return 'Unknown';
    }
  }
}
