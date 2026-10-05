import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import 'pedagogy_screen_recovery.dart';

/// Mockup Lanjutan Halaman 7: Layar 4 - Mengapa? ("Why?")
class WhyScreen extends StatelessWidget {
  const WhyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MockupScaffold(
      title: 'Mengapa?',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Faktor yang Mungkin Berkontribusi',
            style: AppTheme.font(size: 15, weight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Berdasarkan data wearable, catatan harian, dan pola beberapa hari terakhir.',
            style: AppTheme.font(size: 12, color: AppTheme.textSecondary, height: 1.35),
          ),
          const SizedBox(height: 16),

          // 1. Stres (Tinggi)
          _FactorTile(
            icon: Icons.psychology_outlined,
            iconColor: const Color(0xFFDC2626),
            title: 'Stres',
            levelText: 'Kemungkinan tinggi',
            levelColor: const Color(0xFFDC2626),
            levelBadge: 'Tinggi',
            desc: 'HR meningkat dan HRV menurun',
          ),

          // 2. Kurang Tidur (Tinggi)
          _FactorTile(
            icon: Icons.bedtime_outlined,
            iconColor: const Color(0xFFDC2626),
            title: 'Kurang Tidur',
            levelText: 'Kemungkinan tinggi',
            levelColor: const Color(0xFFDC2626),
            levelBadge: 'Tinggi',
            desc: 'Durasi tidur 2,1 jam lebih singkat dari biasanya',
          ),

          // 3. Aktivitas Rendah (Sedang)
          _FactorTile(
            icon: Icons.directions_walk,
            iconColor: const Color(0xFFF59E0B),
            title: 'Aktivitas Rendah',
            levelText: 'Kemungkinan sedang',
            levelColor: const Color(0xFFF59E0B),
            levelBadge: 'Sedang',
            desc: 'Aktivitas fisik lebih rendah dari biasanya',
          ),

          // 4. Gejala (Sedang)
          _FactorTile(
            icon: Icons.coronavirus_outlined,
            iconColor: const Color(0xFFF59E0B),
            title: 'Gejala',
            levelText: 'Kemungkinan sedang',
            levelColor: const Color(0xFFF59E0B),
            levelBadge: 'Sedang',
            desc: 'Ada keluhan ringan yang berpengaruh',
          ),

          // 5. Obat / Suplemen (Rendah)
          _FactorTile(
            icon: Icons.medication_outlined,
            iconColor: const Color(0xFF10B981),
            title: 'Obat / Suplemen',
            levelText: 'Kemungkinan rendah',
            levelColor: const Color(0xFF10B981),
            levelBadge: 'Rendah',
            desc: 'Tidak ada perubahan signifikan',
          ),

          // 6. Hidrasi (Rendah)
          _FactorTile(
            icon: Icons.water_drop_outlined,
            iconColor: const Color(0xFF10B981),
            title: 'Hidrasi',
            levelText: 'Kemungkinan rendah',
            levelColor: const Color(0xFF10B981),
            levelBadge: 'Rendah',
            desc: 'Asupan cairan dalam batas normal',
          ),
          const SizedBox(height: 12),

          // Kesimpulan Sementara Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryLight.withValues(alpha: 0.35)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline, color: AppTheme.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kesimpulan Sementara',
                          style: AppTheme.font(size: 13, weight: FontWeight.w700, color: AppTheme.primaryDark)),
                      const SizedBox(height: 4),
                      Text(
                        'Kombinasi kurang tidur dan peningkatan stres kemungkinan besar menjadi faktor utama perubahan kondisimu saat ini.',
                        style: AppTheme.font(size: 12, color: AppTheme.textPrimary, height: 1.35),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottom: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RecoveryScreen()),
        ),
        child: const Text('Lanjut: Berapa Lama & Apakah Pulih? →'),
      ),
    );
  }
}

class _FactorTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String levelText;
  final Color levelColor;
  final String levelBadge;
  final String desc;

  const _FactorTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.levelText,
    required this.levelColor,
    required this.levelBadge,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: AppTheme.shadowSoft,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.font(size: 13.5, weight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: levelColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        levelBadge,
                        style: AppTheme.font(size: 10.5, weight: FontWeight.w700, color: levelColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(levelText,
                    style: AppTheme.font(size: 11.5, weight: FontWeight.w600, color: levelColor)),
                const SizedBox(height: 2),
                Text(desc, style: AppTheme.font(size: 12, color: AppTheme.textSecondary, height: 1.25)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
