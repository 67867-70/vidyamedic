import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';

/// Mockup Lanjutan Halaman 15: Contoh Patient Journey (Alur Temporal 6 Layar VidyaMedic)
class PatientJourneyScreen extends StatefulWidget {
  const PatientJourneyScreen({super.key});

  @override
  State<PatientJourneyScreen> createState() => _PatientJourneyScreenState();
}

class _PatientJourneyScreenState extends State<PatientJourneyScreen> {
  int _activeStep = 0;

  static const _steps = [
    (
      time: '07:00',
      title: 'Baseline Context',
      badge: 'Hijau (Normal)',
      badgeColor: Color(0xFF10B981),
      desc: 'Pasien duduk setelah bangun. HR dan RR sesuai baseline personal; status hijau.',
      metrics: 'HR: 72 bpm • HRV: 48 ms • Aktivitas: Duduk',
    ),
    (
      time: '13:10',
      title: 'Perubahan Mulai',
      badge: 'Deteksi Awal',
      badgeColor: Color(0xFF0EA5E9),
      desc: 'Saat duduk bekerja, HR meningkat dan RMSSD turun meskipun sensor akselerometer (ACC) rendah.',
      metrics: 'HR: 88 bpm • HRV: 32 ms • ACC: Rendah',
    ),
    (
      time: '13:18',
      title: 'Deviation Detected',
      badge: 'Evaluasi Mahalanobis',
      badgeColor: Color(0xFFF59E0B),
      desc: 'Z-score dan Mahalanobis distance melewati threshold; sistem belum memberi alert karena menunggu persistensi temporal.',
      metrics: 'Z-score: +2.3 • D(t) > threshold',
    ),
    (
      time: '13:25',
      title: 'Persistent Deviation',
      badge: 'Perlu Observasi',
      badgeColor: Color(0xFFF59E0B),
      desc: 'Kriteria k-of-m terpenuhi; VidyaMedic menampilkan status "Perlu Observasi" dan meminta input konteks / gejala.',
      metrics: 'Durasi deviasi: >15 menit • Prompt input dikirim',
    ),
    (
      time: '13:28',
      title: 'Context Added',
      badge: 'Input Pasien',
      badgeColor: Color(0xFF6366F1),
      desc: 'Pasien melaporkan kurang tidur dan stres kerja, tanpa keluhan nyeri dada atau sesak nafas (No Red Flags).',
      metrics: 'Stres: Tinggi • Tidur: 5.2 jam • Red Flag: Nihil',
    ),
    (
      time: '13:35',
      title: 'Recovery Begins',
      badge: 'Pemulihan 40%',
      badgeColor: Color(0xFF10B981),
      desc: 'D(t) mulai turun; recovery progress 40%. Sistem menyarankan istirahat singkat, hidrasi, dan pernapasan rileks.',
      metrics: 'HR: 80 bpm • dD/dt < 0 (Penurunan)',
    ),
    (
      time: '14:00',
      title: 'Recovered',
      badge: 'Pulih Penuh (100%)',
      badgeColor: Color(0xFF10B981),
      desc: 'D(t) kembali ke region baseline personal dan dwell recovery terpenuhi; episode deviasi ditutup secara aman.',
      metrics: 'HR: 74 bpm • Dwell recovery 20 mnt',
    ),
    (
      time: 'Malam',
      title: 'Reflection & Learning',
      badge: 'Ringkasan Harian',
      badgeColor: AppTheme.primary,
      desc: 'Aplikasi menyajikan ringkasan: apa yang berubah, faktor kontributor stres, durasi 22 mnt, dan saran tidur lebih awal.',
      metrics: 'Micro-learning tersimpan • Log governance OK',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MockupScaffold(
      title: 'Simulasi Patient Journey',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.primaryLight.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.timeline, color: AppTheme.primary, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Simulasi kronologis bagaimana 6 layar pedagogis bekerja sebagai satu siklus dari baseline -> deviasi -> input konteks -> recovery -> refleksi.',
                    style: AppTheme.font(size: 12, color: AppTheme.textSecondary, height: 1.35),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          ..._steps.asMap().entries.map((e) {
            final idx = e.key;
            final item = e.value;
            final isSelected = _activeStep == idx;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : const Color(0xFFFAFCFA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? item.badgeColor : AppTheme.borderLight,
                  width: isSelected ? 1.8 : 1,
                ),
                boxShadow: isSelected ? AppTheme.shadowCard : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => setState(() => _activeStep = idx),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: item.badgeColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.time,
                                style: AppTheme.font(
                                  size: 11,
                                  weight: FontWeight.w800,
                                  color: item.badgeColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTheme.font(size: 13.5, weight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: item.badgeColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.badge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTheme.font(size: 9.5, weight: FontWeight.w700, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(item.desc, style: AppTheme.font(size: 12.5, color: AppTheme.textPrimary, height: 1.35)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '📊 ${item.metrics}',
                            style: AppTheme.font(size: 11, color: AppTheme.textMuted, weight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
