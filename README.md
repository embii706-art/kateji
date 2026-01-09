# KARTEJI - Karang Taruna RT 01
## Platform Digital untuk Administrasi, Keuangan & Kegiatan

![Version](https://img.shields.io/badge/version-1.0.0-green)
![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue)
![Firebase](https://img.shields.io/badge/Firebase-Ready-orange)

---

## 📱 Tentang Aplikasi

**KARTEJI** adalah aplikasi mobile berbasis Flutter untuk digitalisasi administrasi Karang Taruna RT 01. Aplikasi ini menyediakan fitur lengkap untuk manajemen anggota, kegiatan, keuangan, berita, dan aspirasi warga dengan sistem Role-Based Access Control (RBAC).

### ✨ Fitur Utama

#### 1. 🔐 Autentikasi & Keamanan
- Login dengan Email & Password (Firebase Auth)
- Role-Based Access Control (5 role user)
- Reset password via email
- Audit log untuk aktivitas penting
- Firebase Security Rules untuk proteksi data

#### 2. 👥 Manajemen Anggota
- Data lengkap anggota (NIK, TTL, alamat, no HP)
- Status aktif/nonaktif
- Jabatan dalam organisasi
- Export data (PDF/Excel) - *coming soon*

#### 3. 📅 Manajemen Kegiatan
- CRUD kegiatan
- Jadwal, lokasi, dan deskripsi
- Pendaftaran peserta
- Absensi (QR Code/manual) - *coming soon*
- Upload dokumentasi (Cloudinary)
- Laporan kegiatan otomatis

#### 4. 💰 Keuangan & Kas
- Pencatatan kas masuk & keluar
- Saldo realtime
- Upload bukti transaksi
- Laporan bulanan & tahunan
- Transparansi untuk anggota

#### 5. 📰 Berita & Pengumuman
- Posting berita organisasi
- Pengumuman RT
- Upload gambar (Cloudinary)
- Push notification (FCM) - *coming soon*

#### 6. 🗳️ Aspirasi Warga
- Kirim aspirasi dengan kategori
- Status tracking (pending/diproses/selesai/ditolak)
- Sistem balasan dari pengurus
- History aspirasi per user

#### 7. 📊 Laporan & Statistik
- Dashboard statistik
- Grafik keuangan
- Grafik kegiatan
- Grafik keanggotaan
- Export laporan PDF - *coming soon*

---

## 🏗️ Arsitektur Aplikasi

### Tech Stack

```
┌─────────────────────────────────────────┐
│         Flutter Mobile App              │
│     (Android - Material Design)         │
└─────────────────────────────────────────┘
                    │
        ┌───────────┴───────────┐
        │                       │
┌───────▼────────┐    ┌────────▼────────┐
│   Firebase     │    │   Cloudinary    │
│                │    │                 │
│ • Auth         │    │ • Image Storage │
│ • Firestore    │    │ • Optimization  │
│ • Storage      │    │ • CDN Delivery  │
│ • Functions    │    └─────────────────┘
│ • FCM          │
└────────────────┘
```

### Folder Structure

```
karteji/
├── android/                 # Android native config
├── lib/
│   ├── main.dart           # Entry point
│   ├── firebase_options.dart
│   │
│   ├── models/             # Data models
│   │   ├── user_model.dart
│   │   ├── kegiatan_model.dart
│   │   ├── kas_model.dart
│   │   ├── berita_model.dart
│   │   └── aspirasi_model.dart
│   │
│   ├── services/           # Business logic
│   │   ├── firestore_service.dart
│   │   ├── cloudinary_service.dart
│   │   ├── kegiatan_service.dart
│   │   ├── kas_service.dart
│   │   ├── berita_service.dart
│   │   └── aspirasi_service.dart
│   │
│   ├── providers/          # State management
│   │   └── auth_provider.dart
│   │
│   ├── screens/            # UI screens
│   │   ├── splash_screen.dart
│   │   ├── auth/
│   │   ├── home/
│   │   ├── profile/
│   │   ├── kegiatan/
│   │   ├── kas/
│   │   ├── berita/
│   │   └── aspirasi/
│   │
│   └── utils/              # Utilities
│       ├── app_colors.dart
│       ├── constants.dart
│       └── formatter.dart
│
├── firestore.rules         # Firestore security rules
├── storage.rules           # Storage security rules
├── firebase.json
└── pubspec.yaml           # Dependencies
```

---

## 👥 Role & Hak Akses

### 1️⃣ Admin Utama
**Akses Penuh** - Dapat mengelola semua aspek aplikasi
- ✅ CRUD semua data (user, kegiatan, kas, berita, aspirasi)
- ✅ Kelola user & role
- ✅ Konfigurasi sistem
- ✅ Akses semua laporan
- ✅ View audit log

### 2️⃣ Pengurus Karang Taruna
**Pengelola Operasional**
- ✅ Kelola anggota (CRUD)
- ✅ Kelola kegiatan & absensi
- ✅ Input kas masuk & keluar
- ✅ Buat berita & pengumuman
- ✅ Balas aspirasi warga
- ❌ Tidak bisa kelola user & role

### 3️⃣ Anggota Karang Taruna
**Partisipan Aktif**
- ✅ Lihat & daftar kegiatan
- ✅ Absensi kegiatan
- ✅ Lihat laporan kas (read-only)
- ✅ Kirim aspirasi
- ✅ Edit profil pribadi
- ❌ Tidak bisa kelola data organisasi

### 4️⃣ Warga RT
**Publik Terbatas**
- ✅ Lihat pengumuman publik
- ✅ Lihat berita
- ✅ Kirim aspirasi (opsional login)
- ❌ Tidak akses data internal

### 5️⃣ Ketua RT
**Monitoring & Oversight**
- ✅ Lihat laporan keuangan
- ✅ Lihat laporan kegiatan
- ✅ Monitoring aspirasi
- ❌ Tidak bisa edit data (read-only)

---

## 🗂️ Struktur Database Firestore

### Collections Schema

#### 📁 users
```javascript
{
  userId: string (doc ID)
  email: string
  nama: string
  nik: string?
  tanggalLahir: timestamp?
  tempatLahir: string?
  alamat: string?
  noHp: string?
  role: string // admin | pengurus | anggota | warga | ketua_rt
  jabatan: string?
  status: string // aktif | nonaktif
  fotoUrl: string? // Cloudinary URL
  createdAt: timestamp
  updatedAt: timestamp?
}
```

#### 📁 kegiatan
```javascript
{
  kegiatanId: string (doc ID)
  judul: string
  deskripsi: string
  tanggal: timestamp
  waktu: string
  lokasi: string
  kategori: string?
  maxPeserta: number?
  pesertaIds: array<string>
  absensiIds: array<string>
  fotoUrls: array<string> // Cloudinary URLs
  status: string // dijadwalkan | berlangsung | selesai | dibatalkan
  createdBy: string (userId)
  createdAt: timestamp
  updatedAt: timestamp?
}
```

#### 📁 kas
```javascript
{
  kasId: string (doc ID)
  jenis: string // masuk | keluar
  jumlah: number
  kategori: string
  keterangan: string
  tanggal: timestamp
  buktiUrl: string? // Cloudinary URL
  createdBy: string (userId)
  createdAt: timestamp
}
```

#### 📁 berita
```javascript
{
  beritaId: string (doc ID)
  judul: string
  konten: string
  imageUrl: string? // Cloudinary URL
  kategori: string // pengumuman | berita
  isPublic: boolean
  createdBy: string (userId)
  createdAt: timestamp
  updatedAt: timestamp?
}
```

#### 📁 aspirasi
```javascript
{
  aspirasiId: string (doc ID)
  judul: string
  isi: string
  kategori: string
  status: string // pending | diproses | selesai | ditolak
  balasan: string?
  createdBy: string (userId)
  createdByName: string?
  dibalasOleh: string? (userId)
  createdAt: timestamp
  updatedAt: timestamp?
}
```

#### 📁 log_aktivitas
```javascript
{
  logId: string (doc ID)
  userId: string
  action: string
  description: string
  metadata: object?
  timestamp: timestamp
}
```

### Database Indexes

**Firestore Composite Indexes** (sudah dikonfigurasi di `firestore.indexes.json`):

1. **kegiatan**: `tanggal DESC, status ASC`
2. **kas**: `tanggal DESC, jenis ASC`
3. **berita**: `createdAt DESC, kategori ASC`
4. **aspirasi**: `status ASC, createdAt DESC`

---

## ☁️ Cloudinary Integration

### Folder Structure
```
cloudinary://karteji/
├── anggota/          # Foto profil anggota
│   └── {userId}/
├── kegiatan/         # Dokumentasi kegiatan
│   └── {kegiatanId}/
├── keuangan/         # Bukti transaksi
│   └── {kasId}/
└── berita/           # Gambar berita
    └── {beritaId}/
```

### Configuration

**File**: `lib/services/cloudinary_service.dart`

```dart
// TODO: Update dengan credentials Anda
static const String cloudName = 'YOUR_CLOUD_NAME';
static const String uploadPreset = 'karteji_preset';
```

### Setup Cloudinary Upload Preset

1. Login ke [Cloudinary Console](https://cloudinary.com/console)
2. Buka **Settings → Upload**
3. Klik **Add upload preset**
4. Nama: `karteji_preset`
5. Signing Mode: **Unsigned**
6. Folder: Kosongkan (akan di-set dari kode)
7. **Save**

### Fitur Cloudinary
- ✅ Automatic image optimization
- ✅ CDN delivery
- ✅ Responsive images
- ✅ Format conversion (WebP, AVIF)
- ✅ Lazy loading support

---

## 🔒 Firebase Security Rules

### Firestore Rules Highlights

```javascript
// User dapat read profil sendiri, admin dapat CRUD semua
match /users/{userId} {
  allow read: if isAuthenticated();
  allow update: if isAdmin() || isOwner(userId);
}

// Admin & Pengurus dapat CRUD kegiatan
// Anggota dapat daftar & absen
match /kegiatan/{kegiatanId} {
  allow read: if isAuthenticated();
  allow write: if isAdminOrPengurus();
}

// Kas hanya untuk internal (bukan warga)
match /kas/{kasId} {
  allow read: if isAuthenticated() && !isWarga();
  allow write: if isAdminOrPengurus();
}

// Berita public dapat dibaca tanpa auth
match /berita/{beritaId} {
  allow read: if resource.data.isPublic || isAuthenticated();
  allow write: if isAdminOrPengurus();
}

// Aspirasi: user lihat milik sendiri, admin/pengurus lihat semua
match /aspirasi/{aspirasiId} {
  allow read: if isOwner() || isAdminOrPengurus() || isKetuaRT();
  allow create: if isAuthenticated();
}
```

**File lengkap**: `firestore.rules`

### Storage Rules

```javascript
// Upload hanya untuk authenticated users
// Max 10MB per file
// Hanya image & PDF

match /karteji/anggota/{userId}/{fileName} {
  allow read: if isAuthenticated();
  allow write: if isAuthenticated() && 
                 isValidFileType() && 
                 isValidSize();
}
```

**File lengkap**: `storage.rules`

---

## 📦 Setup & Instalasi

### Prerequisites

- Flutter SDK 3.0+ ([Install Flutter](https://flutter.dev/docs/get-started/install))
- Android Studio / VS Code
- Git
- Akun Firebase ([Firebase Console](https://console.firebase.google.com))
- Akun Cloudinary ([Cloudinary](https://cloudinary.com))

### 1️⃣ Install Dependencies

```bash
flutter pub get
```

### 2️⃣ Setup Firebase

#### A. Buat Project Firebase

1. Buka [Firebase Console](https://console.firebase.google.com)
2. Klik **Add project** / **Create a project**
3. Nama: `karteji-rt01` (atau sesuai keinginan)
4. Enable Google Analytics (opsional)
5. Klik **Create project**

#### B. Setup Android App

1. Di Firebase Console, klik **Add app** → **Android**
2. Android package name: `com.karteji.app`
3. Download `google-services.json`
4. Copy ke `android/app/google-services.json`

#### C. Enable Authentication

1. Di Firebase Console → **Authentication**
2. Klik **Get started**
3. Tab **Sign-in method**
4. Enable **Email/Password**

#### D. Enable Firestore

1. Di Firebase Console → **Firestore Database**
2. Klik **Create database**
3. Pilih **Start in production mode**
4. Pilih region (asia-southeast1 untuk Indonesia)
5. Klik **Enable**

#### E. Deploy Security Rules

```bash
# Install Firebase CLI (jika belum)
npm install -g firebase-tools

# Login ke Firebase
firebase login

# Initialize project
firebase init

# Pilih:
# - Firestore
# - Storage
# - Use existing project: karteji-rt01

# Deploy rules
firebase deploy --only firestore:rules
firebase deploy --only storage
```

#### F. Update Firebase Config

Edit `lib/firebase_options.dart`:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_API_KEY',              // Dari google-services.json
  appId: '1:xxx:android:xxx',          // Dari google-services.json
  messagingSenderId: 'YOUR_SENDER_ID', // Dari google-services.json
  projectId: 'karteji-rt01',           // Project ID Anda
  storageBucket: 'karteji-rt01.appspot.com',
);
```

### 3️⃣ Setup Cloudinary

1. Login ke [Cloudinary Dashboard](https://cloudinary.com/console)
2. Copy **Cloud Name** dari dashboard
3. Buat Upload Preset:
   - Settings → Upload → Add upload preset
   - Name: `karteji_preset`
   - Signing Mode: **Unsigned**
   - Save

4. Update `lib/services/cloudinary_service.dart`:

```dart
static const String cloudName = 'YOUR_CLOUD_NAME';  // Dari dashboard
static const String uploadPreset = 'karteji_preset';
```

### 4️⃣ Buat User Admin Pertama

Karena Firestore Rules protektif, buat admin pertama manual:

1. Buka Firebase Console → Authentication
2. Klik **Add user**
3. Email: `admin@karteji.com`
4. Password: `admin123` (ganti setelah login pertama)
5. Copy **User UID**

6. Buka Firestore → **users** collection
7. Klik **Add document**
8. Document ID: paste **User UID** tadi
9. Field:
   ```
   email: admin@karteji.com
   nama: Admin Utama
   role: admin
   status: aktif
   createdAt: (timestamp) now
   ```
10. Save

### 5️⃣ Run Aplikasi

```bash
# Check devices
flutter devices

# Run on Android device/emulator
flutter run

# Or build APK
flutter build apk --release
```

APK akan ada di: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🚀 Rencana Pengembangan MVP (7 Hari)

### 🗓️ Day 1-2: Foundation (✅ DONE)
- [x] Setup project Flutter
- [x] Setup Firebase (Auth, Firestore)
- [x] Setup Cloudinary
- [x] Buat models & services
- [x] Implementasi autentikasi
- [x] Firestore & Storage Rules

### 🗓️ Day 3-4: Core Features (✅ DONE)
- [x] Dashboard & navigation
- [x] Manajemen kegiatan (CRUD)
- [x] Manajemen kas (CRUD)
- [x] List & detail screens

### 🗓️ Day 5: Additional Features (✅ DONE)
- [x] Berita & pengumuman
- [x] Aspirasi warga
- [x] Profil user

### 🗓️ Day 6: Polish & Testing (TODO)
- [ ] Upload foto (Cloudinary integration)
- [ ] QR Code absensi
- [ ] Push notifications (FCM)
- [ ] Export PDF laporan
- [ ] Testing semua fitur
- [ ] Bug fixing

### 🗓️ Day 7: Deployment & Documentation (TODO)
- [ ] Build APK production
- [ ] Deploy Firestore indexes
- [ ] Testing di real device
- [ ] User acceptance testing
- [ ] Documentation lengkap
- [ ] Training admin/pengurus

---

## 📋 Fitur yang Belum Diimplementasi (v1.1+)

### Priority High
1. **Upload Foto**
   - Implementasi image picker
   - Integrasi Cloudinary upload
   - Preview & crop image

2. **QR Code Absensi**
   - Generate QR per kegiatan
   - Scan QR untuk absen
   - Validasi & recording

3. **Push Notifications**
   - Setup FCM
   - Notification triggers
   - In-app notifications

4. **Export PDF**
   - Laporan kas PDF
   - Laporan kegiatan PDF
   - Data anggota PDF

### Priority Medium
5. **Admin Panel Web**
   - Responsive web version
   - Desktop-optimized UI
   - Advanced reporting

6. **Advanced Analytics**
   - Charts & graphs (fl_chart)
   - Trend analysis
   - Predictive insights

7. **Multi-language**
   - Bahasa Indonesia
   - English (optional)

### Priority Low
8. **Social Features**
   - Comment pada berita
   - Like & reactions
   - Share to social media

9. **Calendar Integration**
   - Sync dengan Google Calendar
   - Reminder notifications

10. **Advanced Search**
    - Full-text search
    - Filters & sorting
    - Search history

---

## 🐛 Troubleshooting

### Build Errors

**Error: google-services.json not found**
```bash
# Solution: Download dari Firebase Console dan paste ke android/app/
```

**Error: Minimum SDK version**
```bash
# Solution: Edit android/app/build.gradle
minSdkVersion 21
```

**Error: Multidex**
```bash
# Solution: Sudah ditambahkan di build.gradle
multiDexEnabled true
```

### Runtime Errors

**Error: Firebase not initialized**
```dart
// Solution: Pastikan di main.dart ada:
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

**Error: Firestore permission denied**
```
// Solution: Deploy Firestore Rules
firebase deploy --only firestore:rules
```

**Error: Cloudinary upload failed**
```dart
// Solution: Cek cloud name & upload preset di cloudinary_service.dart
```

---

## 📞 Support & Contact

**Developer**: KARTEJI Dev Team  
**Email**: admin@karteji.com  
**Version**: 1.0.0  
**Last Updated**: 9 Januari 2026  

---

## 📄 License

Copyright © 2026 KARTEJI (Karang Taruna RT 01)  
All rights reserved.

---

## 🙏 Credits

- **Flutter Team** - UI Framework
- **Firebase** - Backend Infrastructure
- **Cloudinary** - Media Management
- **Material Design** - Design System
- **Open Source Community** - Various packages

---

**Built with ❤️ for Karang Taruna RT 01**