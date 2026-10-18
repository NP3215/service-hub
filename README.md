# ServiceHub

Aplikasi mobile untuk mencari bengkel terdekat dan memesan jadwal servis kendaraan.
Project kuliah — fullstack (Flutter + Node.js).

## Fitur
- Register & login (Firebase Authentication)
- Daftar bengkel beserta jarak, rating, dan layanan
- Booking servis dengan pilihan tanggal & slot waktu (slot yang sudah terisi otomatis disembunyikan)
- Riwayat booking (Pending, Confirmed, Completed, Cancelled) dengan aksi batalkan / selesaikan
- Halaman profil

## Tech Stack
| Bagian | Teknologi |
|---|---|
| Frontend | Flutter (Dart), firebase_auth, http |
| Backend | Node.js, Express 5, firebase-admin |
| Database | TiDB / MySQL (mysql2) |
| Auth | Firebase ID Token (diverifikasi di middleware backend) |

## Struktur
```
backend/   REST API (routes -> controller -> database)
frontend/service_hub/   Aplikasi Flutter (screens, widgets, services, models)
```

## Cara Menjalankan

### 1. Database
Jalankan `backend/database/schema.sql` di TiDB/MySQL Anda.

### 2. Backend
Buat `backend/.env`:
```
DATABASE_URL=mysql://USER:PASSWORD@HOST:4000/DB_NAME
PORT=3000
```
Letakkan kunci service account Firebase di `backend/ServiceAccountKey.json`, lalu:
```
cd backend
npm install
npm run dev
```
Cek `http://localhost:3000/api/auth/test` untuk memastikan database terhubung.

### 3. Frontend
```
cd frontend/service_hub
flutter pub get
flutter run -d chrome
```
Untuk emulator Android, ubah `baseUrl` di `lib/services/api_services.dart` menjadi `http://10.0.2.2:3000`.

## API Singkat
| Method | Endpoint | Auth |
|---|---|---|
| POST | /api/auth/register | - |
| GET | /api/auth/login | ✔ |
| GET | /api/workshops, /api/workshops/nearby, /api/workshops/:id | - |
| POST | /api/bookings | ✔ |
| GET | /api/bookings/my-bookings | ✔ |
| GET | /api/bookings/available-slots | - |
| PATCH | /api/bookings/:id/cancel, /:id/complete | ✔ |
| GET | /api/user/profile | ✔ |

## Screenshot
_(tambahkan screenshot aplikasi di sini)_
