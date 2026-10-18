import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../widgets/experiment_widgets.dart';

class Stage4DeviasiScreen extends StatelessWidget {
  final ValueChanged<String>? onConfirmActivity;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final VoidCallback? onStageSelect;

  const Stage4DeviasiScreen({
    super.key,
    required this.onNext,
    this.onConfirmActivity,
    this.onBack,
    this.onStageSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF9),
      appBar: ExperimentAppBar(
        stageNumber: 4,
        onBackPressed: onBack,
        onStageSelect: onStageSelect,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ExperimentPageHeader(
              title: 'Perubahan data terdeteksi',
              subtitle: 'Sistem menemukan pembacaan yang berbeda dari pola biasanya.',
            ),

            // Card 1: Deviation Alert & 10-Minute Rising Chart
            ExperimentCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE2F5EF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite_rounded,
                              color: Color(0xFF007A64),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'HR',
                                style: AppTheme.font(
                                  size: 11,
                                  weight: FontWeight.w700,
                                  color: const Color(0xFF6B807B),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '110',
                                    style: AppTheme.font(
                                      size: 32,
                                      weight: FontWeight.w900,
                                      color: const Color(0xFF0F2B3C),
                                      height: 1.0,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'bpm',
                                    style: AppTheme.font(
                                      size: 14,
                                      weight: FontWeight.w600,
                                      color: const Color(0xFF0F2B3C),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3E2),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFF6D49C)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Color(0xFFD97706),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  '!',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Kandidat deviasi',
                              style: AppTheme.font(
                                size: 11,
                                weight: FontWeight.w800,
                                color: const Color(0xFFB45309),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Detected activity chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F6F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.directions_walk_rounded, size: 15, color: Color(0xFF0F3E4D)),
                        const SizedBox(width: 5),
                        Text(
                          'Aktivitas terdeteksi: Berjalan',
                          style: AppTheme.font(
                            size: 11.5,
                            weight: FontWeight.w700,
                            color: const Color(0xFF0F3E4D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    'Denyut jantung saat ini lebih tinggi daripada pola personal yang biasa diamati pada konteks ini.',
                    style: AppTheme.font(
                      size: 12,
                      color: const Color(0xFF5E7582),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Chart Header & Rising Chart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '10 menit terakhir',
                        style: AppTheme.font(
                          size: 12.5,
                          weight: FontWeight.w800,
                          color: const Color(0xFF0F2B3C),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF007A64),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '110 bpm',
                          style: AppTheme.font(
                            size: 10.5,
                            weight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: DeviationChartPainter(
                        values: const [74, 76, 73, 75, 76, 75, 78, 88, 98, 110],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // X-Axis labels
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const ['-10 mnt', '-8 mnt', '-6 mnt', '-4 mnt', '-2 mnt', 'Sekarang'].map((lbl) {
                        return Text(
                          lbl,
                          style: AppTheme.font(
                            size: 9.5,
                            color: const Color(0xFF829692),
                            weight: FontWeight.w600,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Card 2: Apa yang berubah?
            ExperimentCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Apa yang berubah?',
                    style: AppTheme.font(
                      size: 14.5,
                      weight: FontWeight.w800,
                      color: const Color(0xFF0F2B3C),
                    ),
                  ),
                  const SizedBox(height: 14),

                  _buildChangeItem(
                    icon: Icons.arrow_upward_rounded,
                    iconBg: const Color(0xFFE2F5EF),
                    iconColor: const Color(0xFF007A64),
                    title: 'HR meningkat',
                    subtitle: 'Dari sekitar 75 bpm menjadi 110 bpm.',
                  ),
                  const Divider(height: 18, color: Color(0xFFEDF3F1)),

                  _buildChangeItem(
                    icon: Icons.access_time_rounded,
                    iconBg: const Color(0xFFEBF3F6),
                    iconColor: const Color(0xFF0F3E4D),
                    title: 'Durasi perubahan: 6 menit',
                    subtitle: 'Peningkatan terdeteksi sejak 6 menit yang lalu.',
                  ),
                  const Divider(height: 18, color: Color(0xFFEDF3F1)),

                  _buildChangeItem(
                    icon: Icons.bar_chart_rounded,
                    iconBg: const Color(0xFFE2F5EF),
                    iconColor: const Color(0xFF007A64),
                    title: 'Kualitas sinyal: baik',
                    subtitle: 'Data dapat dipercaya untuk analisis.',
                  ),
                ],
              ),
            ),

            // Card 3: Sistem Membutuhkan Konfirmasi
            ExperimentCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sistem membutuhkan konfirmasi',
                    style: AppTheme.font(
                      size: 14.5,
                      weight: FontWeight.w800,
                      color: const Color(0xFF0F2B3C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Apakah aktivitas yang terdeteksi sudah benar?',
                    style: AppTheme.font(
                      size: 12,
                      color: const Color(0xFF6B807B),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Option 1: Solid teal
                  ExperimentPrimaryButton(
                    label: 'Ya, benar',
                    icon: Icons.check_rounded,
                    onPressed: () {
                      onConfirmActivity?.call('Berjalan');
                      onNext();
                    },
                  ),
                  const SizedBox(height: 10),

                  // Option 2: Outline Sitting correction
                  ExperimentSecondaryButton(
                    label: 'Tidak, saya sedang duduk',
                    icon: Icons.airline_seat_recline_normal_rounded,
                    onPressed: () {
                      onConfirmActivity?.call('Duduk');
                      onNext();
                    },
                  ),
                  const SizedBox(height: 10),

                  // Option 3: Outline Add other experience
                  ExperimentSecondaryButton(
                    label: 'Tambahkan pengalaman lain',
                    icon: Icons.article_outlined,
                    onPressed: () {
                      onConfirmActivity?.call('Lainnya');
                      onNext();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangeItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.font(
                  size: 13,
                  weight: FontWeight.w700,
                  color: const Color(0xFF0F2B3C),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTheme.font(
                  size: 11,
                  color: const Color(0xFF708781),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
