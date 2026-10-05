import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum Gender { female, male }

/// Expression drawn by [FaceBadge].
enum FaceExpression { veryHappy, happy, neutral, sad, verySad }

enum MoodRating {
  baik('Baik', AppTheme.faceGreen, FaceExpression.happy),
  cukup('Cukup', AppTheme.faceYellow, FaceExpression.neutral),
  kurangBaik('Kurang baik', AppTheme.faceOrange, FaceExpression.sad),
  tidakBaik('Tidak baik', AppTheme.faceRed, FaceExpression.verySad);

  final String label;
  final Color color;
  final FaceExpression face;
  const MoodRating(this.label, this.color, this.face);
}

enum StressLevel {
  rendah('Rendah', AppTheme.faceGreen, FaceExpression.happy),
  sedang('Sedang', AppTheme.faceYellow, FaceExpression.neutral),
  tinggi('Tinggi', AppTheme.faceRed, FaceExpression.verySad);

  final String label;
  final Color color;
  final FaceExpression face;
  const StressLevel(this.label, this.color, this.face);
}

enum SleepQuality {
  sangatBaik('Sangat baik', Color(0xFF4CC9A0), FaceExpression.veryHappy),
  baik('Baik', AppTheme.faceGreen, FaceExpression.happy),
  cukup('Cukup', AppTheme.faceYellow, FaceExpression.neutral),
  buruk('Buruk', AppTheme.faceRed, FaceExpression.verySad);

  final String label;
  final Color color;
  final FaceExpression face;
  const SleepQuality(this.label, this.color, this.face);
}

/// Symptom options shown in "Apakah ada gejala?" (mockup halaman 4).
class SymptomOption {
  final String label;
  final IconData icon;
  final Color color;
  final bool redFlag;
  const SymptomOption(this.label, this.icon, this.color, {this.redFlag = false});
}

const String kNoSymptom = 'Tidak ada';

const List<SymptomOption> kSymptoms = [
  SymptomOption(kNoSymptom, Icons.check_circle_outline, Color(0xFF14A38B)),
  SymptomOption('Nyeri dada', Icons.favorite, Color(0xFFEB5757), redFlag: true),
  SymptomOption('Sesak napas', Icons.air, Color(0xFFF2994A), redFlag: true),
  SymptomOption('Pusing', Icons.sync, Color(0xFFF2994A)),
  SymptomOption('Berdebar (palpitasi)', Icons.favorite_border, Color(0xFFEB5757)),
  SymptomOption('Lelah', Icons.accessibility_new, Color(0xFF3B82F6)),
  SymptomOption('Mual', Icons.sick_outlined, Color(0xFF14A38B)),
  SymptomOption('Lainnya', Icons.more_horiz, Color(0xFF6B7280)),
];

/// Activity options (mockup halaman 4 – "Apa yang sedang Anda lakukan?").
const List<(String, IconData)> kActivities = [
  ('Istirahat', Icons.airline_seat_recline_normal),
  ('Duduk', Icons.chair_alt_outlined),
  ('Berdiri', Icons.man),
  ('Berjalan', Icons.directions_walk),
  ('Olahraga', Icons.directions_run),
  ('Bekerja', Icons.work_outline),
  ('Makan', Icons.restaurant),
  ('Lainnya', Icons.more_horiz),
];

/// Event marker options (mockup halaman 5 – "Tambah Event").
const List<(String, IconData, Color)> kEvents = [
  ('Mulai olahraga', Icons.directions_run, Color(0xFF0B7A5A)),
  ('Selesai olahraga', Icons.sports_gymnastics, Color(0xFF0B7A5A)),
  ('Mulai tidur', Icons.bedtime, Color(0xFF7C5CDB)),
  ('Bangun tidur', Icons.alarm, Color(0xFF7C5CDB)),
  ('Makan', Icons.restaurant, Color(0xFFF2994A)),
  ('Minum obat', Icons.medication_outlined, Color(0xFFB7791F)),
  ('Stres/emosi', Icons.sentiment_very_dissatisfied, Color(0xFFEB5757)),
  ('Gejala muncul', Icons.timer_outlined, Color(0xFF14A38B)),
  ('Lainnya', Icons.more_horiz, Color(0xFF6B7280)),
];

enum ActionTriageLevel {
  green('HIJAU', 'Lanjutkan aktivitas',
      'Stabil sesuai baseline; tidak ada red flag; recovery baik.',
      AppTheme.statusGreen, AppTheme.statusGreenBg, Icons.check_circle),
  yellow('KUNING', 'Observasi & catat',
      'Perubahan ringan atau baru; pantau tren dan gejala.',
      AppTheme.statusYellow, AppTheme.statusYellowBg, Icons.visibility),
  orange('ORANYE', 'Hubungi tenaga kesehatan',
      'Deviasi menetap/tidak pulih atau gejala yang memerlukan konsultasi.',
      AppTheme.statusOrange, AppTheme.statusOrangeBg, Icons.call),
  red('MERAH', 'Ke IGD / layanan darurat',
      'Red flag, gejala berat, atau kondisi memburuk cepat.',
      AppTheme.statusRed, AppTheme.statusRedBg, Icons.emergency);

  final String code;
  final String title;
  final String description;
  final Color color;
  final Color bgColor;
  final IconData icon;
  const ActionTriageLevel(
      this.code, this.title, this.description, this.color, this.bgColor, this.icon);
}

class Medication {
  String name;
  String dosage;
  String frequency;
  Medication({required this.name, required this.dosage, required this.frequency});
}

class UserProfile {
  String name;
  DateTime birthDate;
  Gender gender;
  double heightCm;
  double weightKg;
  String timeZone;
  String bloodType;
  String emergencyContactName;
  String emergencyContactPhone;
  String allergies;

  UserProfile({
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.heightCm,
    required this.weightKg,
    this.timeZone = 'WIB (UTC+7)',
    this.bloodType = 'O+',
    this.emergencyContactName = 'Budi Santoso (Suami)',
    this.emergencyContactPhone = '+62 812-3456-7890',
    this.allergies = 'Penicillin (Alergi Antibiotik)',
  });

  int get age {
    final now = DateTime.now();
    var a = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      a--;
    }
    return a;
  }
}

class WearableData {
  bool isConnected;
  String deviceName;
  int batteryPercent;
  DateTime lastSync;
  int heartRate;
  int baselineHr;
  int hrvRmssd;
  int steps;
  int spO2;
  double skinTemp;

  WearableData({
    this.isConnected = true,
    this.deviceName = 'Apple Watch',
    this.batteryPercent = 86,
    required this.lastSync,
    this.heartRate = 72,
    this.baselineHr = 70,
    this.hrvRmssd = 42,
    this.steps = 4280,
    this.spO2 = 98,
    this.skinTemp = 36.4,
  });
}

/// One manual measurement row (mockup halaman 5 – "Input Pengukuran").
class MeasurementEntry {
  final String key;
  final String label;
  final String unit;
  final IconData icon;
  final Color color;
  String? value;
  TimeOfDay? time;

  MeasurementEntry({
    required this.key,
    required this.label,
    required this.unit,
    required this.icon,
    required this.color,
    this.value,
    this.time,
  });
}

class EventItem {
  final String title;
  final IconData icon;
  final Color color;
  final DateTime timestamp;

  EventItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.timestamp,
  });
}

class PedagogyAnswer {
  final int number;
  final String question;
  final String algorithm;
  final String summary;
  final String detail;
  final String status;
  final Color statusColor;

  const PedagogyAnswer({
    required this.number,
    required this.question,
    required this.algorithm,
    required this.summary,
    required this.detail,
    required this.status,
    required this.statusColor,
  });
}
