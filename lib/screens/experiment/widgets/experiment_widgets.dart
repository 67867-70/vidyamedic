import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

/// Reusable widgets for the 6-stage Vidyamedic Experiment Flow

/// Header bar with back button, Vidyamedic title, and Tahap X/6 pill badge
class ExperimentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int stageNumber;
  final int totalStages;
  final VoidCallback? onBackPressed;
  final VoidCallback? onStageSelect;

  const ExperimentAppBar({
    super.key,
    required this.stageNumber,
    this.totalStages = 6,
    this.onBackPressed,
    this.onStageSelect,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F2B3C), size: 24),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Vidyamedic',
        style: AppTheme.font(
          size: 19,
          weight: FontWeight.w800,
          color: const Color(0xFF0F2B3C),
          letterSpacing: -0.3,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: onStageSelect,
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFEBF4F6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFD3E7EB), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.show_chart_rounded,
                  size: 15,
                  color: Color(0xFF007A64),
                ),
                const SizedBox(width: 5),
                Text(
                  'Tahap $stageNumber/$totalStages',
                  style: AppTheme.font(
                    size: 11.5,
                    weight: FontWeight.w700,
                    color: const Color(0xFF0F3E4D),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  width: 6.5,
                  height: 6.5,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00897B),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Standard stage header title & description
class ExperimentPageHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const ExperimentPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.font(
              size: 23,
              weight: FontWeight.w900,
              color: const Color(0xFF0A2533),
              letterSpacing: -0.5,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: AppTheme.font(
              size: 13,
              weight: FontWeight.w500,
              color: const Color(0xFF5E7582),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

/// White card container with rounded corners and subtle border
class ExperimentCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? borderColor;
  final Color? backgroundColor;

  const ExperimentCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.only(bottom: 14),
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor ?? const Color(0xFFE2EBE9), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A064E3B),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// 4-Layer system progression horizontal stepper (L1 - L2 - L3 - L4)
class FourLayerStepper extends StatelessWidget {
  final int activeLayer; // 1 to 4
  final bool showDescriptions;
  final List<String> layerTitles;
  final List<String> layerDescriptions;
  final bool allCompleted;

  const FourLayerStepper({
    super.key,
    required this.activeLayer,
    this.showDescriptions = true,
    this.allCompleted = false,
    this.layerTitles = const [
      'L1\nInstrumentasi',
      'L2\nProfil',
      'L3\nPenalaran',
      'L4\nInteraksi',
    ],
    this.layerDescriptions = const [
      'Mengumpulkan sinyal sensor.',
      'Memproses profil Anda.',
      'Analisis dan deteksi konteks.',
      'Memberikan umpan balik.',
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(4, (index) {
        final stepNum = index + 1;
        final isCompleted = allCompleted || stepNum < activeLayer;
        final isActive = !allCompleted && stepNum == activeLayer;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: index == 0
                        ? const SizedBox()
                        : Container(
                            height: 2,
                            color: isCompleted || isActive
                                ? const Color(0xFF007A64)
                                : const Color(0xFFD6E2DF),
                          ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF007A64)
                          : isCompleted
                              ? const Color(0xFF0F3E4D)
                              : const Color(0xFFEDF2F0),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isActive || isCompleted
                            ? const Color(0xFF007A64)
                            : const Color(0xFFCBD8D4),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : Text(
                              '$stepNum',
                              style: AppTheme.font(
                                size: 12,
                                weight: FontWeight.w800,
                                color: isActive ? Colors.white : const Color(0xFF6B807B),
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    child: index == 3
                        ? const SizedBox()
                        : Container(
                            height: 2,
                            color: isCompleted
                                ? const Color(0xFF007A64)
                                : const Color(0xFFD6E2DF),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                layerTitles[index],
                textAlign: TextAlign.center,
                style: AppTheme.font(
                  size: 11,
                  weight: isActive || isCompleted ? FontWeight.w800 : FontWeight.w600,
                  color: isActive || isCompleted
                      ? const Color(0xFF0A2533)
                      : const Color(0xFF758A85),
                  height: 1.2,
                ),
              ),
              if (showDescriptions && index < layerDescriptions.length) ...[
                const SizedBox(height: 4),
                Text(
                  layerDescriptions[index],
                  textAlign: TextAlign.center,
                  style: AppTheme.font(
                    size: 9.5,
                    color: const Color(0xFF829692),
                    height: 1.25,
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}

/// Primary action button (Solid teal)
class ExperimentPrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool showChevron;

  const ExperimentPrimaryButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF007A64),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: Colors.white),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: AppTheme.font(
                    size: 13.5,
                    weight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            if (showChevron)
              const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

/// Secondary action button (Outline)
class ExperimentSecondaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool showChevron;
  final Color? borderColor;
  final Color? textColor;

  const ExperimentSecondaryButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.showChevron = true,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: textColor ?? const Color(0xFF0F3E4D),
          side: BorderSide(color: borderColor ?? const Color(0xFFCBD8D5), width: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: textColor ?? const Color(0xFF0F3E4D)),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: AppTheme.font(
                    size: 13.5,
                    weight: FontWeight.w700,
                    color: textColor ?? const Color(0xFF0F3E4D),
                  ),
                ),
              ],
            ),
            if (showChevron)
              Icon(Icons.chevron_right_rounded, size: 20, color: textColor ?? const Color(0xFF0F3E4D)),
          ],
        ),
      ),
    );
  }
}

/// Footer disclaimer text
class ExperimentFooterDisclaimer extends StatelessWidget {
  final String text;

  const ExperimentFooterDisclaimer({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTheme.font(
            size: 11,
            color: const Color(0xFF7A8F8A),
            height: 1.35,
          ).copyWith(fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}

/// Stage 3 Longitudinal Chart Custom Painter
class LongitudinalChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;

  LongitudinalChartPainter({
    required this.values,
    required this.labels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF00897B)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = const Color(0xFF007A64)
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = const Color(0xFFE2EBE8)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    final textStyle = AppTheme.font(size: 9.5, color: const Color(0xFF90A39E));

    // Y axis labels & grid lines: 100, 80, 60
    final yLevels = [100.0, 80.0, 60.0];
    const minY = 50.0;
    const maxY = 110.0;

    for (final level in yLevels) {
      final y = size.height - ((level - minY) / (maxY - minY)) * size.height;
      canvas.drawLine(Offset(28, y), Offset(size.width, y), gridPaint);

      final textSpan = TextSpan(text: '${level.toInt()}', style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(0, y - 6));
    }

    if (values.isEmpty) return;

    final points = <Offset>[];
    final chartWidth = size.width - 32;
    final stepX = chartWidth / (values.length - 1);

    for (int i = 0; i < values.length; i++) {
      final x = 32 + i * stepX;
      final y = size.height - ((values[i] - minY) / (maxY - minY)) * size.height;
      points.add(Offset(x, y));
    }

    // Gradient fill under the curve
    final path = Path();
    path.moveTo(points.first.dx, size.height);
    path.lineTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final cx = (p0.dx + p1.dx) / 2;
      path.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }
    path.lineTo(points.last.dx, size.height);
    path.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF00897B).withValues(alpha: 0.18),
          const Color(0xFF00897B).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    // Draw smooth curve line
    final curvePath = Path();
    curvePath.moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final cx = (p0.dx + p1.dx) / 2;
      curvePath.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }
    canvas.drawPath(curvePath, linePaint);

    // Draw dots
    for (final pt in points) {
      canvas.drawCircle(pt, 3.5, dotPaint);
      canvas.drawCircle(pt, 1.5, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant LongitudinalChartPainter oldDelegate) => true;
}

/// Stage 4 Deviation Chart Custom Painter
class DeviationChartPainter extends CustomPainter {
  final List<double> values;

  DeviationChartPainter({
    required this.values,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF00897B)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final gridPaint = Paint()
      ..color = const Color(0xFFE2EBE8)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    final textStyle = AppTheme.font(size: 9.5, color: const Color(0xFF90A39E));

    // Y axis labels & grid: 140, 100, 60
    final yLevels = [140.0, 100.0, 60.0];
    const minY = 50.0;
    const maxY = 150.0;

    for (final level in yLevels) {
      final y = size.height - ((level - minY) / (maxY - minY)) * size.height;
      canvas.drawLine(Offset(28, y), Offset(size.width, y), gridPaint);

      final textSpan = TextSpan(text: '${level.toInt()}', style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(0, y - 6));
    }

    if (values.isEmpty) return;

    final points = <Offset>[];
    final chartWidth = size.width - 32;
    final stepX = chartWidth / (values.length - 1);

    for (int i = 0; i < values.length; i++) {
      final x = 32 + i * stepX;
      final y = size.height - ((values[i] - minY) / (maxY - minY)) * size.height;
      points.add(Offset(x, y));
    }

    // Gradient fill under rising curve
    final path = Path();
    path.moveTo(points.first.dx, size.height);
    path.lineTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final cx = (p0.dx + p1.dx) / 2;
      path.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }
    path.lineTo(points.last.dx, size.height);
    path.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF00897B).withValues(alpha: 0.25),
          const Color(0xFF00897B).withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    // Draw curve
    final curvePath = Path();
    curvePath.moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final cx = (p0.dx + p1.dx) / 2;
      curvePath.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }
    canvas.drawPath(curvePath, linePaint);

    // Draw end highlighted dot at "Sekarang"
    final lastPt = points.last;
    canvas.drawCircle(lastPt, 5, Paint()..color = const Color(0xFF007A64));
    canvas.drawCircle(lastPt, 2, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant DeviationChartPainter oldDelegate) => true;
}
