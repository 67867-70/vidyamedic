# VidyaMedic AI - Web Central Management (PHP)
**Lokasi Target:** `https://barajacoffee.com/vidya/`

Panel administrasi berbasis PHP untuk mengelola **Google Gemini API Key**, **Model AI**, dan **Persona Dr. Vidya** dari luar aplikasi mobile.

---

## 📂 Berkas di Folder Ini

1. **`index.php`**: Panel Web Admin interaktif (Login PIN, formulir API Key, Persona Editor, Live Chat Test sandbox).
2. **`api.php`**: REST API Endpoint untuk aplikasi Flutter (`?action=config`, `?action=chat`, `?action=ping`).
3. **`config.json`**: Penyimpanan pengaturan aman (API Key, model, teks prompt persona, PIN admin).
4. **`.htaccess`**: Keamanan Apache untuk memblokir unduhan langsung file `config.json` oleh publik dan mengaktifkan CORS.

---

## 🚀 Cara Upload ke Hosting barajacoffee.com

1. Masuk ke **cPanel** atau File Manager hosting `barajacoffee.com`.
2. Buka folder `public_html/`.
3. Buat folder baru bernama **`vidya`** sehingga jalurnya menjadi `public_html/vidya/`.
4. Unggah seluruh isi folder ini (`index.php`, `api.php`, `config.json`, `.htaccess`) ke dalam `public_html/vidya/`.
5. Pastikan hak akses (permissions) file `config.json` dapat ditulis oleh web server (`chmod 666` atau `chmod 777` jika perlu).

---

## 🔐 Cara Akses & Login

1. Buka browser: **`https://barajacoffee.com/vidya/`**
2. Masukkan **PIN Administrator Default**: `1234`
3. Masukkan Google Gemini API Key Anda (dapat diambil gratis dari [Google AI Studio](https://aistudio.google.com/app/apikey)).
4. Sesuaikan nama dokter, pesan sambutan, dan aturan triage medis di tab **Persona**.
5. Klik **"Simpan Semua Pengaturan"**.
6. Anda juga dapat mengganti PIN admin di tab API Key & Model sesuai keinginan.

---

## 📡 REST API Endpoint untuk Flutter

Aplikasi mobile VidyaMedic akan mengakses endpoint berikut:

- **Sinkronisasi Konfigurasi & Persona:**
  `GET https://barajacoffee.com/vidya/api.php?action=config`
- **Proxy Chat Aman (Tanpa membocorkan API Key ke HP):**
  `POST https://barajacoffee.com/vidya/api.php?action=chat`
  ```json
  {
    "user_message": "Dada saya berdebar setelah olahraga, apakah normal?",
    "health_context": {
      "heart_rate_bpm": 105,
      "context": "Duduk istirahat"
    }
  }
  ```
