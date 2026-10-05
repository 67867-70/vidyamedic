import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import 'pedagogy_screen_action.dart';

/// Mockup Lanjutan Halaman 8: Layar 5 - Berapa Lama & Apakah Pulih? ("How Long & Am I Recovering?")
class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key});

  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  int _tabIndex = 0; // 0: Hari Ini, 1: 7 Hari, 2: 30 Hari

  @override
  Widget build(BuildContext context) {
    return MockupScaffold(
      title: 'Berapa Lama & Apakah Pulih?',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Tabs
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

          // Perkembangan Kondisi Graph Card
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
                    Text('Perkembangan Kondisi',
                        style: AppTheme.font(size: 13.5, weight: FontWeight.w700)),
                    Row(
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFDC2626), shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        Text('Episode', style: AppTheme.font(size: 10.5, color: AppTheme.textMuted)),
                        const SizedBox(width: 8),
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        Text('Normal', style: AppTheme.font(size: 10.5, color: AppTheme.textMuted)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: _RecoveryPainterWidget(),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['07:30', '08:00', '08:30', '09:00', '09:30', '10:00']
                      .map((t) => Text(t, style: AppTheme.font(size: 10, color: AppTheme.textMuted)))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 2 Badges: Durasi Perubahan (22 menit) & Pola Perubahan (Sementara)
          Row(
            children: [
              Expanded(
                child: Container(
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
                          const Icon(Icons.timer_outlined, size: 15, color: Color(0xFFF59E0B)),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text('Durasi Perubahan',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTheme.font(size: 10.5, color: AppTheme.textMuted)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('22 menit', style: AppTheme.font(size: 14.5, weight: FontWeight.w800)),
                      Text('08:15 - 08:37',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.font(size: 10, color: AppTheme.textMuted)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
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
                          const Icon(Icons.polyline_outlined, size: 15, color: Color(0xFF10B981)),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text('Pola Perubahan',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTheme.font(size: 10.5, color: AppTheme.textMuted)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Sementara',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.font(size: 14.5, weight: FontWeight.w800, color: AppTheme.primaryDark)),
                      Text('Mendekati normal',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.font(size: 10, color: AppTheme.textMuted)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Tanda-tanda Pemulihan Card with Gauge & Milestones
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
                Text('Tanda-tanda Pemulihan',
                    style: AppTheme.font(size: 13.5, weight: FontWeight.w700, color: AppTheme.primaryDark)),
                const SizedBox(height: 12),

                // Gauge row
                Row(
                  children: [
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: 0.68,
                            strokeWidth: 5.5,
                            backgroundColor: const Color(0xFFE2EBE7),
                            valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
                          ),
                          Text('68%', style: AppTheme.font(size: 13, weight: FontWeight.w800, color: AppTheme.primaryDark)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pemulihan 68%', style: AppTheme.font(size: 13, weight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text('Kondisi berangsur membaik dan mendekati normal',
                              style: AppTheme.font(size: 11, color: AppTheme.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Milestone steps (Responsive)
                Row(
                  children: [
                    _milestoneNode('Mulai', '08:15', isPassed: true),
                    _milestoneLine(isPassed: true),
                    _milestoneNode('Puncak', '08:22', isPassed: true),
                    _milestoneLine(isPassed: true),
                    _milestoneNode('Turun', '08:37', isPassed: true),
                    _milestoneLine(isPassed: false),
                    _milestoneNode('Pulih', '09:05', isPassed: false),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Tren menunjukkan kondisi mulai membaik. Tetap pantau hingga kembali normal sepenuhnya.',
                  style: AppTheme.font(size: 11.5, color: AppTheme.textSecondary, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
      bottom: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ActionGuidanceScreen()),
        ),
        child: const Text('Lanjut: Apa yang Harus Dilakukan? →'),
      ),
    );
  }

  Widget _milestoneNode(String title, String time, {required bool isPassed}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: isPassed ? AppTheme.primary : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.primary, width: 2),
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: AppTheme.font(size: 10, weight: FontWeight.w700)),
        Text(time, style: AppTheme.font(size: 9, color: AppTheme.textMuted)),
      ],
    );
  }

  Widget _milestoneLine({required bool isPassed}) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 22),
        color: isPassed ? AppTheme.primary : const Color(0xFFE2EBE7),
      ),
    );
  }
}

class _RecoveryPainterWidget extends StatelessWidget {
  const _RecoveryPainterWidget();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RecoveryPainter(),
    );
  }
}

class _RecoveryPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final baselineY = size.height * 0.72;

    // Normal zone green band background
    final normalBandRect = Rect.fromLTWH(0, baselineY - 4, size.width, 16);
    canvas.drawRRect(
      RRect.fromRectAndRadius(normalBandRect, const Radius.circular(4)),
      Paint()..color = const Color(0xFF10B981).withValues(alpha: 0.08),
    );

    // Baseline horizontal line
    final baselinePaint = Paint()
      ..color = const Color(0xFF10B981)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    
    // Draw dashed line for baseline
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, baselineY), Offset(startX + 6, baselineY), baselinePaint);
      startX += 10;
    }

    // Episode rise, peak, and recovery slope
    final path = Path();
    path.moveTo(0, baselineY);
    path.lineTo(size.width * 0.25, baselineY); // start rise at 08:15
    path.quadraticBezierTo(size.width * 0.35, baselineY - 52, size.width * 0.42, baselineY - 50); // peak 104 bpm at 08:22
    path.quadraticBezierTo(size.width * 0.55, baselineY - 32, size.width * 0.65, baselineY - 8); // decline 08:37
    path.quadraticBezierTo(size.width * 0.8, baselineY, size.width, baselineY); // recovered 09:05

    // Gradient fill under deviation curve
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFFEF4444).withValues(alpha: 0.25),
        const Color(0xFF10B981).withValues(alpha: 0.0),
      ],
    );

    canvas.drawPath(
      fillPath,
      Paint()..shader = fillGradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Stroke line
    final linePaint = Paint()
      ..color = const Color(0xFFDC2626)
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, linePaint);

    // Peak badge
    final peakX = size.width * 0.42;
    final peakY = baselineY - 50;

    // Halo around peak
    canvas.drawCircle(Offset(peakX, peakY), 8, Paint()..color = const Color(0xFFDC2626).withValues(alpha: 0.2));
    canvas.drawCircle(Offset(peakX, peakY), 4.5, Paint()..color = const Color(0xFFDC2626));
    canvas.drawCircle(Offset(peakX, peakY), 2, Paint()..color = Colors.white);

    // Peak Pill Label
    final textSpan = TextSpan(
      text: ' 104 bpm (08:22) ',
      style: AppTheme.font(size: 9.5, weight: FontWeight.w700, color: Colors.white),
    );
    final textP = TextPainter(text: textSpan, textDirection: TextDirection.ltr)..layout();
    
    final labelBg = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(peakX, peakY - 14), width: textP.width + 10, height: textP.height + 6),
      const Radius.circular(6),
    );
    canvas.drawRRect(labelBg, Paint()..color = const Color(0xFFDC2626));
    textP.paint(canvas, Offset(peakX - textP.width / 2, peakY - 14 - textP.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
