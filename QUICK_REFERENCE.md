# 🚀 KARTEJI - Quick Reference

## 📱 Login Credentials (Testing)

### Default Admin
```
Email: admin@karteji.com
Password: admin123
```

> ⚠️ Ubah password setelah login pertama!

---

## 🎯 Quick Commands

### Development
```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Run with hot reload
flutter run --hot

# Clean build
flutter clean && flutter pub get
```

### Build & Deploy
```bash
# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release

# Deploy Firebase Rules
firebase deploy --only firestore:rules,storage
```

### Testing
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze
```

---

## 📂 Important Files

### Configuration
- `lib/firebase_options.dart` - Firebase config
- `lib/services/cloudinary_service.dart` - Cloudinary config
- `android/app/google-services.json` - Google services
- `firestore.rules` - Firestore security rules
- `storage.rules` - Storage security rules

### Core Files
- `lib/main.dart` - Entry point
- `lib/providers/auth_provider.dart` - Authentication state
- `lib/models/` - Data models
- `lib/services/` - Business logic
- `lib/screens/` - UI screens

---

## 🗂️ Collections Quick Reference

### users
```dart
users/{userId}
  - email: string
  - nama: string
  - role: admin|pengurus|anggota|warga|ketua_rt
  - status: aktif|nonaktif
```

### kegiatan
```dart
kegiatan/{kegiatanId}
  - judul: string
  - tanggal: timestamp
  - lokasi: string
  - pesertaIds: array
  - status: dijadwalkan|berlangsung|selesai
```

### kas
```dart
kas/{kasId}
  - jenis: masuk|keluar
  - jumlah: number
  - kategori: string
  - tanggal: timestamp
```

### berita
```dart
berita/{beritaId}
  - judul: string
  - konten: string
  - kategori: pengumuman|berita
  - isPublic: boolean
```

### aspirasi
```dart
aspirasi/{aspirasiId}
  - judul: string
  - isi: string
  - status: pending|diproses|selesai|ditolak
  - balasan: string?
```

---

## 🔐 Role Permissions

| Feature       | Admin | Pengurus | Anggota | Warga | Ketua RT |
|---------------|-------|----------|---------|-------|----------|
| Manage Users  | ✅    | ❌       | ❌      | ❌    | ❌       |
| Kegiatan CRUD | ✅    | ✅       | ❌      | ❌    | ❌       |
| Daftar Kegiatan| ✅   | ✅       | ✅      | ❌    | ❌       |
| Kas CRUD      | ✅    | ✅       | ❌      | ❌    | ❌       |
| View Kas      | ✅    | ✅       | ✅      | ❌    | ✅       |
| Berita CRUD   | ✅    | ✅       | ❌      | ❌    | ❌       |
| View Berita   | ✅    | ✅       | ✅      | ✅    | ✅       |
| Kirim Aspirasi| ✅    | ✅       | ✅      | ✅    | ✅       |
| Balas Aspirasi| ✅    | ✅       | ❌      | ❌    | ❌       |

---

## 🌐 API Endpoints

### Firebase
```
Auth: https://identitytoolkit.googleapis.com/v1
Firestore: https://firestore.googleapis.com/v1
Storage: https://firebasestorage.googleapis.com/v0
```

### Cloudinary
```
Upload: https://api.cloudinary.com/v1_1/{cloud_name}/upload
Delivery: https://res.cloudinary.com/{cloud_name}/{resource_type}/upload/
```

---

## 🎨 Color Palette

```dart
Primary: #4CAF50 (Green)
Primary Dark: #388E3C
Accent: #2196F3 (Blue)
Success: #4CAF50
Error: #F44336
Warning: #FF9800
Info: #2196F3
Background: #F5F5F5
Text Primary: #212121
Text Secondary: #757575
```

---

## 📦 Main Dependencies

```yaml
# Firebase
firebase_core: ^2.24.2
firebase_auth: ^4.15.3
cloud_firestore: ^4.13.6
firebase_messaging: ^14.7.9

# State Management
provider: ^6.1.1

# UI
google_fonts: ^6.1.0
fl_chart: ^0.66.0
cached_network_image: ^3.3.1

# Media
cloudinary_public: ^0.21.0
image_picker: ^1.0.7

# QR Code
qr_flutter: ^4.1.0
qr_code_scanner: ^1.0.1

# Utils
intl: ^0.18.1
shared_preferences: ^2.2.2
uuid: ^4.3.3
```

---

## 🐛 Common Errors & Fixes

### Error: google-services.json missing
```bash
# Download dari Firebase Console
# Paste ke: android/app/google-services.json
```

### Error: Firestore permission denied
```bash
firebase deploy --only firestore:rules
```

### Error: Build failed - SDK version
```gradle
// android/app/build.gradle
minSdkVersion 21
targetSdkVersion 34
```

### Error: Cloudinary upload failed
```dart
// Check cloudinary_service.dart
cloudName = 'YOUR_CLOUD_NAME'
uploadPreset = 'karteji_preset'
```

---

## 📱 Screen Routes

```dart
/              → SplashScreen
/login         → LoginScreen
/home          → HomeScreen (Bottom Nav)
  ├─ Dashboard
  ├─ Kegiatan
  ├─ Kas
  ├─ Berita
  └─ Profile
```

---

## 🔄 State Flow

```
User Action → Widget → Provider → Service → Firebase → Response
                ↓                                          ↑
            UI Update ← notifyListeners() ←───────────────┘
```

---

## 📊 Database Indexes

```javascript
// Auto-created by firestore.indexes.json
kegiatan: [tanggal DESC, status ASC]
kas: [tanggal DESC, jenis ASC]
berita: [createdAt DESC, kategori ASC]
aspirasi: [status ASC, createdAt DESC]
```

---

## 🚀 Deployment Checklist

### Pre-Production
- [ ] Update version di `pubspec.yaml`
- [ ] Test semua fitur
- [ ] Update Firebase config
- [ ] Update Cloudinary config
- [ ] Deploy Firestore Rules
- [ ] Create signing keystore

### Build
- [ ] `flutter clean`
- [ ] `flutter pub get`
- [ ] `flutter build apk --release`
- [ ] Test APK di device

### Post-Deployment
- [ ] Create admin user
- [ ] Test login
- [ ] Distribute ke team
- [ ] Monitor errors (Firebase Console)

---

## 📞 Support Contacts

| Role              | Contact                |
|-------------------|------------------------|
| Developer Support | admin@karteji.com      |
| Firebase Issues   | Firebase Console       |
| Cloudinary Issues | Cloudinary Dashboard   |

---

## 📚 Documentation

- **README.md** - Overview & features
- **SETUP.md** - Installation guide
- **ARCHITECTURE.md** - System architecture & ERD
- **QUICK_REFERENCE.md** - This file

---

## 🎓 Learning Resources

### Flutter
- [Flutter Docs](https://flutter.dev/docs)
- [Flutter Cookbook](https://flutter.dev/docs/cookbook)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

### Firebase
- [Firebase Docs](https://firebase.google.com/docs)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Firebase Auth](https://firebase.google.com/docs/auth)

### Cloudinary
- [Cloudinary Docs](https://cloudinary.com/documentation)
- [Flutter Package](https://pub.dev/packages/cloudinary_public)

---

## 💡 Pro Tips

1. **Always use StreamBuilder** untuk real-time data
2. **Cache images** dengan cached_network_image
3. **Validate di client & server** (Firestore Rules)
4. **Log aktivitas penting** untuk audit trail
5. **Optimize Cloudinary URLs** untuk performance
6. **Use indexes** untuk query kompleks
7. **Test offline functionality**
8. **Monitor Firebase quota**

---

## 🔥 Hot Tips

### Performance
```dart
// Limit query results
.limit(20)

// Use pagination
.startAfterDocument(lastDocument)

// Cache network images
CachedNetworkImage(imageUrl: url)
```

### Security
```javascript
// Always validate role
function hasRole(role) {
  return getUserData().role == role;
}

// Check ownership
function isOwner(userId) {
  return request.auth.uid == userId;
}
```

### UI/UX
```dart
// Show loading
if (isLoading) return CircularProgressIndicator();

// Show error
if (hasError) return ErrorWidget(error);

// Empty state
if (items.isEmpty) return EmptyStateWidget();
```

---

## 📈 Monitoring

### Firebase Console
- **Authentication** → Monitor active users
- **Firestore** → Check usage & quota
- **Storage** → Monitor file uploads
- **Analytics** → User behavior (if enabled)

### Crashlytics (Future)
```bash
firebase crashlytics:mappings:upload \
  --app=YOUR_APP_ID \
  build/app/outputs/mapping/release/mapping.txt
```

---

## 🎯 Next Steps

### Week 2-3: Enhancements
- [ ] Implement image upload
- [ ] QR Code absensi
- [ ] Push notifications
- [ ] Export PDF
- [ ] Advanced search

### Week 4: Polish
- [ ] UI/UX improvements
- [ ] Performance optimization
- [ ] Bug fixes
- [ ] User feedback integration

### Month 2: Scale
- [ ] Admin web panel
- [ ] Advanced analytics
- [ ] Multi-language
- [ ] Social features

---

## ✅ Version History

### v1.0.0 (Current)
- ✅ Authentication & RBAC
- ✅ Manajemen Kegiatan
- ✅ Keuangan & Kas
- ✅ Berita & Pengumuman
- ✅ Aspirasi Warga
- ✅ Dashboard & Profile
- ✅ Firebase Integration
- ✅ Cloudinary Setup

### v1.1.0 (Planned)
- [ ] Image Upload
- [ ] QR Code Absensi
- [ ] Push Notifications
- [ ] Export PDF

### v2.0.0 (Future)
- [ ] Web Admin Panel
- [ ] Advanced Analytics
- [ ] Calendar Integration
- [ ] Social Features

---

**Last Updated**: 9 Januari 2026  
**Status**: Production Ready ✅  
**Next Release**: v1.1.0 (Planned)

---

**🎉 Selamat! Aplikasi KARTEJI siap digunakan!**

Untuk mulai menggunakan:
1. Baca [SETUP.md](SETUP.md) untuk instalasi
2. Lihat [README.md](README.md) untuk fitur lengkap
3. Cek [ARCHITECTURE.md](ARCHITECTURE.md) untuk detail teknis

**Good luck! 🚀**
