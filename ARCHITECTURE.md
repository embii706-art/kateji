# Arsitektur & ERD KARTEJI

## 🏗️ Arsitektur Sistem

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      CLIENT LAYER                           │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │         Flutter Mobile App (Android)                 │  │
│  │                                                       │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐          │  │
│  │  │ Screens  │  │ Widgets  │  │ Providers│          │  │
│  │  └────┬─────┘  └────┬─────┘  └────┬─────┘          │  │
│  │       │             │             │                  │  │
│  │       └─────────────┴─────────────┘                  │  │
│  │                     │                                 │  │
│  │       ┌─────────────┴─────────────┐                  │  │
│  │       │        Services           │                  │  │
│  │       └───────────────────────────┘                  │  │
│  └───────────────────┬───────────────────────────────────┘  │
└────────────────────┬─┴─┬──────────────────────────────────┘
                     │   │
        ┌────────────┘   └────────────┐
        │                              │
┌───────▼────────┐            ┌───────▼────────┐
│   FIREBASE     │            │   CLOUDINARY   │
│   BACKEND      │            │   MEDIA CDN    │
├────────────────┤            ├────────────────┤
│ • Auth         │            │ • Images       │
│ • Firestore    │            │ • Documents    │
│ • Storage      │            │ • Transform    │
│ • Functions    │            │ • Optimize     │
│ • FCM          │            └────────────────┘
└────────────────┘
```

### Application Layers

```
┌─────────────────────────────────────────┐
│        PRESENTATION LAYER               │  UI Components
│  (Screens, Widgets, Navigation)         │
├─────────────────────────────────────────┤
│        STATE MANAGEMENT                 │  Provider
│  (AuthProvider, etc.)                   │
├─────────────────────────────────────────┤
│        BUSINESS LOGIC                   │  Services
│  (FirestoreService, KasService, etc.)   │
├─────────────────────────────────────────┤
│        DATA LAYER                       │  Models
│  (UserModel, KegiatanModel, etc.)       │
├─────────────────────────────────────────┤
│        EXTERNAL SERVICES                │  Firebase
│  (Firebase SDK, Cloudinary SDK)         │  Cloudinary
└─────────────────────────────────────────┘
```

---

## 🗄️ Database Schema (Firestore)

### ERD (Entity Relationship Diagram)

```
┌─────────────────┐
│     USERS       │
│─────────────────│
│ PK: userId      │──┐
│ email           │  │
│ nama            │  │
│ nik             │  │
│ role            │  │
│ status          │  │
│ fotoUrl         │  │
│ createdAt       │  │
└─────────────────┘  │
                     │
        ┌────────────┴───────────┬──────────────────────┐
        │                        │                      │
        │                        │                      │
┌───────▼─────────┐    ┌────────▼────────┐    ┌───────▼──────────┐
│   KEGIATAN      │    │      KAS        │    │    ASPIRASI      │
│─────────────────│    │─────────────────│    │──────────────────│
│ PK: kegiatanId  │    │ PK: kasId       │    │ PK: aspirasiId   │
│ judul           │    │ jenis           │    │ judul            │
│ deskripsi       │    │ jumlah          │    │ isi              │
│ tanggal         │    │ kategori        │    │ kategori         │
│ lokasi          │    │ keterangan      │    │ status           │
│ pesertaIds []   │    │ buktiUrl        │    │ balasan          │
│ absensiIds []   │    │ FK: createdBy   │    │ FK: createdBy    │
│ fotoUrls []     │    │ createdAt       │    │ FK: dibalasOleh  │
│ status          │    └─────────────────┘    │ createdAt        │
│ FK: createdBy   │                           └──────────────────┘
│ createdAt       │
└─────────────────┘
        │
        │
┌───────▼─────────┐
│     BERITA      │
│─────────────────│
│ PK: beritaId    │
│ judul           │
│ konten          │
│ imageUrl        │
│ kategori        │
│ isPublic        │
│ FK: createdBy   │
│ createdAt       │
└─────────────────┘

┌─────────────────────┐
│   LOG_AKTIVITAS     │
│─────────────────────│
│ PK: logId           │
│ FK: userId          │
│ action              │
│ description         │
│ metadata            │
│ timestamp           │
└─────────────────────┘
```

### Collection Details

#### 📁 users
**Purpose**: Menyimpan data user dengan role-based access

| Field          | Type      | Required | Description                    |
|----------------|-----------|----------|--------------------------------|
| userId         | string    | ✅       | Document ID (dari Auth)        |
| email          | string    | ✅       | Email login                    |
| nama           | string    | ✅       | Nama lengkap                   |
| nik            | string    | ❌       | NIK KTP                        |
| tanggalLahir   | timestamp | ❌       | Tanggal lahir                  |
| tempatLahir    | string    | ❌       | Tempat lahir                   |
| alamat         | string    | ❌       | Alamat lengkap                 |
| noHp           | string    | ❌       | Nomor HP/WA                    |
| role           | string    | ✅       | admin/pengurus/anggota/warga   |
| jabatan        | string    | ❌       | Jabatan dalam organisasi       |
| status         | string    | ✅       | aktif/nonaktif                 |
| fotoUrl        | string    | ❌       | URL foto profil (Cloudinary)   |
| createdAt      | timestamp | ✅       | Waktu dibuat                   |
| updatedAt      | timestamp | ❌       | Waktu terakhir diupdate        |

**Indexes:**
- Single field: `email`, `role`, `status`
- Composite: `role ASC, status ASC`

---

#### 📁 kegiatan
**Purpose**: Manajemen kegiatan organisasi

| Field          | Type      | Required | Description                    |
|----------------|-----------|----------|--------------------------------|
| kegiatanId     | string    | ✅       | Document ID (auto-generated)   |
| judul          | string    | ✅       | Nama kegiatan                  |
| deskripsi      | string    | ✅       | Deskripsi lengkap              |
| tanggal        | timestamp | ✅       | Tanggal kegiatan               |
| waktu          | string    | ✅       | Jam kegiatan (HH:mm)           |
| lokasi         | string    | ✅       | Lokasi kegiatan                |
| kategori       | string    | ❌       | Kategori (sosial/olahraga/dll) |
| maxPeserta     | number    | ❌       | Batas maksimal peserta         |
| pesertaIds     | array     | ✅       | Array userId yang daftar       |
| absensiIds     | array     | ✅       | Array userId yang hadir        |
| fotoUrls       | array     | ✅       | Array URL foto (Cloudinary)    |
| status         | string    | ✅       | dijadwalkan/berlangsung/selesai|
| createdBy      | string    | ✅       | userId pembuat                 |
| createdAt      | timestamp | ✅       | Waktu dibuat                   |
| updatedAt      | timestamp | ❌       | Waktu terakhir diupdate        |

**Indexes:**
- Single field: `tanggal DESC`, `status`
- Composite: `tanggal DESC, status ASC`

---

#### 📁 kas
**Purpose**: Pencatatan keuangan masuk & keluar

| Field          | Type      | Required | Description                    |
|----------------|-----------|----------|--------------------------------|
| kasId          | string    | ✅       | Document ID (auto-generated)   |
| jenis          | string    | ✅       | masuk/keluar                   |
| jumlah         | number    | ✅       | Nominal uang                   |
| kategori       | string    | ✅       | Kategori transaksi             |
| keterangan     | string    | ✅       | Deskripsi transaksi            |
| tanggal        | timestamp | ✅       | Tanggal transaksi              |
| buktiUrl       | string    | ❌       | URL bukti transfer (Cloudinary)|
| createdBy      | string    | ✅       | userId yang input              |
| createdAt      | timestamp | ✅       | Waktu dibuat                   |

**Indexes:**
- Single field: `tanggal DESC`, `jenis`
- Composite: `tanggal DESC, jenis ASC`

**Business Rules:**
- Saldo = SUM(jumlah WHERE jenis='masuk') - SUM(jumlah WHERE jenis='keluar')
- Tidak bisa hapus (hanya admin)
- History permanent untuk audit

---

#### 📁 berita
**Purpose**: Berita & pengumuman organisasi

| Field          | Type      | Required | Description                    |
|----------------|-----------|----------|--------------------------------|
| beritaId       | string    | ✅       | Document ID (auto-generated)   |
| judul          | string    | ✅       | Judul berita                   |
| konten         | string    | ✅       | Isi berita (rich text)         |
| imageUrl       | string    | ❌       | URL gambar (Cloudinary)        |
| kategori       | string    | ✅       | pengumuman/berita              |
| isPublic       | boolean   | ✅       | Bisa dibaca tanpa login?       |
| createdBy      | string    | ✅       | userId pembuat                 |
| createdAt      | timestamp | ✅       | Waktu dibuat                   |
| updatedAt      | timestamp | ❌       | Waktu terakhir diupdate        |

**Indexes:**
- Single field: `createdAt DESC`, `kategori`, `isPublic`
- Composite: `createdAt DESC, kategori ASC`

---

#### 📁 aspirasi
**Purpose**: Aspirasi & keluhan warga

| Field          | Type      | Required | Description                    |
|----------------|-----------|----------|--------------------------------|
| aspirasiId     | string    | ✅       | Document ID (auto-generated)   |
| judul          | string    | ✅       | Judul aspirasi                 |
| isi            | string    | ✅       | Isi aspirasi                   |
| kategori       | string    | ✅       | Kategori (umum/infrastruktur)  |
| status         | string    | ✅       | pending/diproses/selesai       |
| balasan        | string    | ❌       | Balasan dari pengurus          |
| createdBy      | string    | ✅       | userId pengirim                |
| createdByName  | string    | ❌       | Nama pengirim (cache)          |
| dibalasOleh    | string    | ❌       | userId yang balas              |
| createdAt      | timestamp | ✅       | Waktu dibuat                   |
| updatedAt      | timestamp | ❌       | Waktu terakhir diupdate        |

**Indexes:**
- Single field: `status`, `createdAt DESC`
- Composite: `status ASC, createdAt DESC`

---

#### 📁 log_aktivitas
**Purpose**: Audit trail aktivitas penting

| Field          | Type      | Required | Description                    |
|----------------|-----------|----------|--------------------------------|
| logId          | string    | ✅       | Document ID (auto-generated)   |
| userId         | string    | ✅       | User yang melakukan aksi       |
| action         | string    | ✅       | LOGIN/LOGOUT/CREATE/UPDATE     |
| description    | string    | ✅       | Deskripsi aktivitas            |
| metadata       | object    | ❌       | Data tambahan (JSON)           |
| timestamp      | timestamp | ✅       | Waktu aktivitas                |

**Indexes:**
- Single field: `timestamp DESC`, `userId`, `action`

**Security:**
- Hanya admin yang bisa read
- Write otomatis via code (tidak bisa manual)
- Tidak bisa update/delete (immutable)

---

## 🔐 Security Rules Logic

### Hierarchy of Access

```
┌────────────────────────────────────────┐
│             ADMIN UTAMA                │  Full Access
│  • CRUD all data                       │
│  • Manage users & roles                │
│  • View audit logs                     │
└────────────────┬───────────────────────┘
                 │
        ┌────────┴────────┐
        │                 │
┌───────▼────────┐  ┌─────▼──────────┐
│   PENGURUS     │  │   KETUA RT     │
│  • CRUD content│  │  • Read only   │
│  • Manage ops  │  │  • Monitoring  │
└────────────────┘  └────────────────┘
        │
┌───────▼────────┐
│   ANGGOTA      │
│  • Limited     │
│  • Own data    │
└────────────────┘
        │
┌───────▼────────┐
│    WARGA       │
│  • Public only │
│  • No internal │
└────────────────┘
```

### Permission Matrix

| Resource   | Admin | Pengurus | Anggota | Warga | Ketua RT |
|------------|-------|----------|---------|-------|----------|
| users      | CRUD  | R        | R(self) | -     | R        |
| kegiatan   | CRUD  | CRUD     | R + Reg | R     | R        |
| kas        | CRUD  | CRUD     | R       | -     | R        |
| berita     | CRUD  | CRUD     | R       | R(pub)| R        |
| aspirasi   | CRUD  | CRU      | CR      | CR    | R        |
| log        | R     | -        | -       | -     | -        |

**Legend:**
- C = Create
- R = Read
- U = Update
- D = Delete
- Reg = Register for event
- (self) = Own data only
- (pub) = Public only

---

## 🔄 Data Flow Diagrams

### Authentication Flow

```
┌─────────┐
│  User   │
└────┬────┘
     │ 1. Enter email/password
     ▼
┌─────────────────┐
│  Login Screen   │
└────┬────────────┘
     │ 2. Call signIn()
     ▼
┌─────────────────┐
│  AuthProvider   │
└────┬────────────┘
     │ 3. Firebase Auth
     ▼
┌─────────────────┐
│ Firebase Auth   │
└────┬────────────┘
     │ 4. Success → User UID
     ▼
┌─────────────────┐
│ FirestoreService│
└────┬────────────┘
     │ 5. Fetch user data
     ▼
┌─────────────────┐
│   Firestore     │
│  users/{uid}    │
└────┬────────────┘
     │ 6. Return UserModel
     ▼
┌─────────────────┐
│ AuthProvider    │
│ (set userData)  │
└────┬────────────┘
     │ 7. Navigate
     ▼
┌─────────────────┐
│  Home Screen    │
└─────────────────┘
```

### Create Kegiatan Flow

```
┌─────────┐
│ Admin   │
└────┬────┘
     │ 1. Fill form
     ▼
┌─────────────────┐
│  Add Kegiatan   │
│     Screen      │
└────┬────────────┘
     │ 2. Submit
     ▼
┌─────────────────┐
│ KegiatanService │
└────┬────────────┘
     │ 3. Validate
     ▼
┌─────────────────┐
│   Firestore     │
│  kegiatan/ doc  │
└────┬────────────┘
     │ 4. Write success
     ▼
┌─────────────────┐
│ FirestoreService│
└────┬────────────┘
     │ 5. Log activity
     ▼
┌─────────────────┐
│   Firestore     │
│ log_aktivitas/  │
└────┬────────────┘
     │ 6. Return doc ID
     ▼
┌─────────────────┐
│  Success msg    │
│  Navigate back  │
└─────────────────┘
```

### Upload Foto Flow

```
┌─────────┐
│  User   │
└────┬────┘
     │ 1. Pick image
     ▼
┌─────────────────┐
│  Image Picker   │
└────┬────────────┘
     │ 2. File path
     ▼
┌─────────────────┐
│CloudinaryService│
└────┬────────────┘
     │ 3. Upload file
     ▼
┌─────────────────┐
│   Cloudinary    │
│   API           │
└────┬────────────┘
     │ 4. Return URL
     ▼
┌─────────────────┐
│ Update Firestore│
│ with image URL  │
└────┬────────────┘
     │ 5. Success
     ▼
┌─────────────────┐
│ Display image   │
└─────────────────┘
```

---

## 📊 State Management

### Provider Pattern

```
┌────────────────────────────┐
│      AuthProvider          │
│────────────────────────────│
│  - firebaseUser            │
│  - userData                │
│  - isLoading               │
│  - errorMessage            │
│────────────────────────────│
│  + signIn()                │
│  + signUp()                │
│  + signOut()               │
│  + resetPassword()         │
│  + updateProfile()         │
│  + hasRole()               │
└────────────────────────────┘
         │
         │ notifyListeners()
         ▼
┌────────────────────────────┐
│    Consumer Widget         │
│  (UI rebuilds on change)   │
└────────────────────────────┘
```

### State Lifecycle

```
App Start
  │
  ├─→ Firebase.initializeApp()
  │
  ├─→ AuthProvider created
  │     │
  │     ├─→ Listen to authStateChanges
  │     │
  │     └─→ Load userData from Firestore
  │
  └─→ Navigate based on auth state
        │
        ├─→ Authenticated → Home
        │
        └─→ Not authenticated → Login
```

---

## 🎨 UI Component Hierarchy

```
MaterialApp
  └─ MultiProvider
       └─ AuthProvider
            │
            ├─ SplashScreen
            │
            ├─ LoginScreen
            │
            └─ HomeScreen (Bottom Navigation)
                 │
                 ├─ DashboardScreen
                 │    ├─ Welcome Card
                 │    ├─ Quick Menu Grid
                 │    └─ Statistics Cards
                 │
                 ├─ KegiatanListScreen
                 │    └─ StreamBuilder<List<Kegiatan>>
                 │         └─ ListView.builder
                 │              └─ KegiatanCard
                 │
                 ├─ KasScreen
                 │    ├─ Saldo Card
                 │    └─ StreamBuilder<List<Kas>>
                 │         └─ ListView.builder
                 │              └─ KasCard
                 │
                 ├─ BeritaListScreen
                 │    └─ StreamBuilder<List<Berita>>
                 │         └─ ListView.builder
                 │              └─ BeritaCard
                 │
                 └─ ProfileScreen
                      ├─ Profile Avatar
                      ├─ Info Cards
                      └─ Action Buttons
```

---

## 🔄 CI/CD Pipeline (Future)

```
┌─────────────┐
│   Git Push  │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  GitHub     │
│  Actions    │
└──────┬──────┘
       │
       ├─→ Run Tests
       │
       ├─→ Build APK
       │
       ├─→ Deploy Rules
       │
       └─→ Firebase App Distribution
            │
            └─→ Notify Testers
```

---

**Documentation Complete** ✅
