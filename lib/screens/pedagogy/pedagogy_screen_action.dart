import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import '../input/guided_daily_flow_screen.dart';

/// Mockup Lanjutan Halaman 9: Layar 6 - Apa yang Harus Dilakukan? ("What Should I Do?")
class ActionGuidanceScreen extends StatelessWidget {
  const ActionGuidanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MockupScaffold(
      title: 'Apa yang Harus Dilakukan?',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Panduan Tindakan Sesuai Kondisi',
            style: AppTheme.font(size: 15, weight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            'Warna menunjukkan tingkat perhatian yang dibutuhkan.',
            style: AppTheme.font(size: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 14),

          // Hijau
          _ActionCard(
            color: const Color(0xFF10B981),
            title: 'Hijau',
            action: 'Lanjutkan aktivitas',
            desc: 'Kondisi stabil sesuai biasanya. Tetap jaga kebiasaan sehat.',
          ),

          // Kuning (Active current state)
          _ActionCard(
            color: const Color(0xFFF59E0B),
            title: 'Kuning',
            action: 'Observasi & catat',
            desc: 'Ada perubahan ringan. Pantau kondisi dan catat perkembangannya.',
            isCurrent: true,
          ),

          // Oranye
          _ActionCard(
            color: const Color(0xFFF97316),
            title: 'Oranye',
            action: 'Hubungi tenaga kesehatan',
            desc: 'Jika tidak membaik, ada gejala mengkhawatirkan, atau kamu merasa tidak nyaman.',
          ),

          // Merah
          _ActionCard(
            color: const Color(0xFFDC2626),
            title: 'Merah',
            action: 'Ke IGD / darurat',
            desc: 'Segera ke IGD jika ada tanda bahaya atau kondisi memburuk.',
          ),
          const SizedBox(height: 14),

          // Tanda Bahaya (Red Flags)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFCA5A5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning_rounded, color: Color(0xFFDC2626), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tanda Bahaya',
                        style: AppTheme.font(size: 13.5, weight: FontWeight.w800, color: const Color(0xFF991B1B)),
                      ),
                    ),
                    Text('Lihat Semua',
                        style: AppTheme.font(size: 11.5, weight: FontWeight.w700, color: const Color(0xFFDC2626))),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Segera cari pertolongan medis jika mengalami:',
                    style: AppTheme.font(size: 11.5, color: const Color(0xFF7F1D1D))),
                const SizedBox(height: 12),

                // 4 Red Flag Icons
                Row(
                  children: [
                    Expanded(child: _RedFlagIcon(Icons.heart_broken_outlined, 'Nyeri dada\nberat')),
                    Expanded(child: _RedFlagIcon(Icons.air_outlined, 'Sesak\nnapas')),
                    Expanded(child: _RedFlagIcon(Icons.sick_outlined, 'Pusing berat\n/ pingsan')),
                    Expanded(child: _RedFlagIcon(Icons.speed_outlined, 'Detak jantung\n(>120 bpm)')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Action Button: + Catatan Harian Kesehatan
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GuidedDailyFlowScreen(initialStep: 5)),
            ),
            icon: const Icon(Icons.edit_note, color: AppTheme.primary),
            label: Text(
              '+ Catatan Harian Kesehatan',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.font(size: 13.5, weight: FontWeight.w700, color: AppTheme.primary),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.primaryLight, width: 1.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          const SizedBox(height: 8),

          // Action Button: Bagikan ke Keluarga / Dokter
          ElevatedButton.icon(
            onPressed: () => _showShareDialog(context),
            icon: const Icon(Icons.share_outlined, size: 18),
            label: Text(
              'Bagikan ke Keluarga / Nakes',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.font(size: 14, weight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showShareDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bagikan Laporan Kesehatan', style: AppTheme.font(size: 16, weight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                'Ringkasan data observasi personal dan tren 7 hari siap diekspor dalam format PDF / ringkasan tautan aman.',
                style: AppTheme.font(size: 12.5, color: AppTheme.textSecondary, height: 1.35),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_outlined, color: AppTheme.primary),
                title: Text('Unduh Laporan PDF', style: AppTheme.font(size: 13.5, weight: FontWeight.w600)),
                subtitle: Text('Laporan ringkas untuk dokter spesialis / faskes', style: AppTheme.font(size: 11.5)),
                onTap: () {
                  Navigator.pop(ctx);
                  showSaved(context, 'Laporan PDF VidyaMedic berhasil dibuat');
                },
              ),
              ListTile(
                leading: const Icon(Icons.groups_outlined, color: Color(0xFF0EA5E9)),
                title: Text('Kirim ke Keluarga / Caregiver', style: AppTheme.font(size: 13.5, weight: FontWeight.w600)),
                subtitle: Text('Notifikasi pemantauan recovery aman', style: AppTheme.font(size: 11.5)),
                onTap: () {
                  Navigator.pop(ctx);
                  showSaved(context, 'Ringkasan terkirim ke caregiver');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final Color color;
  final String title;
  final String action;
  final String desc;
  final bool isCurrent;

  const _ActionCard({
    required this.color,
    required this.title,
    required this.action,
    required this.desc,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrent ? color.withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrent ? color : AppTheme.borderLight,
          width: isCurrent ? 1.6 : 1,
        ),
        boxShadow: AppTheme.shadowSoft,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: AppTheme.font(size: 13.5, weight: FontWeight.w800, color: color)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text('— $action',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.font(size: 13, weight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(desc, style: AppTheme.font(size: 11.5, color: AppTheme.textSecondary, height: 1.25)),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
              child: Text('Aktif', style: AppTheme.font(size: 9.5, weight: FontWeight.w800, color: Colors.white)),
            ),
        ],
      ),
    );
  }
}

class _RedFlagIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _RedFlagIcon(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Icon(icon, size: 20, color: Color(0xFFDC2626)),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTheme.font(size: 10, weight: FontWeight.w600, color: const Color(0xFF7F1D1D), height: 1.15),
        ),
      ],
    );
  }
}
