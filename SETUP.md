# Panduan Setup KARTEJI

## 🚀 Quick Start (15 Menit)

### 1. Persiapan Awal

```bash
# Clone/Download project
cd /workspaces/kateji

# Install dependencies
flutter pub get
```

### 2. Setup Firebase (5 menit)

1. **Buat Firebase Project**
   - Buka https://console.firebase.google.com
   - Klik "Add project"
   - Nama: `karteji-rt01`

2. **Setup Android App**
   - Klik "Add app" → Android
   - Package name: `com.karteji.app`
   - Download `google-services.json`
   - Paste ke `android/app/`

3. **Enable Services**
   - Authentication → Email/Password → Enable
   - Firestore Database → Create → Production mode
   - Storage → Get started

4. **Update Config**
   Edit `lib/firebase_options.dart`:
   ```dart
   apiKey: 'AIza...',  // Copy dari google-services.json
   appId: '1:xxx',
   messagingSenderId: 'xxx',
   projectId: 'karteji-rt01',
   ```

### 3. Setup Cloudinary (3 menit)

1. Daftar di https://cloudinary.com
2. Copy **Cloud Name** dari dashboard
3. Buat Upload Preset:
   - Settings → Upload → "Add upload preset"
   - Name: `karteji_preset`
   - Signing Mode: Unsigned

4. Edit `lib/services/cloudinary_service.dart`:
   ```dart
   cloudName = 'your_cloud_name';
   ```

### 4. Deploy Rules (2 menit)

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Init project
firebase init
# Pilih: Firestore, Storage
# Use existing project: karteji-rt01

# Deploy
firebase deploy --only firestore:rules,storage
```

### 5. Buat Admin User (3 menit)

**Di Firebase Console → Authentication:**
- Add user: `admin@karteji.com` / `admin123`
- Copy User UID

**Di Firestore → users collection:**
- Add document dengan ID = User UID
- Fields:
  ```
  email: admin@karteji.com
  nama: Admin Utama
  role: admin
  status: aktif
  createdAt: (current timestamp)
  ```

### 6. Run Aplikasi (2 menit)

```bash
# Check device
flutter devices

# Run
flutter run
```

**Login dengan:**
- Email: `admin@karteji.com`
- Password: `admin123`

---

## 📱 Testing di Device

### Android (Recommended)

```bash
# USB Debugging
1. Enable Developer Options di Android
2. Enable USB Debugging
3. Connect via USB

# Wireless (ADB)
adb tcpip 5555
adb connect DEVICE_IP:5555

# Run
flutter run
```

### Build APK

```bash
# Debug APK (untuk testing)
flutter build apk --debug

# Release APK (untuk distribusi)
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔧 Konfigurasi Lanjutan

### Firebase Cloud Messaging (Push Notification)

1. **Firebase Console**
   - Project Settings → Cloud Messaging
   - Copy Server Key

2. **Android Setup**
   Edit `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data
       android:name="com.google.firebase.messaging.default_notification_channel_id"
       android:value="karteji_channel" />
   ```

3. **Flutter Code**
   Sudah ready di `lib/main.dart`

### Firestore Indexes

Deploy custom indexes:
```bash
firebase deploy --only firestore:indexes
```

Atau buat manual di console saat ada error index.

### Storage CORS

Jika ada CORS error:
```bash
# Create cors.json
echo '[{"origin": ["*"], "method": ["GET"], "maxAgeSeconds": 3600}]' > cors.json

# Deploy
gsutil cors set cors.json gs://karteji-rt01.appspot.com
```

---

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

### Manual Testing Checklist

#### Authentication
- [ ] Login dengan email valid
- [ ] Login dengan email invalid → error
- [ ] Login dengan password salah → error
- [ ] Reset password → email terkirim
- [ ] Logout → kembali ke login screen

#### Dashboard
- [ ] Load data user
- [ ] Tampil nama & role
- [ ] Menu cards clickable

#### Kegiatan
- [ ] List kegiatan tampil
- [ ] Detail kegiatan bisa dibuka
- [ ] Filter & search works
- [ ] (Admin) Tambah kegiatan
- [ ] (Admin) Edit kegiatan
- [ ] (Anggota) Daftar kegiatan

#### Kas
- [ ] Saldo tampil benar
- [ ] List transaksi tampil
- [ ] Filter masuk/keluar works
- [ ] (Admin) Tambah transaksi
- [ ] Perhitungan saldo benar

#### Berita
- [ ] List berita tampil
- [ ] Detail berita bisa dibuka
- [ ] Image loading
- [ ] (Admin) Posting berita

#### Aspirasi
- [ ] User bisa kirim aspirasi
- [ ] List aspirasi user tampil
- [ ] (Admin) Lihat semua aspirasi
- [ ] (Admin) Balas aspirasi
- [ ] Status update works

---

## 🐛 Common Issues & Solutions

### Issue: Build failed - SDK version

**Error:**
```
Execution failed for task ':app:checkDebugAarMetadata'.
```

**Solution:**
```gradle
// android/app/build.gradle
android {
    compileSdkVersion 34
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

### Issue: Firestore permission denied

**Error:**
```
[cloud_firestore/permission-denied] Missing or insufficient permissions
```

**Solution:**
1. Deploy Firestore Rules: `firebase deploy --only firestore:rules`
2. Pastikan user sudah login
3. Cek role user di Firestore
4. Clear app data & restart

### Issue: Cloudinary upload fail

**Error:**
```
CloudinaryException: Upload failed
```

**Solution:**
1. Cek internet connection
2. Cek Cloud Name & Upload Preset di `cloudinary_service.dart`
3. Pastikan Upload Preset mode = Unsigned
4. Cek file size < 10MB

### Issue: Google Services not found

**Error:**
```
File google-services.json is missing
```

**Solution:**
1. Download dari Firebase Console
2. Paste ke `android/app/google-services.json`
3. Rebuild project

### Issue: Multidex error

**Error:**
```
Cannot fit requested classes in a single dex file
```

**Solution:**
Already fixed in `android/app/build.gradle`:
```gradle
defaultConfig {
    multiDexEnabled true
}
dependencies {
    implementation 'androidx.multidex:multidex:2.0.1'
}
```

---

## 📊 Performance Optimization

### 1. Image Optimization

Gunakan Cloudinary transformations:
```dart
final optimizedUrl = cloudinaryService.getOptimizedUrl(
  originalUrl,
  width: 800,
  quality: 'auto',
);
```

### 2. Lazy Loading

Use `ListView.builder` untuk list panjang:
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

### 3. Cache Images

Package `cached_network_image` sudah digunakan:
```dart
CachedNetworkImage(
  imageUrl: url,
  placeholder: (context, url) => CircularProgressIndicator(),
)
```

### 4. Firestore Query Optimization

- Use `limit()` untuk list
- Create indexes untuk compound queries
- Use pagination untuk data besar

### 5. Build Optimization

```bash
# Release build with optimizations
flutter build apk --release --obfuscate --split-debug-info=build/debug-info

# Reduce APK size
flutter build apk --release --target-platform android-arm64
```

---

## 🔐 Security Best Practices

### 1. Firebase Rules

✅ Sudah implemented di `firestore.rules` & `storage.rules`

Key points:
- Authentication required untuk semua write
- Role-based read access
- Field-level validation
- Owner-based permissions

### 2. API Keys

**JANGAN** commit API keys ke Git:
```bash
# .gitignore
android/app/google-services.json
lib/firebase_options.dart  # Jika ada sensitive data
.env
```

Use environment variables untuk production.

### 3. User Input Validation

Selalu validate di:
1. Client side (Flutter forms)
2. Firestore Rules (server side)

### 4. HTTPS Only

Firebase & Cloudinary default sudah HTTPS.

---

## 📦 Deployment Production

### 1. Update Version

Edit `pubspec.yaml`:
```yaml
version: 1.0.0+1  # version+buildNumber
```

### 2. Generate Signing Key

```bash
# Create keystore
keytool -genkey -v -keystore ~/karteji-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias karteji

# Simpan password & alias info
```

### 3. Configure Signing

Create `android/key.properties`:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=karteji
storeFile=/path/to/karteji-key.jks
```

Edit `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### 4. Build Release APK

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### 5. Test APK

```bash
# Install di device
adb install build/app/outputs/flutter-apk/app-release.apk

# Test semua fitur
```

### 6. Google Play Store (Optional)

```bash
# Build App Bundle (lebih efisien)
flutter build appbundle --release

# Upload ke Play Console
# File: build/app/outputs/bundle/release/app-release.aab
```

---

## 📱 Distribusi Internal

### Via APK Direct

1. Upload APK ke cloud storage
2. Share link ke team
3. Install: Enable "Unknown Sources" di Android
4. Download & install APK

### Via Firebase App Distribution

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Upload
firebase appdistribution:distribute \
  build/app/outputs/flutter-apk/app-release.apk \
  --app YOUR_APP_ID \
  --groups testers
```

---

## 🎓 Training Admin/Pengurus

### Checklist Onboarding

#### Admin Utama
- [ ] Login & logout
- [ ] Kelola user (add, edit, deactivate)
- [ ] Set user roles
- [ ] Buat kegiatan
- [ ] Input kas masuk/keluar
- [ ] Upload bukti transaksi
- [ ] Posting berita & pengumuman
- [ ] Balas aspirasi
- [ ] View laporan & statistik

#### Pengurus
- [ ] Login & logout
- [ ] Kelola anggota
- [ ] Buat & kelola kegiatan
- [ ] Absensi kegiatan
- [ ] Input kas
- [ ] Posting berita
- [ ] Balas aspirasi

#### Anggota
- [ ] Login & logout
- [ ] Lihat kegiatan
- [ ] Daftar kegiatan
- [ ] Absensi via QR
- [ ] Lihat kas
- [ ] Kirim aspirasi
- [ ] Edit profil

---

## 📚 Resources

### Documentation
- [Flutter Docs](https://flutter.dev/docs)
- [Firebase Docs](https://firebase.google.com/docs)
- [Cloudinary Docs](https://cloudinary.com/documentation)

### Video Tutorials
- Flutter Firebase Auth: YouTube
- Firestore CRUD: YouTube
- State Management Provider: YouTube

### Community
- Flutter Community: https://flutter.dev/community
- Stack Overflow: Tag `flutter` + `firebase`

---

## 🆘 Support

**Butuh bantuan?**

1. Cek dokumentasi di `README.md`
2. Cek troubleshooting di atas
3. Search di Stack Overflow
4. Contact: admin@karteji.com

---

**Good luck! 🚀**
