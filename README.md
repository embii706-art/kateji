# KARTEJI (Karang Taruna RT 01) — repo: `kateji`

Platform digital Karang Taruna RT 01 untuk administrasi, transparansi keuangan, kegiatan, dan aspirasi warga. Fokus mobile-first (Flutter) dengan backend Firebase + Cloudinary.

## Arsitektur Firebase + Cloudinary
```
Flutter Mobile
  ├─ Firebase Auth (Email/Password, custom claims role)
  ├─ Firestore (data inti & audit log)
  ├─ FCM (push notif pengumuman/aspirasi/kegiatan)
  ├─ Cloud Storage (opsional cache)
  └─ Cloudinary (WAJIB) via signed upload
Cloud Functions (opsional)
  ├─ Generate Cloudinary signature
  └─ Cron laporan bulanan/kegiatan
```

## Skema Firestore (detail)
| Koleksi | Dokumen & Field | Deskripsi & Index |
| --- | --- | --- |
| users/{userId} | nama, email, role (`admin`, `pengurus`, `anggota`, `warga`, `ketua_rt`), jabatan, no_hp, status, avatarUrl, createdAt | Index: role+status, email unik |
| kegiatan/{id} | judul, deskripsi, tanggal, lokasi, status, createdBy, pesertaIds[], dokumentasiUrls[], absensi:{userId:{hadir:true, waktu}} | Index: status+tanggal |
| kas/{id} | tipe(`masuk/keluar`), nominal, kategori, keterangan, buktiUrl, tanggal, createdBy, approvedBy, saldoSetelah | Index: tanggal+kategori |
| berita/{id} | judul, konten, tipe(`pengumuman/berita`), coverUrl, publik:true/false, createdBy, publishedAt | Index: publik+publishedAt |
| aspirasi/{id} | userId/null, kategori, isi, status(`baru/proses/selesai`), balasan, lampiranUrls[], createdAt, updatedAt, handledBy | Index: status+kategori |
| laporan/{id} | jenis(`keuangan/kegiatan/keanggotaan`), periode, url, createdAt, generatedBy | Index: jenis+periode |
| log_aktivitas/{id} | actorId, role, aksi, target, timestamp, metadata | Index: timestamp |

## Firebase Security Rules (RBAC & audit)
```rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function hasRole(role) { return request.auth.token.role == role; }
    function hasAnyRole(list) { return list.hasAny([request.auth.token.role]); }
    function isOwner(uid) { return request.auth != null && request.auth.uid == uid; }
    function phoneRegex() { return '^\\+62\\d{9,13}$'; } // normalisasi ke +62
    function emailRegex() { return '^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$'; }
    function aspirasiMinLen() { return 3; }
    function attendanceEarlyBuffer() { return duration(6, 'hour'); }
    function attendanceLateBuffer() { return duration(3, 'hour'); }
    function validContact(c) {
      return c is string && (c.matches(phoneRegex()) || c.matches(emailRegex()));
    }
    function inAttendanceWindow(eventTime) {
      return eventTime is timestamp && request.time >= eventTime - attendanceEarlyBuffer() && request.time <= eventTime + attendanceLateBuffer(); // buffer hadir lebih awal 6h, pulang +3h
    }

    match /users/{userId} {
      allow read: if hasAnyRole(['admin','pengurus','ketua_rt']);
      allow write: if hasRole('admin');
      allow update: if isOwner(userId); // edit profil pribadi
    }

    match /kegiatan/{id} {
      allow read: if request.auth != null;
      allow create, update, delete: if hasAnyRole(['admin','pengurus']);
      allow update: if request.resource.data.absensi.keys().hasOnly([request.auth.uid])
        && request.resource.data.diff(resource.data).changedKeys().hasOnly(['absensi'])
        && resource.data.absensi[request.auth.uid] == null // hanya sekali per user
        && let att = request.resource.data.absensi[request.auth.uid];
           att.keys().hasOnly(['hadir','waktu']) && att.hadir is bool && att.waktu is timestamp
        && inAttendanceWindow(resource.data.tanggal); // jendela absensi -6h s/d +3h
    }

    match /kas/{id} {
      allow read: if hasAnyRole(['admin','pengurus','anggota','ketua_rt']);
      allow create, update, delete: if hasAnyRole(['admin','pengurus']);
    }

    match /berita/{id} {
      allow read: if resource.data.publik == true || request.auth != null;
      allow create, update, delete: if hasAnyRole(['admin','pengurus']);
    }

    match /aspirasi/{id} {
      allow create: if request.resource.data.isi is string && request.resource.data.isi.size() >= aspirasiMinLen()
        && (request.auth != null || validContact(request.resource.data.contact)); // validasi kontak email/telepon
      allow read: if hasAnyRole(['admin','pengurus','ketua_rt']) || isOwner(resource.data.userId);
      allow update, delete: if hasAnyRole(['admin','pengurus']) || isOwner(resource.data.userId);
    }

    match /laporan/{id} {
      allow read: if hasAnyRole(['admin','pengurus','anggota','ketua_rt']);
      allow create, delete: if hasAnyRole(['admin','pengurus']);
    }

    match /log_aktivitas/{id} {
      allow read: if hasAnyRole(['admin','ketua_rt']);
      allow create: if request.auth != null;
      allow delete: if false;
    }
  }
}
```

## Flow aplikasi per role (ringkas)
- **Admin Utama**: kelola user/role, CRUD semua koleksi, generate laporan, pantau log.
- **Pengurus**: kelola anggota, kegiatan, absensi, kas, berita/pengumuman, balas aspirasi.
- **Anggota**: lihat daftar kegiatan & kas, daftar & absen, kirim aspirasi, edit profil.
- **Warga**: lihat pengumuman/berita publik, kirim aspirasi (opsional login).
- **Ketua RT**: monitoring laporan keuangan/kegiatan/aspirasi, baca log.

## Contoh integrasi Cloudinary (secure upload)
1. Simpan hanya URL di Firestore. Gunakan folder: `/karteji/anggota`, `/karteji/kegiatan`, `/karteji/keuangan`.
2. Cloud Function (Node) untuk signature:
```js
// functions/cloudinary-signature.js
const functions = require('firebase-functions');
const cloudinary = require('cloudinary').v2;
const ALLOWED_FOLDERS = (process.env.CLOUDINARY_ALLOWED_FOLDERS || '')
  .split(',')
  .map(f => f.trim())
  .filter(Boolean); // wajib diisi di env
const FINANCE_ROLES = ['admin','pengurus']; // sinkron dengan rules & app
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});
exports.getUploadSignature = functions.https.onCall((data, context) => {
  if (!context.auth) throw new functions.https.HttpsError('unauthenticated','Login required');
  if (!ALLOWED_FOLDERS.length) throw new functions.https.HttpsError('failed-precondition','Allowed folders not configured');
  const timestamp = Math.round(Date.now()/1000);
  const requestedFolder = typeof data.folder === 'string' ? data.folder : '';
  const folder = ALLOWED_FOLDERS.includes(requestedFolder) ? requestedFolder : 'karteji/umum';
  const role = context.auth.token.role;
  if (folder === 'karteji/keuangan' && !FINANCE_ROLES.includes(role)) {
    throw new functions.https.HttpsError('permission-denied','Folder restricted');
  }
  const signature = cloudinary.utils.api_sign_request({ timestamp, folder }, cloudinary.config().api_secret);
  return { timestamp, folder, signature, apiKey: cloudinary.config().api_key };
});
```
3. Flutter upload:
```dart
final fn = FirebaseFunctions.instance.httpsCallable('getUploadSignature');
final sig = await fn.call({'folder': 'karteji/kegiatan'});
const cloudName = String.fromEnvironment('CLOUDINARY_CLOUD_NAME'); // atau load dari dotenv
final req = http.MultipartRequest('POST', Uri.parse('https://api.cloudinary.com/v1_1/${cloudName}/image/upload'))
  ..fields.addAll({
    'api_key': sig.data['apiKey'],
    'timestamp': sig.data['timestamp'].toString(),
    'signature': sig.data['signature'],
    'folder': sig.data['folder'],
  })
  ..files.add(await http.MultipartFile.fromPath('file', file.path));
final res = await req.send();
final body = jsonDecode(await res.stream.bytesToString());
if (res.statusCode != 200 || body['secure_url'] == null) {
  throw Exception('Upload gagal: ${res.statusCode}');
}
final url = body['secure_url'] as String;
await FirebaseFirestore.instance.collection('kegiatan').doc(eventId).update({
  'dokumentasiUrls': FieldValue.arrayUnion([url])
});
```

## Contoh kode Flutter + Firebase (Auth & RBAC)
```dart
await Firebase.initializeApp();
final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
final idToken = await credential.user?.getIdTokenResult(true);
final role = idToken?.claims?['role'];
if (role == null) throw Exception('Role belum diset, hubungi admin'); // paling aman: stop akses
final canManageKas = ['admin','pengurus'].contains(role);
```

## Struktur folder project (sugesti Flutter)
```
lib/
 ├─ main.dart
 ├─ data/ (services: auth_service.dart, firestore_service.dart, cloudinary_service.dart)
 ├─ models/ (user.dart, kegiatan.dart, kas.dart, aspirasi.dart)
 ├─ ui/
 │   ├─ screens/ (dashboard.dart, kegiatan_list.dart, kas.dart, aspirasi.dart, berita.dart, profile.dart)
 │   └─ widgets/ (bottom_nav.dart, cards/)
 ├─ utils/ (rbac.dart, formatters.dart)
 └─ state/ (bloc/provider)
assets/ (icons, theme)
firebase.json / firestore.indexes.json / firestore.rules
functions/ (cloudinary signature, cron laporan)
```

## MVP 7 Hari (mobile-first)
| Hari | Target |
| --- | --- |
| 1 | Setup Flutter + Firebase project, auth email/password, theming hijau/biru |
| 2 | Data model & Firestore rules, halaman login & registrasi role default anggota |
| 3 | Dashboard ringkas, list kegiatan + detail + daftar peserta |
| 4 | Absensi (QR/manual), input kas masuk/keluar (pengurus), saldo realtime |
| 5 | Pengumuman/berita publik, aspirasi warga (anon + login) |
| 6 | Integrasi Cloudinary upload bukti/dokumentasi, push notif FCM untuk pengumuman |
| 7 | Laporan sederhana (saldo & kegiatan), audit log dasar, uji UX & rilis internal |

## Catatan Implementasi
- Simpan constants peran (`admin`, `pengurus`, `anggota`, `warga`, `ketua_rt`) di satu sumber (env/config) dan sinkronkan ke Rules + Cloud Functions.
- Gunakan custom claims role via Cloud Functions saat admin menambah user.
- Terapkan index Firestore sesuai tabel di atas.
- Aktifkan Cloudinary image optimization & https secure_url.
- Audit log tiap aksi penting (create/update/delete) untuk monitoring ketua RT.
