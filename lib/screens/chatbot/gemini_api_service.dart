import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'ai_persona_model.dart';

/// Service untuk menghubungkan Chatbot Vidyamedic langsung ke Google Gemini API
class GeminiApiService {
  static const String _prefApiKey = 'gemini_api_key';
  static const String _prefSelectedPersonaId = 'gemini_selected_persona_id';
  static const String _prefCustomSystemInstruction = 'gemini_custom_system_instruction';
  static const String _prefSelectedModel = 'gemini_selected_model';
  static const String _prefRemoteUrl = 'vidya_remote_api_url';
  static const String _prefUseRemote = 'vidya_use_remote_backend';

  static const String defaultRemoteApiUrl = 'https://barajacoffee.com/vidya/api.php';

  static String? _cachedApiKey;
  static String _cachedModel = 'gemini-1.5-flash';
  static String _remoteApiUrl = defaultRemoteApiUrl;
  static bool _useRemoteBackend = true;
  static AiPersona _currentPersona = AiPersona.presets.first;
  static DateTime? _lastSyncTime;

  /// Inisialisasi pengaturan dari penyimpanan lokal
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedApiKey = prefs.getString(_prefApiKey);
    _cachedModel = prefs.getString(_prefSelectedModel) ?? 'gemini-1.5-flash';
    _remoteApiUrl = prefs.getString(_prefRemoteUrl) ?? defaultRemoteApiUrl;
    _useRemoteBackend = prefs.getBool(_prefUseRemote) ?? true;

    final savedPersonaId = prefs.getString(_prefSelectedPersonaId);
    final customPrompt = prefs.getString(_prefCustomSystemInstruction);

    if (savedPersonaId != null) {
      final found = AiPersona.presets.where((p) => p.id == savedPersonaId);
      if (found.isNotEmpty) {
        _currentPersona = found.first;
      } else if (customPrompt != null) {
        _currentPersona = AiPersona(
          id: 'custom',
          name: 'Dr. Vidya (Web Admin)',
          description: 'Dikonfigurasi dari barajacoffee.com/vidya',
          systemInstruction: customPrompt,
          model: _cachedModel,
        );
      }
    }

    // Coba sinkronisasi otomatis dari server web di latar belakang
    if (_useRemoteBackend) {
      syncFromRemoteServer().catchError((_) => false);
    }
  }

  /// Sinkronisasi pengaturan persona & model dari server barajacoffee.com/vidya
  static Future<bool> syncFromRemoteServer() async {
    try {
      final uri = Uri.parse('$_remoteApiUrl?action=config');
      final response = await http.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['status'] == 'success') {
          final personaData = data['persona'] as Map<String, dynamic>?;
          if (personaData != null) {
            final name = personaData['name'] ?? 'Dr. Vidya';
            final title = personaData['title'] ?? 'Dokter Pendamping Telemedis';
            final instruction = personaData['system_instruction'] ?? _currentPersona.systemInstruction;
            final remoteModel = data['gemini_model'] ?? 'gemini-1.5-flash';

            _currentPersona = AiPersona(
              id: 'remote_web',
              name: name,
              description: title,
              systemInstruction: instruction,
              model: remoteModel,
            );
            _cachedModel = remoteModel;
            _lastSyncTime = DateTime.now();

            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(_prefSelectedPersonaId, 'remote_web');
            await prefs.setString(_prefCustomSystemInstruction, instruction);
            await prefs.setString(_prefSelectedModel, remoteModel);
            return true;
          }
        }
      }
      return false;
    } catch (_) {
      // Offline atau server belum merespon
      return false;
    }
  }

  /// URL Remote Backend saat ini
  static String getRemoteApiUrl() => _remoteApiUrl;

  /// Update URL Remote Backend
  static Future<void> setRemoteApiUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    _remoteApiUrl = url.trim();
    await prefs.setString(_prefRemoteUrl, _remoteApiUrl);
  }

  /// Status apakah menggunakan backend server web
  static bool getUseRemoteBackend() => _useRemoteBackend;

  /// Atur mode backend remote
  static Future<void> setUseRemoteBackend(bool useRemote) async {
    final prefs = await SharedPreferences.getInstance();
    _useRemoteBackend = useRemote;
    await prefs.setBool(_prefUseRemote, useRemote);
  }

  /// Waktu terakhir sinkronisasi dari server
  static DateTime? getLastSyncTime() => _lastSyncTime;

  /// Dapatkan API Key saat ini (lokal override)
  static Future<String?> getApiKey() async {
    if (_cachedApiKey != null) return _cachedApiKey;
    final prefs = await SharedPreferences.getInstance();
    _cachedApiKey = prefs.getString(_prefApiKey);
    return _cachedApiKey;
  }

  /// Simpan API Key ke penyimpanan lokal
  static Future<void> setApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    _cachedApiKey = apiKey.trim();
    await prefs.setString(_prefApiKey, _cachedApiKey!);
  }

  /// Dapatkan Model saat ini
  static String getSelectedModel() => _cachedModel;

  /// Simpan Pilihan Model Gemini
  static Future<void> setSelectedModel(String model) async {
    final prefs = await SharedPreferences.getInstance();
    _cachedModel = model;
    await prefs.setString(_prefSelectedModel, model);
  }

  /// Dapatkan Persona aktif saat ini
  static AiPersona getCurrentPersona() => _currentPersona;

  /// Simpan Pengaturan Persona
  static Future<void> setPersona(AiPersona persona) async {
    _currentPersona = persona;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefSelectedPersonaId, persona.id);
    await prefs.setString(_prefCustomSystemInstruction, persona.systemInstruction);
  }

  /// Kirim pesan ke Chatbot AI (Mendukung Web Proxy Server barajacoffee.com/vidya & Direct Gemini API)
  static Future<String> sendMessage({
    required String userMessage,
    List<ChatMessage> conversationHistory = const [],
    Map<String, dynamic>? patientHealthContext,
  }) async {
    // 1. Coba kirimkan melalui Backend Proxy PHP barajacoffee.com/vidya
    if (_useRemoteBackend) {
      try {
        final chatUri = Uri.parse('$_remoteApiUrl?action=chat');
        final historyList = conversationHistory.map((m) => {
          'sender': m.isUser ? 'user' : 'ai',
          'text': m.text,
        }).toList();

        final reqBody = {
          'user_message': userMessage,
          'history': historyList,
          'health_context': patientHealthContext ?? {},
        };

        final res = await http.post(
          chatUri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(reqBody),
        ).timeout(const Duration(seconds: 20));

        if (res.statusCode == 200) {
          final resJson = jsonDecode(res.body) as Map<String, dynamic>;
          if (resJson['status'] == 'success' && resJson['reply'] != null) {
            return resJson['reply'] as String;
          }
        }
      } catch (_) {
        // Jika server web offline / belum terpasang, lanjutkan ke fallback lokal
      }
    }

    // 2. Fallback: Gunakan Direct API Key jika ada di memori lokal
    final apiKey = await getApiKey();
    if (apiKey != null && apiKey.trim().isNotEmpty) {
      if (apiKey.startsWith('gsk_')) {
        try {
          final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');
          final List<Map<String, dynamic>> groqMsgs = [
            {'role': 'system', 'content': _currentPersona.systemInstruction}
          ];
          for (final msg in conversationHistory) {
            groqMsgs.add({
              'role': msg.isUser ? 'user' : 'assistant',
              'content': msg.text,
            });
          }
          groqMsgs.add({'role': 'user', 'content': userMessage});
          final response = await http.post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $apiKey',
            },
            body: jsonEncode({
              'model': 'llama-3.3-70b-versatile',
              'messages': groqMsgs,
              'temperature': _currentPersona.temperature,
            }),
          ).timeout(const Duration(seconds: 25));

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body) as Map<String, dynamic>;
            final reply = data['choices']?[0]?['message']?['content'];
            if (reply != null) return reply as String;
          }
        } catch (_) {}
      } else {
        try {
          final model = _cachedModel;
          final url = Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey',
          );

          String systemInstructionText = _currentPersona.systemInstruction;
          if (patientHealthContext != null && patientHealthContext.isNotEmpty) {
            systemInstructionText += '\n\n[DATA FISIOLOGIS REAL-TIME PASIEN SAAT INI]:\n';
            patientHealthContext.forEach((key, value) {
              systemInstructionText += '- $key: $value\n';
            });
          }

          final List<Map<String, dynamic>> contents = [];
          final recentHistory = conversationHistory.length > 6
              ? conversationHistory.sublist(conversationHistory.length - 6)
              : conversationHistory;

          for (final msg in recentHistory) {
            contents.add({
              'role': msg.isUser ? 'user' : 'model',
              'parts': [{'text': msg.text}],
            });
          }

          contents.add({
            'role': 'user',
            'parts': [{'text': userMessage}],
          });

          final requestBody = {
            'contents': contents,
            'system_instruction': {
              'parts': [{'text': systemInstructionText}]
            },
            'generationConfig': {
              'temperature': _currentPersona.temperature,
              'maxOutputTokens': 1000,
              'topP': 0.95,
            },
          };

          final response = await http
              .post(
                url,
                headers: {
                  'Content-Type': 'application/json',
                  'x-goog-api-key': apiKey,
                },
                body: jsonEncode(requestBody),
              )
              .timeout(const Duration(seconds: 25));

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body) as Map<String, dynamic>;
            final candidates = data['candidates'] as List<dynamic>?;
            if (candidates != null && candidates.isNotEmpty) {
              final content = candidates.first['content'] as Map<String, dynamic>?;
              final parts = content?['parts'] as List<dynamic>?;
              if (parts != null && parts.isNotEmpty) {
                return parts.first['text'] as String;
              }
            }
          }
        } catch (_) {
          // Lanjut ke fallback cerdas
        }
      }
    }

    // 3. Fallback Cerdas Terintegrasi jika offline / kunci belum ada
    return _generateSimulatedResponse(userMessage, patientHealthContext);
  }

  /// Simulasi balasan cerdas terintegrasi ketika API Key belum diisi
  static String _generateSimulatedResponse(String message, Map<String, dynamic>? ctx) {
    final lower = message.toLowerCase();
    final hr = ctx?['Heart Rate'] ?? '82 bpm';
    final act = ctx?['Aktivitas'] ?? 'Duduk';

    if (lower.contains('deviasi') || lower.contains('detak jantung') || lower.contains('hr')) {
      return 'Halo! Data sensor Anda saat ini menunjukkan denyut jantung $hr pada konteks $act. Pada pola istirahat normal, fluktuasi ringan wajar terjadi karena perubahan posisi atau konsumsi kafein. Namun jika denyut bertahan tinggi tanpa pemicu fisik jelas, luangkan waktu duduk rileks 5 menit untuk evaluasi ulang.';
    } else if (lower.contains('stres') || lower.contains('cemas') || lower.contains('tenang')) {
      return 'Ketika merasa tegang, cobalah teknik pernapasan 4-7-8: tarik napas perlahan selama 4 detik, tahan 7 detik, dan hembuskan perlahan selama 8 detik. Latihan ini membantu menurunkan stimulasi saraf simpatis dan meredakan laju detak jantung secara alami.';
    } else if (lower.contains('tidur') || lower.contains('lelah')) {
      return 'Kualitas tidur sangat menentukan skor pemulihan (RMSSD) Anda esok hari. Cobalah menghindari layar ponsel 30 menit sebelum tidur dan pastikan ruangan bersuhu sejuk agar detak jantung istirahat optimal.';
    } else {
      return 'Halo! Saya asisten kesehatan Vidyamedic (${_currentPersona.name}). Pengaturan AI & Gemini Key Anda dikelola terpusat dari web https://barajacoffee.com/vidya. Saya siap membantu menjawab pertanyaan seputar denyut jantung, tidur, dan pola hidup sehat.';
    }
  }
}
