import 'package:flutter/material.dart';
import '../models/health_models.dart';
import '../theme/app_theme.dart';

class AppState extends ChangeNotifier {
  // ---------------- Onboarding ----------------
  UserProfile userProfile = UserProfile(
    name: 'Ani Setiawan',
    birthDate: DateTime(1985, 4, 12),
    gender: Gender.female,
    heightCm: 160,
    weightKg: 58,
  );

  final List<String> conditionOptions = const [
    'Hipertensi',
    'Diabetes',
    'Penyakit jantung',
    'Asma',
    'Gangguan tidur',
    'Lainnya',
  ];
  List<String> medicalConditions = ['Penyakit jantung'];
  String otherCondition = '';
  String allergies = '';
  List<Medication> routineMedications = [
    Medication(name: 'Bisoprolol', dosage: '5 mg', frequency: '1x sehari (pagi)'),
  ];

  WearableData wearable = WearableData(
    lastSync: DateTime.now().subtract(const Duration(minutes: 3)),
  );

  final List<String> goalOptions = const [
    'Memantau kesehatan sehari-hari',
    'Mencegah kondisi gawat darurat',
    'Meningkatkan kebugaran',
    'Lainnya',
  ];
  String primaryGoal = 'Memantau kesehatan sehari-hari';
  bool notifDailySummary = true;
  TimeOfDay notifDailyTime = const TimeOfDay(hour: 7, minute: 0);
  bool notifCriticalAlerts = true;
  bool notifHealthEducation = true;
  bool allowDataSharing = true;

  // ---------------- Input harian ----------------
  DateTime logDate = DateTime.now();

  // 1. Gejala & perasaan
  MoodRating mood = MoodRating.baik;
  List<String> symptoms = [kNoSymptom];
  double symptomLevel = 1.0; // 0 = Ringan, 1 = Sedang, 2 = Berat

  // 2. Aktivitas & gaya hidup
  String activity = 'Istirahat';
  StressLevel stress = StressLevel.rendah;
  bool habitMeal = true;
  bool habitCaffeine = false;
  bool habitAlcohol = false;
  bool habitSmoking = false;
  bool habitMedication = true;

  // 3. Tidur
  int sleepMinutes = 390;
  SleepQuality sleepQuality = SleepQuality.baik;
  TimeOfDay bedTime = const TimeOfDay(hour: 22, minute: 30);
  TimeOfDay wakeTime = const TimeOfDay(hour: 5, minute: 30);
  bool sleepWakeOften = false;
  bool sleepHardToSleep = false;
  bool sleepNightmare = false;

  // 4. Pengukuran manual
  final List<MeasurementEntry> measurements = [
    MeasurementEntry(
        key: 'bp', label: 'Tekanan Darah', unit: 'mmHg', icon: Icons.speed,
        color: const Color(0xFF2F80ED), value: '120/78',
        time: const TimeOfDay(hour: 8, minute: 15)),
    MeasurementEntry(
        key: 'temp', label: 'Suhu Tubuh', unit: '°C', icon: Icons.thermostat,
        color: const Color(0xFFEB5757), value: '36.6',
        time: const TimeOfDay(hour: 8, minute: 15)),
    MeasurementEntry(
        key: 'weight', label: 'Berat Badan', unit: 'kg', icon: Icons.monitor_weight_outlined,
        color: AppTheme.primary, value: '58.2',
        time: const TimeOfDay(hour: 7, minute: 0)),
    MeasurementEntry(
        key: 'spo2', label: 'SpO₂ (jika tidak otomatis)', unit: '%', icon: Icons.water_drop_outlined,
        color: const Color(0xFF2F80ED), value: '97',
        time: const TimeOfDay(hour: 8, minute: 15)),
    MeasurementEntry(
        key: 'glucose', label: 'Glukosa Darah (opsional)', unit: 'mg/dL', icon: Icons.bloodtype_outlined,
        color: const Color(0xFF7C5CDB), value: '105',
        time: const TimeOfDay(hour: 7, minute: 30)),
  ];

  // 5. Event marker
  List<EventItem> events = [];

  // 6. Catatan
  String note = '';

  // Status sinkronisasi
  DateTime? lastSubmitted;

  // ---------------- Derived ----------------
  bool get hasSymptoms =>
      symptoms.isNotEmpty && !(symptoms.length == 1 && symptoms.first == kNoSymptom);

  String get symptomLevelLabel =>
      symptomLevel < 0.67 ? 'Ringan' : (symptomLevel < 1.34 ? 'Sedang' : 'Berat');

  bool get hasRedFlagSymptom => kSymptoms
      .where((s) => s.redFlag)
      .any((s) => symptoms.contains(s.label));

  int get hrDeviation => wearable.heartRate - wearable.baselineHr;

  bool get dataValid =>
      wearable.isConnected &&
      DateTime.now().difference(wearable.lastSync).inHours < 6;

  MeasurementEntry measurement(String key) =>
      measurements.firstWhere((m) => m.key == key);

  String get sleepDurationLabel {
    final h = sleepMinutes ~/ 60, m = sleepMinutes % 60;
    return m == 0 ? '$h jam' : '$h jam $m menit';
  }

  String get sleepShortLabel {
    final h = sleepMinutes ~/ 60, m = sleepMinutes % 60;
    return m == 0 ? '${h}j' : '${h}j ${m}m';
  }

  /// Prioritas rule engine (mockup halaman 9).
  ActionTriageLevel get triageLevel {
    // 2. Red flag → emergensi, tidak menunggu skor CAPAR.
    if (hasSymptoms &&
        ((hasRedFlagSymptom && symptomLevel >= 1.0) || symptomLevel >= 1.34)) {
      return ActionTriageLevel.red;
    }
    // 3. Gejala + deviasi menetap → hubungi tenaga kesehatan.
    final persistentDeviation = hrDeviation.abs() >= 15;
    if (hasSymptoms && (persistentDeviation || hasRedFlagSymptom)) {
      return ActionTriageLevel.orange;
    }
    // 4. Tidak pulih / perubahan ringan → observasi.
    if (hasSymptoms ||
        sleepQuality == SleepQuality.buruk ||
        stress == StressLevel.tinggi ||
        !dataValid) {
      return ActionTriageLevel.yellow;
    }
    // 5. Stabil dan pulih.
    return ActionTriageLevel.green;
  }

  List<PedagogyAnswer> get pedagogyAnswers {
    final dev = hrDeviation;
    final devText = dev == 0 ? 'sama dengan' : (dev > 0 ? '+$dev bpm di atas' : '$dev bpm di bawah');
    final level = triageLevel;
    return [
      PedagogyAnswer(
        number: 1,
        question: 'Di mana saya sekarang?',
        algorithm: 'Context recognition + baseline retrieval + Mahalanobis state',
        summary: dev.abs() < 10
            ? 'Kondisi Anda berada dalam rentang baseline personal.'
            : 'Kondisi Anda sedikit di luar rentang baseline personal.',
        detail:
            'Detak jantung ${wearable.heartRate} bpm saat $activity, $devText baseline Anda (${wearable.baselineHr} bpm) untuk konteks yang sama.',
        status: dev.abs() < 10 ? 'Dalam baseline' : 'Di luar baseline',
        statusColor: dev.abs() < 10 ? AppTheme.statusGreen : AppTheme.statusYellow,
      ),
      PedagogyAnswer(
        number: 2,
        question: 'Apa yang berubah?',
        algorithm: 'Personalized z-score + delta + multivariate deviation',
        summary: dev.abs() < 10
            ? 'Tidak ada perubahan bermakna dibanding biasanya.'
            : 'Detak jantung berubah $devText biasanya.',
        detail:
            'HRV (RMSSD) ${wearable.hrvRmssd} ms, langkah ${wearable.steps}, SpO₂ ${wearable.spO2}%. Arah dan besar perubahan dihitung terhadap baseline personal, bukan angka populasi.',
        status: dev.abs() < 10 ? 'Minimal' : 'Perlu dipantau',
        statusColor: dev.abs() < 10 ? AppTheme.statusGreen : AppTheme.statusYellow,
      ),
      PedagogyAnswer(
        number: 3,
        question: 'Mengapa?',
        algorithm: 'Contribution decomposition + context attribution',
        summary: 'Konteks yang mungkin terkait: aktivitas $activity, stres ${stress.label.toLowerCase()}, tidur ${sleepQuality.label.toLowerCase()}.',
        detail: [
          if (habitCaffeine) 'Konsumsi kafein dapat menaikkan detak jantung.',
          if (habitSmoking) 'Merokok memengaruhi detak jantung dan HRV.',
          if (habitAlcohol) 'Alkohol dapat menurunkan HRV saat tidur.',
          if (habitMedication) 'Obat rutin sudah diminum.',
          if (!habitMedication) 'Obat rutin belum tercatat diminum.',
        ].join(' '),
        status: 'Kontributor',
        statusColor: AppTheme.primary,
      ),
      PedagogyAnswer(
        number: 4,
        question: 'Berapa lama?',
        algorithm: 'k-of-m persistence + dwell time + finite-state machine',
        summary: hasSymptoms
            ? 'Gejala baru dicatat hari ini — status sementara (transient).'
            : 'Tidak ada episode deviasi yang menetap.',
        detail: 'Perubahan dianggap menetap bila muncul berulang di sebagian besar jendela pengamatan, bukan dari satu pembacaan saja.',
        status: hasSymptoms ? 'Transient' : 'Stabil',
        statusColor: hasSymptoms ? AppTheme.statusYellow : AppTheme.statusGreen,
      ),
      PedagogyAnswer(
        number: 5,
        question: 'Apakah saya sedang pulih?',
        algorithm: 'D(t), dD/dt, recovery FSM, TTR, relapse detection',
        summary: sleepQuality == SleepQuality.buruk
            ? 'Pemulihan belum optimal — tidur semalam kurang baik.'
            : 'Pemulihan berjalan baik setelah tidur $sleepShortLabel.',
        detail: 'Tren deviasi D(t) dan laju perubahannya dipantau untuk melihat apakah kondisi kembali ke baseline atau kambuh (relapse).',
        status: sleepQuality == SleepQuality.buruk ? 'Belum pulih' : 'Pulih',
        statusColor: sleepQuality == SleepQuality.buruk ? AppTheme.statusYellow : AppTheme.statusGreen,
      ),
      PedagogyAnswer(
        number: 6,
        question: 'Apa yang harus saya lakukan?',
        algorithm: 'Safety rules + symptom/red-flag gating + action engine',
        summary: '${level.code} – ${level.title}',
        detail: '${level.description}${dataValid ? '' : ' Data wearable belum tersinkron, sehingga sistem tidak membuat klaim kuat.'}',
        status: level.code,
        statusColor: level.color,
      ),
    ];
  }

  // ---------------- Mutations ----------------
  void update(VoidCallback fn) {
    fn();
    notifyListeners();
  }

  void toggleCondition(String c) => update(() {
        medicalConditions.contains(c) ? medicalConditions.remove(c) : medicalConditions.add(c);
      });

  void addMedication(Medication m) => update(() => routineMedications.add(m));
  void removeMedication(int i) => update(() => routineMedications.removeAt(i));

  void connectWearable(String device) => update(() {
        wearable.deviceName = device;
        wearable.isConnected = true;
        wearable.lastSync = DateTime.now();
      });

  void syncWearable() => update(() {
        wearable.lastSync = DateTime.now();
        wearable.heartRate = 68 + DateTime.now().second % 9;
      });

  void toggleSymptom(String label) => update(() {
        if (label == kNoSymptom) {
          symptoms = [kNoSymptom];
          return;
        }
        symptoms.remove(kNoSymptom);
        symptoms.contains(label) ? symptoms.remove(label) : symptoms.add(label);
        if (symptoms.isEmpty) symptoms = [kNoSymptom];
      });

  void addEvent(EventItem e) => update(() => events.insert(0, e));

  void submitDaily() => update(() => lastSubmitted = DateTime.now());
}
