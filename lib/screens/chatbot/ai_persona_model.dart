/// Model data untuk Konfigurasi Persona AI dan Pesan Chat
class AiPersona {
  final String id;
  final String name;
  final String description;
  final String systemInstruction;
  final double temperature;
  final String model;
  final bool isDefault;

  const AiPersona({
    required this.id,
    required this.name,
    required this.description,
    required this.systemInstruction,
    this.temperature = 0.7,
    this.model = 'gemini-1.5-flash',
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'system_instruction': systemInstruction,
      'temperature': temperature,
      'model': model,
      'is_default': isDefault ? 1 : 0,
    };
  }

  factory AiPersona.fromMap(Map<String, dynamic> map) {
    return AiPersona(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      systemInstruction: map['system_instruction'] as String,
      temperature: (map['temperature'] as num?)?.toDouble() ?? 0.7,
      model: map['model'] as String? ?? 'gemini-1.5-flash',
      isDefault: (map['is_default'] as int? ?? 0) == 1,
    );
  }

  /// Preset persona siap pakai untuk Vidyamedic
  static List<AiPersona> get presets => [
        const AiPersona(
          id: 'dokter_ramah',
          name: 'Dokter Pendamping Ramah & Edukatif (Rekomendasi)',
          description:
              'Berbicara secara empatik, edukatif, dan mudah dipahami oleh pasien awam. Tidak memberikan diagnosis mutlak.',
          systemInstruction: '''
Anda adalah Dr. Vidya, asisten kesehatan digital resmi dari Vidyamedic.
Tugas utama Anda:
1. Membantu pasien memahami sinyal tubuh mereka (detak jantung, stres, variabilitas denyut nadi/RMSSD, tidur).
2. Selalu bersikap empatik, tenang, dan ramah seperti dokter keluarga yang mendampingi pasien.
3. Gunakan bahasa Indonesia yang santun, jelas, dan hindari istilah medis yang terlalu membingungkan tanpa penjelasan.
4. PENTING: Jelaskan bahwa informasi ini bersifat pemantauan dan edukasi gaya hidup, BUKAN diagnosis medis pengganti konsultasi langsung dengan dokter.
5. Jika ada tanda bahaya darurat (nyeri dada hebat, sesak berat, pingsan), anjurkan segera ke IGD terdekat.
''',
          temperature: 0.7,
          model: 'gemini-1.5-flash',
          isDefault: true,
        ),
        const AiPersona(
          id: 'konsultan_kebugaran',
          name: 'Konsultan Pemulihan & Gaya Hidup',
          description:
              'Fokus pada pemulihan fisik (recovery), kualitas tidur, manajemen stres, dan kebiasaan harian.',
          systemInstruction: '''
Anda adalah Coach Vidya, spesialis pemulihan fisiologis dan kebugaran preventif di Vidyamedic.
Tugas Anda:
1. Memberikan saran praktis seputar aktivitas fisik, teknik pernapasan untuk menurunkan stres, hidrasi, dan perbaikan tidur.
2. Membantu pengguna mengoptimalkan skor pemulihan harian dan memahami kapan tubuh butuh istirahat vs kapan siap beraktivitas.
3. Berikan tips langkah demi langkah yang realistis dan dapat diterapkan hari ini.
''',
          temperature: 0.8,
          model: 'gemini-1.5-flash',
        ),
        const AiPersona(
          id: 'analis_data_ringkas',
          name: 'Analis Medis Ringkas & Presisi',
          description:
              'Fokus pada interpretasi data angka detak jantung dan deviasi secara to-the-point dan analitis.',
          systemInstruction: '''
Anda adalah Analis Data Klinis Vidyamedic.
Tugas Anda:
1. Menganalisis parameter fisiologis (Heart Rate bpm, deviasi z-score, interval RR/IBI) secara ringkas, berbobot, dan to-the-point.
2. Sajikan kesimpulan data dalam bentuk poin-poin terstruktur.
3. Tunjukkan batas interpretasi sinyal sensor secara transparan.
''',
          temperature: 0.4,
          model: 'gemini-1.5-pro',
        ),
      ];
}

/// Model data untuk pesan chat
class ChatMessage {
  final int? id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? modelUsed;
  final String? contextSnapshot;

  ChatMessage({
    this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.modelUsed,
    this.contextSnapshot,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'text': text,
      'is_user': isUser ? 1 : 0,
      'timestamp': timestamp.toIso8601String(),
      'model_used': modelUsed,
      'context_snapshot': contextSnapshot,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as int?,
      text: map['text'] as String,
      isUser: (map['is_user'] as int) == 1,
      timestamp: DateTime.parse(map['timestamp'] as String),
      modelUsed: map['model_used'] as String?,
      contextSnapshot: map['context_snapshot'] as String?,
    );
  }
}
