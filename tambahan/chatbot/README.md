# 🤖 Modul Chatbot AI Vidyamedic (Google Gemini & SQLite)

Folder ini berisi seluruh implementasi mandiri untuk modul **Asisten Chatbot AI** dengan integrasi **Google Gemini REST API** dan penyimpanan **SQLite Database**, disiapkan di folder `tambahan/chatbot` sesuai permintaan agar tidak mengganggu codebase utama.

---

## 📂 Struktur File di `tambahan/chatbot/`

| File | Deskripsi Fungsional |
| :--- | :--- |
| **`ai_persona_model.dart`** | Model data untuk persona asisten, model AI, dan struktur pesan riwayat chat (`ChatMessage` & `AiPersona`). |
| **`gemini_api_service.dart`** | Service REST API langsung ke Google Gemini (`v1beta/models/...:generateContent`). Mendukung multi-turn chat, injeksi data sensor fisiologis pasien (HR, aktivitas), dan fallback cerdas ketika API key belum diset. |
| **`chat_database_sqlite.dart`** | Skema DDL SQLite dan Database Helper untuk menyimpan riwayat chat, kustomisasi persona, dan pengaturan lokal secara persisten. |
| **`ai_settings_sheet.dart`** | Modal antarmuka pengguna untuk **memasukkan Gemini API Key**, memilih model (`gemini-1.5-flash`, `gemini-1.5-pro`, `gemini-2.0-flash`), dan **menulis System Prompt / Persona AI**. |
| **`ai_chat_screen.dart`** | Layar obrolan chat interaktif lengkap dengan bubble pesan, quick prompts, status AI aktif, tombol pengaturan ⚙️, dan hapus riwayat. |

---

## ⚙️ Dimana & Bagaimana Mengatur Gemini Key dan Persona AI?

### 1. Membuka Pengaturan
Pada layar obrolan ([ai_chat_screen.dart](file:///d:/nadiku/vidyamedic/tambahan/chatbot/ai_chat_screen.dart)):
* Ketuk **ikon gerigi (⚙️)** di sudut kanan atas AppBar, atau
* Ketuk **banner kuning di bagian atas** yang berbunyi *"Gemini API Key belum dimasukkan"*.

### 2. Memasukkan Gemini API Key
* Kolom pertama adalah **Google Gemini API Key**.
* Anda dapat memperoleh kunci gratis di [Google AI Studio](https://aistudio.google.com).
* Terdapat tombol mata 👁️ untuk menyembunyikan/menampilkan kunci.
* Kunci tersimpan aman di `SharedPreferences` perangkat secara lokal.

### 3. Memilih dan Mengkustomisasi Persona AI
Terdapat 4 pilihan persona:
1. **Dokter Pendamping Ramah & Edukatif** *(Default)*:
   - Pendekatan empatik, ramah, edukasi gaya hidup, penekanan non-klinis dan arahan keselamatan IGD bila darurat.
2. **Konsultan Pemulihan & Gaya Hidup**:
   - Fokus pada skor pemulihan (RMSSD), latihan pernapasan, manajemen stres, dan kualitas tidur.
3. **Analis Medis Ringkas & Presisi**:
   - Analisis angka deviasi fisiologis to-the-point dan terstruktur.
4. **Persona Kustom (Bebas Tulis Sendiri)**:
   - Pengguna/peneliti dapat langsung mengetikkan instruksi khusus (*system prompt*) pada kotak teks yang disediakan.

### 4. Pengaturan Kreativitas (Temperature) & Model
* **Slider Temperature** (0.0 = sangat kaku & faktual s.d. 1.0 = santai & kreatif).
* **Pilihan Model**: `gemini-1.5-flash` (cepat & efisien) atau `gemini-1.5-pro` (analisis mendalam).

---

## 🚀 Cara Menghubungkan ke Tab ke-5 di `home_screen.dart` (Jika Sudah Siap)

Jika Anda sudah siap mengaktifkan tab ke-5 di aplikasi utama, cukup tambahkan 1 baris import dan masukkan `AiChatScreen` ke dalam list navigasi:

```dart
// Di lib/screens/home/home_screen.dart:
import '../../tambahan/chatbot/ai_chat_screen.dart';

// Di dalam list pages:
final pages = [
  _PedagogyDashboard(...),
  const _InputFlowTab(),
  const AiChatScreen(),        // <-- Tab ke-3 atau ke-5
  const DailySummaryScreen(),
  const ProfileScreen(),
];

// Di NavigationBar destinations:
NavigationDestination(
  icon: Icon(Icons.chat_bubble_outline_rounded, size: 22),
  selectedIcon: Icon(Icons.chat_bubble_rounded, color: AppTheme.primary, size: 23),
  label: 'Tanya AI',
),
```
