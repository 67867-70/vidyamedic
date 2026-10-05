import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import 'pedagogy_screen_what_changed.dart';

/// Mockup Lanjutan Halaman 5: Layar 2 - Kondisi Saat Ini ("Where Am I?")
class WhereAmIScreen extends StatelessWidget {
  const WhereAmIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final u = s.userProfile;
    final w = s.wearable;

    return MockupScaffold(
      title: 'Kondisi Saat Ini',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting & avatar
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primarySoft,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryLight.withValues(alpha: 0.3)),
                ),
                child: Center(
                  child: Text(
                    u.name.isNotEmpty ? u.name.substring(0, 1) : 'B',
                    style: AppTheme.font(size: 18, weight: FontWeight.w800, color: AppTheme.primaryDark),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Halo, ${u.name}!', style: AppTheme.font(size: 16, weight: FontWeight.w800)),
                    Text('Senang melihat kamu kembali. Yuk pantau kondisi kesehatanmu hari ini.',
                        style: AppTheme.font(size: 11.5, color: AppTheme.textSecondary, height: 1.25)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Status Banner (Perlu Observasi / Dalam Batas / Deviasi)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.5), width: 1.2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Color(0xFFF59E0B), shape: BoxShape.circle),
                  child: const Icon(Icons.priority_high_rounded, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Perlu Observasi',
                          style: AppTheme.font(size: 14, weight: FontWeight.w800, color: const Color(0xFF92400E))),
                      const SizedBox(height: 2),
                      Text(
                        'Ada beberapa perubahan dari kondisi biasanya. Tetap tenang dan terus pantau.',
                        style: AppTheme.font(size: 12, color: const Color(0xFF78350F), height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2x2 Grid: HR, Durasi Tidur, Aktivitas, HRV
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  icon: Icons.favorite,
                  iconColor: AppTheme.faceRed,
                  title: 'Detak Jantung',
                  value: '${w.heartRate} bpm',
                  delta: '(+18 dari biasanya)',
                  deltaIsAlert: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  icon: Icons.bedtime,
                  iconColor: const Color(0xFF6366F1),
                  title: 'Durasi Tidur',
                  value: '5,2 jam',
                  delta: '(-2,1 jam)',
                  deltaIsAlert: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  icon: Icons.directions_walk,
                  iconColor: const Color(0xFF0EA5E9),
                  title: 'Aktivitas Harian',
                  value: '1.200 langkah',
                  delta: 'Rendah (dari 6.000)',
                  deltaIsAlert: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  icon: Icons.monitor_heart_outlined,
                  iconColor: const Color(0xFF10B981),
                  title: 'HRV (RMSSD)',
                  value: '${w.hrvRmssd} ms',
                  delta: '(-35% dari 43 ms)',
                  deltaIsAlert: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Natural Language Summary
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderLight),
              boxShadow: AppTheme.shadowSoft,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline, size: 18, color: AppTheme.primary),
                    const SizedBox(width: 8),
                    Text('Ringkasan Hari Ini',
                        style: AppTheme.font(size: 13.5, weight: FontWeight.w700, color: AppTheme.primaryDark)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Detak jantungmu lebih tinggi dari biasanya, tidur lebih singkat, dan aktivitas lebih rendah. Kondisimu saat ini perlu observasi. Tetap pantau dan perhatikan bagaimana perasaanmu.',
                  style: AppTheme.font(size: 12.5, color: AppTheme.textPrimary, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Action button to step 2: "Apa yang Berubah?"
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WhatChangedScreen()),
            ),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.primarySoft,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.primaryLight.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.trending_up, color: AppTheme.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Langkah Selanjutnya: Apa yang Berubah?',
                            style: AppTheme.font(size: 13, weight: FontWeight.w700, color: AppTheme.primaryDark)),
                        Text('Lihat grafik perbandingan fitur terhadap baseline personal',
                            style: AppTheme.font(size: 11.5, color: AppTheme.textSecondary)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.primary),
                ],
              ),
            ),
          ),
        ],
      ),
      bottom: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WhatChangedScreen()),
        ),
        child: const Text('Lihat Apa yang Berubah →'),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String delta;
  final bool deltaIsAlert;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.delta,
    this.deltaIsAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: AppTheme.shadowSoft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.font(size: 11, color: AppTheme.textMuted, weight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.font(size: 14.5, weight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            delta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.font(
              size: 10,
              weight: FontWeight.w600,
              color: deltaIsAlert ? const Color(0xFFDC2626) : AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
