import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../widgets/experiment_widgets.dart';

class Stage3ProfilScreen extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final VoidCallback? onStageSelect;

  const Stage3ProfilScreen({
    super.key,
    required this.onNext,
    this.onBack,
    this.onStageSelect,
  });

  void _showInterpretationGuide(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD3E0DC),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Cara Kerja Profil Personal',
              style: AppTheme.font(size: 17, weight: FontWeight.w800, color: const Color(0xFF0F2B3C)),
            ),
            const SizedBox(height: 8),
            Text(
              'Sistem mempelajari nilai fisiologis khas Anda per aktivitas. Ketika denyut jantung melampaui rentang variasi yang biasa diamati, sistem menandai kandidat deviasi untuk dievaluasi bersama konteks pengguna.',
              style: AppTheme.font(size: 13, color: const Color(0xFF5E7582), height: 1.4),
            ),
            const SizedBox(height: 18),
            ExperimentPrimaryButton(
              label: 'Mengerti',
              onPressed: () => Navigator.pop(ctx),
              showChevron: false,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF9),
      appBar: ExperimentAppBar(
        stageNumber: 3,
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
              title: 'Profil kesehatan personal',
              subtitle: 'Ringkasan pola dasar yang digunakan sistem.',
            ),

            // Card 1: Baseline Metrics & Maturity
            ExperimentCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE1F5EF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite_rounded, color: Color(0xFF007A64), size: 20),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF6F3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFC7E6DC), width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.bar_chart_rounded, size: 16, color: Color(0xFF007A64)),
                            const SizedBox(width: 5),
                            Text(
                              'Kematangan baseline: sedang',
                              style: AppTheme.font(
                                size: 11,
                                weight: FontWeight.w700,
                                color: const Color(0xFF007A64),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 3 metric columns
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCol(
                          icon: Icons.airline_seat_recline_normal_rounded,
                          label: 'HR duduk',
                          value: '78–84',
                          unit: 'bpm',
                        ),
                      ),
                      Container(width: 1, height: 46, color: const Color(0xFFE4EDE9)),
                      Expanded(
                        child: _buildMetricCol(
                          icon: Icons.accessibility_new_rounded,
                          label: 'HR berdiri',
                          value: '88–96',
                          unit: 'bpm',
                        ),
                      ),
                      Container(width: 1, height: 46, color: const Color(0xFFE4EDE9)),
                      Expanded(
                        child: _buildMetricCol(
                          icon: Icons.show_chart_rounded,
                          label: 'RMSSD dasar',
                          value: '35–42',
                          unit: 'ms',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Card 2: Konteks yang Dipelajari
            ExperimentCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Konteks yang dipelajari',
                    style: AppTheme.font(
                      size: 14.5,
                      weight: FontWeight.w800,
                      color: const Color(0xFF0F2B3C),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Sistem telah mempelajari pola Anda pada beberapa konteks aktivitas berikut.',
                    style: AppTheme.font(
                      size: 12,
                      color: const Color(0xFF6B807B),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 14),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildContextChip(
                        icon: Icons.airline_seat_recline_normal_rounded,
                        label: 'Duduk',
                        bgColor: const Color(0xFFE1F5EF),
                        textColor: const Color(0xFF007A64),
                        isSelected: true,
                      ),
                      _buildContextChip(
                        icon: Icons.accessibility_new_rounded,
                        label: 'Berdiri',
                        bgColor: const Color(0xFFF1F6F5),
                        textColor: const Color(0xFF475569),
                      ),
                      _buildContextChip(
                        icon: Icons.directions_walk_rounded,
                        label: 'Jalan ringan',
                        bgColor: const Color(0xFFF1F6F5),
                        textColor: const Color(0xFF475569),
                      ),
                      _buildContextChip(
                        icon: Icons.hotel_rounded,
                        label: 'Istirahat',
                        bgColor: const Color(0xFFF1F6F5),
                        textColor: const Color(0xFF475569),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Card 3: Ringkasan Longitudinal
            ExperimentCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan longitudinal',
                    style: AppTheme.font(
                      size: 14.5,
                      weight: FontWeight.w800,
                      color: const Color(0xFF0F2B3C),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Tren detak jantung istirahat (HR duduk) dalam beberapa hari terakhir.',
                    style: AppTheme.font(
                      size: 12,
                      color: const Color(0xFF6B807B),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Custom longitudinal trend chart
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: LongitudinalChartPainter(
                        values: const [80, 78, 82, 80, 81],
                        labels: const ['H-4', 'H-3', 'H-2', 'H-1', 'Hari ini'],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // X-Axis day labels
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const ['H-4', 'H-3', 'H-2', 'H-1', 'Hari ini'].map((lbl) {
                        return Text(
                          lbl,
                          style: AppTheme.font(
                            size: 10,
                            color: const Color(0xFF829692),
                            weight: FontWeight.w600,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3 bottom stat blocks
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryBadge(
                          icon: Icons.bar_chart_rounded,
                          label: 'Pola relatif stabil',
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _buildSummaryBadge(
                          icon: Icons.shield_outlined,
                          label: 'Belum ada episode bermakna',
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _buildSummaryBadge(
                          icon: Icons.calendar_today_rounded,
                          label: '2 hari pemantauan aktif',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Card 4: Bagaimana Profil Digunakan?
            ExperimentCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F3F7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.article_outlined, color: Color(0xFF0F3E4D), size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bagaimana profil digunakan?',
                          style: AppTheme.font(
                            size: 13,
                            weight: FontWeight.w700,
                            color: const Color(0xFF0F2B3C),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Profil personal membantu sistem membandingkan pembacaan saat ini dengan pola yang biasa diamati pada konteks serupa.',
                          style: AppTheme.font(
                            size: 11.5,
                            color: const Color(0xFF6B807B),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Action Buttons
            ExperimentPrimaryButton(
              label: 'Lanjut ke pemantauan',
              icon: Icons.play_arrow_rounded,
              onPressed: onNext,
            ),
            const SizedBox(height: 10),
            ExperimentSecondaryButton(
              label: 'Pelajari interpretasi',
              icon: Icons.article_outlined,
              onPressed: () => _showInterpretationGuide(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCol({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF007A64)),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTheme.font(
            size: 10.5,
            color: const Color(0xFF708781),
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: AppTheme.font(
                size: 16,
                weight: FontWeight.w900,
                color: const Color(0xFF0F2B3C),
              ),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: AppTheme.font(
                size: 10.5,
                color: const Color(0xFF708781),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContextChip({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color textColor,
    bool isSelected = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: isSelected ? Border.all(color: const Color(0xFF007A64), width: 1.2) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTheme.font(
              size: 11.5,
              weight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBadge({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2EBE9)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF007A64)),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTheme.font(
              size: 9.5,
              weight: FontWeight.w600,
              color: const Color(0xFF5E7582),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
