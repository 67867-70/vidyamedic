import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import 'pedagogy_screen_why.dart';

/// Mockup Lanjutan Halaman 6: Layar 3 - Apa yang Berubah? ("What Changed?")
class WhatChangedScreen extends StatefulWidget {
  const WhatChangedScreen({super.key});

  @override
  State<WhatChangedScreen> createState() => _WhatChangedScreenState();
}

class _WhatChangedScreenState extends State<WhatChangedScreen> {
  int _tabIndex = 0; // 0: Hari Ini, 1: 7 Hari, 2: 30 Hari

  @override
  Widget build(BuildContext context) {
    return MockupScaffold(
      title: 'Apa yang Berubah?',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Tabs (Hari Ini / 7 Hari / 30 Hari)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.fieldFill,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: ['Hari Ini', '7 Hari', '30 Hari']
                  .asMap()
                  .entries
                  .map((e) => Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _tabIndex = e.key),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _tabIndex == e.key ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: _tabIndex == e.key ? AppTheme.shadowSoft : null,
                            ),
                            child: Text(
                              e.value,
                              style: AppTheme.font(
                                size: 12.5,
                                weight: _tabIndex == e.key ? FontWeight.w700 : FontWeight.w500,
                                color: _tabIndex == e.key ? AppTheme.primaryDark : AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Main Trend Chart Card (Detak Jantung sepanjang hari vs Baseline)
          Container(
            padding: const EdgeInsets.all(16),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.favorite, size: 18, color: AppTheme.faceRed),
                        const SizedBox(width: 8),
                        Text('Detak Jantung (bpm)',
                            style: AppTheme.font(size: 13.5, weight: FontWeight.w700)),
                      ],
                    ),
                    Row(
                      children: [
                        Text('92', style: AppTheme.font(size: 18, weight: FontWeight.w800, color: AppTheme.faceRed)),
                        const SizedBox(width: 4),
                        Text('↑ +18',
                            style: AppTheme.font(size: 12, weight: FontWeight.w700, color: AppTheme.faceRed)),
                      ],
                    ),
                  ],
                ),
                Text('dari rata-rata biasanya (74 bpm)',
                    style: AppTheme.font(size: 11.5, color: AppTheme.textMuted)),
                const SizedBox(height: 14),

                // Custom Painter Chart for 24h trend
                const SizedBox(
                  height: 110,
                  width: double.infinity,
                  child: _TrendPainterWidget(),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['00:00', '06:00', '12:00', '18:00', '24:00']
                      .map((t) => Text(t, style: AppTheme.font(size: 10, color: AppTheme.textMuted)))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 3 Summary Cards: Tidur, Aktivitas, HRV
          Row(
            children: [
              Expanded(
                child: _ChangeBox(
                  icon: Icons.bedtime,
                  color: const Color(0xFF6366F1),
                  label: 'Durasi Tidur',
                  value: '5,2 jam',
                  change: '↓ -2,1 jam',
                  sub: 'dari biasanya (7,3 jam)',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ChangeBox(
                  icon: Icons.directions_walk,
                  color: const Color(0xFF0EA5E9),
                  label: 'Aktivitas Harian',
                  value: '1.200',
                  change: '↓ -80%',
                  sub: 'dari biasanya (6.000)',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ChangeBox(
                  icon: Icons.monitor_heart_outlined,
                  color: const Color(0xFF10B981),
                  label: 'HRV (RMSSD)',
                  value: '28 ms',
                  change: '↓ -35%',
                  sub: 'dari biasanya (43 ms)',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Checklist of changes
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
                Text('Apa yang berubah dari biasanya?',
                    style: AppTheme.font(size: 13.5, weight: FontWeight.w700, color: AppTheme.primaryDark)),
                const SizedBox(height: 10),
                _bulletRow(Icons.arrow_upward_rounded, const Color(0xFFDC2626), 'Detak jantung lebih tinggi (+18 bpm)'),
                _bulletRow(Icons.arrow_downward_rounded, const Color(0xFFF59E0B), 'Tidur lebih singkat (-2,1 jam)'),
                _bulletRow(Icons.arrow_downward_rounded, const Color(0xFFF59E0B), 'Aktivitas lebih rendah (-80%)'),
                _bulletRow(Icons.arrow_downward_rounded, const Color(0xFFDC2626), 'Variabilitas detak jantung lebih rendah (-35%)'),
              ],
            ),
          ),
        ],
      ),
      bottom: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WhyScreen()),
        ),
        child: const Text('Lanjut: Mengapa Terjadi Perubahan? →'),
      ),
    );
  }

  Widget _bulletRow(IconData icon, Color color, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(icon, size: 12, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: AppTheme.font(size: 12.5, color: AppTheme.textPrimary, weight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

class _ChangeBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final String change;
  final String sub;

  const _ChangeBox({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.change,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: AppTheme.shadowSoft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: color),
          const SizedBox(height: 5),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.font(size: 10, color: AppTheme.textMuted)),
          const SizedBox(height: 2),
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.font(size: 13.5, weight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(change,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.font(size: 10, weight: FontWeight.w700, color: const Color(0xFFDC2626))),
        ],
      ),
    );
  }
}

class _TrendPainterWidget extends StatelessWidget {
  const _TrendPainterWidget();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TrendPainter(),
    );
  }
}

class _TrendPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Baseline band (70 - 78 bpm)
    final baselineY = size.height * 0.65;
    final baselineBand = Rect.fromLTRB(0, baselineY - 8, size.width, baselineY + 8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(baselineBand, const Radius.circular(4)),
      Paint()..color = const Color(0xFF10B981).withValues(alpha: 0.09),
    );

    // Baseline line (dashed)
    final dashedPaint = Paint()
      ..color = const Color(0xFF10B981).withValues(alpha: 0.6)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, baselineY), Offset(startX + 5, baselineY), dashedPaint);
      startX += 9;
    }

    // Baseline text pill
    final textSpan = TextSpan(
      text: ' Rata-rata normal: 74 bpm ',
      style: AppTheme.font(size: 9, weight: FontWeight.w700, color: const Color(0xFF047857)),
    );
    final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr)..layout();
    final textBg = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width - textPainter.width / 2 - 8, baselineY + 14),
        width: textPainter.width + 8,
        height: textPainter.height + 4,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(textBg, Paint()..color = const Color(0xFFE8F5EF));
    textPainter.paint(canvas, Offset(size.width - textPainter.width - 12, baselineY + 14 - textPainter.height / 2));

    // Actual HR wave (elevation around afternoon / evening)
    final wavePath = Path();
    wavePath.moveTo(0, baselineY);
    wavePath.quadraticBezierTo(size.width * 0.2, baselineY - 4, size.width * 0.35, baselineY + 4);
    wavePath.quadraticBezierTo(size.width * 0.5, baselineY - 30, size.width * 0.65, baselineY - 48); // peak
    wavePath.quadraticBezierTo(size.width * 0.8, baselineY - 35, size.width * 0.9, baselineY - 18);
    wavePath.lineTo(size.width, baselineY - 12);

    // Gradient fill under the actual wave
    final fillPath = Path.from(wavePath)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFFDC2626).withValues(alpha: 0.2),
        const Color(0xFF10B981).withValues(alpha: 0.0),
      ],
    );
    canvas.drawPath(
      fillPath,
      Paint()..shader = fillGradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    final linePaint = Paint()
      ..color = const Color(0xFFDC2626)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(wavePath, linePaint);

    // Peak dot with double halo
    final peakX = size.width * 0.65;
    final peakY = baselineY - 48;
    canvas.drawCircle(Offset(peakX, peakY), 8, Paint()..color = const Color(0xFFDC2626).withValues(alpha: 0.2));
    canvas.drawCircle(Offset(peakX, peakY), 4.5, Paint()..color = const Color(0xFFDC2626));
    canvas.drawCircle(Offset(peakX, peakY), 2, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
