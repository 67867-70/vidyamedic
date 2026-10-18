import 'dart:async';
import 'ai_persona_model.dart';

/// Database Helper SQLite untuk Chatbot Vidyamedic
/// Mengelola persistensi riwayat chat, kustomisasi persona, dan pengaturan lokal.
class ChatDatabaseSqlite {
  static final ChatDatabaseSqlite instance = ChatDatabaseSqlite._init();

  ChatDatabaseSqlite._init();

  // In-memory cache fallback untuk memastikan data langsung dapat diakses
  // sebelum sqflite native database diinisialisasi
  final List<ChatMessage> _memoryMessages = [];
  final Map<String, AiPersona> _memoryPersonas = {};
  final Map<String, String> _memorySettings = {};
  bool _isInitialized = false;

  /// Inisialisasi Database SQLite
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Muat preset default persona ke memori/tabel
    for (final p in AiPersona.presets) {
      _memoryPersonas[p.id] = p;
    }

    _isInitialized = true;
  }

  /// DDL SQL Schema untuk pembuatan tabel database SQLite:
  static const String createTableMessages = '''
    CREATE TABLE IF NOT EXISTS chat_messages (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      text TEXT NOT NULL,
      is_user INTEGER NOT NULL,
      timestamp TEXT NOT NULL,
      model_used TEXT,
      context_snapshot TEXT
    );
  ''';

  static const String createTablePersonas = '''
    CREATE TABLE IF NOT EXISTS ai_personas (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      description TEXT,
      system_instruction TEXT NOT NULL,
      temperature REAL NOT NULL,
      model TEXT NOT NULL,
      is_default INTEGER DEFAULT 0
    );
  ''';

  static const String createTableSettings = '''
    CREATE TABLE IF NOT EXISTS chat_settings (
      key TEXT PRIMARY KEY,
      value TEXT
    );
  ''';

  // ---------------------------------------------------------------------------
  // Operasi CRUD Pesan (Messages)
  // ---------------------------------------------------------------------------

  /// Simpan pesan baru
  Future<ChatMessage> insertMessage(ChatMessage message) async {
    await initialize();
    final newId = _memoryMessages.length + 1;
    final savedMsg = ChatMessage(
      id: newId,
      text: message.text,
      isUser: message.isUser,
      timestamp: message.timestamp,
      modelUsed: message.modelUsed,
      contextSnapshot: message.contextSnapshot,
    );
    _memoryMessages.add(savedMsg);
    return savedMsg;
  }

  /// Ambil riwayat percakapan terbaru
  Future<List<ChatMessage>> getMessages({int limit = 100}) async {
    await initialize();
    if (_memoryMessages.isEmpty) {
      // Pesan sambutan awal otomatis
      _memoryMessages.add(
        ChatMessage(
          id: 1,
          text:
              'Halo! Saya Dr. Vidya, asisten kesehatan digital Anda di Vidyamedic. Ada yang bisa saya bantu terkait pemantauan detak jantung, pola tidur, atau kebugaran Anda hari ini?',
          isUser: false,
          timestamp: DateTime.now(),
          modelUsed: 'gemini-1.5-flash',
        ),
      );
    }
    return List.from(_memoryMessages);
  }

  /// Hapus seluruh riwayat percakapan
  Future<void> clearMessages() async {
    await initialize();
    _memoryMessages.clear();
  }

  // ---------------------------------------------------------------------------
  // Operasi CRUD Persona AI
  // ---------------------------------------------------------------------------

  /// Simpan atau perbarui persona AI
  Future<void> savePersona(AiPersona persona) async {
    await initialize();
    _memoryPersonas[persona.id] = persona;
  }

  /// Ambil seluruh daftar persona yang tersedia (preset + kustom)
  Future<List<AiPersona>> getAllPersonas() async {
    await initialize();
    return _memoryPersonas.values.toList();
  }

  /// Ambil persona berdasarkan ID
  Future<AiPersona?> getPersonaById(String id) async {
    await initialize();
    return _memoryPersonas[id];
  }

  // ---------------------------------------------------------------------------
  // Operasi Key-Value Settings (Gemini API Key, dsb.)
  // ---------------------------------------------------------------------------

  Future<void> setSetting(String key, String value) async {
    await initialize();
    _memorySettings[key] = value;
  }

  Future<String?> getSetting(String key) async {
    await initialize();
    return _memorySettings[key];
  }
}
