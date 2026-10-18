import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'questionnaire_widgets.dart';
import 'sus_questionnaire_screen.dart';

/// Screen Kuesioner NASA-TLX (Task Load Index)
/// Berdasarkan gambar kanan pada permintaan pengguna
class NasaTlxQuestionnaireScreen extends StatefulWidget {
  final VoidCallback? onFinished;

  const NasaTlxQuestionnaireScreen({
    super.key,
    this.onFinished,
  });

  @override
  State<NasaTlxQuestionnaireScreen> createState() => _NasaTlxQuestionnaireScreenState();
}

class _NasaTlxQuestionnaireScreenState extends State<NasaTlxQuestionnaireScreen> {
  int _currentStep = 2; // Default to step 2 (Kuesioner NASA-TLX) matching image

  // Initial slider values matching the mockup screenshot
  double _mentalDemand = 45;
  double _physicalDemand = 10;
  double _temporalDemand = 30;
  double _performance = 25;
  double _effort = 40;
  double _frustration = 20;

  double get _averageScore {
    return (_mentalDemand + _physicalDemand + _temporalDemand + _performance + _effort + _frustration) / 6.0;
  }

  String get _workloadLevel {
    final avg = _averageScore;
    if (avg < 30) return 'Sangat Rendah (Beban Sangat Ringan)';
    if (avg < 50) return 'Rendah (Nyaman & Terkendali)';
    if (avg < 70) return 'Sedang (Cukup Terasa)';
    return 'Tinggi (Beban Berlebih)';
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      if (widget.onFinished != null) {
        widget.onFinished!();
      } else {
        Navigator.pop(context);
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            QuestionnaireHeader(currentStep: _currentStep),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 860),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isMobile = constraints.maxWidth < 620;

                        if (isMobile) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              QuestionnaireStepperHorizontal(
                                activeStep: _currentStep,
                                questionnaireTitle: 'Kuesioner NASA-TLX',
                                onStepTapped: (step) =>
                                    setState(() => _currentStep = step),
                              ),
                              _buildCurrentStepContent(),
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Stepper
                            SizedBox(
                              width: 140,
                              child: QuestionnaireStepper(
                                activeStep: _currentStep,
                                questionnaireTitle: 'Kuesioner\nNASA-TLX',
                                onStepTapped: (step) =>
                                    setState(() => _currentStep = step),
                              ),
                            ),
                            const SizedBox(width: 20),

                            // Main Content
                            Expanded(
                              child: _buildCurrentStepContent(),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            QuestionnaireBottomBar(
              onBack: _prevStep,
              onNext: _nextStep,
              nextLabel: _currentStep == 3 ? 'Selesai' : 'Lanjut',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    if (_currentStep == 1) {
      return _buildPendahuluanContent();
    } else if (_currentStep == 2) {
      return _buildNasaTlxQuestionsContent();
    } else {
      return _buildSelesaiContent();
    }
  }

  Widget _buildPendahuluanContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pendahuluan Kuesioner NASA-TLX',
          style: AppTheme.font(
            size: 20,
            weight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Pengukuran beban kerja subjektif multidimensi saat menggunakan Vidyamedic.',
          style: AppTheme.font(
            size: 13,
            color: const Color(0xFF64748B),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        const QuestionnaireInfoBanner(
          text:
              'NASA Task Load Index (NASA-TLX) menilai 6 dimensi beban kerja untuk memastikan interaksi sistem tidak membebani kapasitas kognitif maupun emosional Anda.',
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '6 Dimensi yang Dinilai:',
                style: AppTheme.font(size: 14, weight: FontWeight.w700, color: const Color(0xFF0F172A)),
              ),
              const SizedBox(height: 10),
              _buildBullet('Beban Mental: Aktivitas berpikir, mengingat, dan memutuskan.'),
              _buildBullet('Beban Fisik: Aktivitas fisik yang dituntut oleh sistem.'),
              _buildBullet('Tekanan Waktu: Perasaan terburu-buru atau tertekan waktu.'),
              _buildBullet('Kinerja: Kepuasan terhadap keberhasilan menyelesaikan tugas.'),
              _buildBullet('Usaha: Tingkat kerja keras mental & fisik yang Anda kerahkan.'),
              _buildBullet('Frustrasi: Perasaan tertekan, kesal, atau lelah emosional.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNasaTlxQuestionsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kuesioner NASA-TLX',
          style: AppTheme.font(
            size: 21,
            weight: FontWeight.w900,
            color: const Color(0xFF0F172A),
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Mohon berikan penilaian Anda terhadap beban kerja saat menggunakan Vidyamedic untuk menyelesaikan tugas pada sesi ini.',
          style: AppTheme.font(
            size: 13,
            color: const Color(0xFF64748B),
            height: 1.35,
          ),
        ),
        const SizedBox(height: 14),

        // Info Banner
        const QuestionnaireInfoBanner(
          text:
              'Berikan nilai untuk setiap dimensi dengan menggeser slider. Skala penilaian: 0 = sangat rendah, 100 = sangat tinggi.',
        ),
        const SizedBox(height: 16),

        // 1. Beban Mental
        _buildDimensionSliderCard(
          icon: Icons.psychology_outlined,
          title: 'Beban Mental (Mental Demand)',
          subtitle: 'Seberapa besar usaha berpikir dan memahami informasi yang Anda rasakan?',
          value: _mentalDemand,
          onChanged: (val) => setState(() => _mentalDemand = val),
        ),

        // 2. Beban Fisik
        _buildDimensionSliderCard(
          icon: Icons.directions_run_rounded,
          title: 'Beban Fisik (Physical Demand)',
          subtitle: 'Seberapa besar aktivitas fisik yang diperlukan untuk menggunakan Vidyamedic?',
          value: _physicalDemand,
          onChanged: (val) => setState(() => _physicalDemand = val),
        ),

        // 3. Tekanan Waktu
        _buildDimensionSliderCard(
          icon: Icons.access_time_rounded,
          title: 'Tekanan Waktu (Temporal Demand)',
          subtitle: 'Seberapa besar tekanan waktu yang Anda rasakan saat menyelesaikan tugas?',
          value: _temporalDemand,
          onChanged: (val) => setState(() => _temporalDemand = val),
        ),

        // 4. Kinerja (with caution box)
        _buildDimensionSliderCard(
          icon: Icons.bar_chart_rounded,
          title: 'Kinerja (Performance)',
          subtitle: 'Seberapa berhasil Anda merasa dalam menyelesaikan tugas dengan Vidyamedic?',
          value: _performance,
          onChanged: (val) => setState(() => _performance = val),
          warningNote:
              'Pada dimensi ini, nilai lebih tinggi menunjukkan kinerja yang lebih buruk (misal: merasa tidak berhasil).',
        ),

        // 5. Usaha
        _buildDimensionSliderCard(
          icon: Icons.settings_outlined,
          title: 'Usaha (Effort)',
          subtitle: 'Seberapa besar usaha mental dan fisik yang Anda keluarkan?',
          value: _effort,
          onChanged: (val) => setState(() => _effort = val),
        ),

        // 6. Frustrasi
        _buildDimensionSliderCard(
          icon: Icons.sentiment_dissatisfied_outlined,
          title: 'Frustrasi (Frustration)',
          subtitle: 'Seberapa besar perasaan kesal, tidak nyaman, atau tertekan yang Anda rasakan?',
          value: _frustration,
          onChanged: (val) => setState(() => _frustration = val),
        ),
      ],
    );
  }

  Widget _buildDimensionSliderCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required double value,
    required ValueChanged<double> onChanged,
    String? warningNote,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF2563EB), size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.font(
                        size: 13,
                        weight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTheme.font(
                        size: 11,
                        color: const Color(0xFF64748B),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 44,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Center(
                  child: Text(
                    '${value.round()}',
                    style: AppTheme.font(
                      size: 12.5,
                      weight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Slider & Labels
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF2563EB),
              inactiveTrackColor: const Color(0xFFE2E8F0),
              thumbColor: const Color(0xFF2563EB),
              overlayColor: const Color(0xFF2563EB).withValues(alpha: 0.12),
              trackHeight: 5,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 100,
              divisions: 20,
              onChanged: onChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sangat rendah',
                  style: AppTheme.font(size: 9.5, color: const Color(0xFF94A3B8)),
                ),
                Text(
                  'Sangat tinggi',
                  style: AppTheme.font(size: 9.5, color: const Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),

          if (warningNote != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, color: Color(0xFFD97706), size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      warningNote,
                      style: AppTheme.font(
                        size: 11,
                        color: const Color(0xFF92400E),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSelesaiContent() {
    final avg = _averageScore;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hasil NASA-TLX',
          style: AppTheme.font(
            size: 21,
            weight: FontWeight.w900,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Ringkasan beban kerja tugas (Task Load Index) Anda.',
          style: AppTheme.font(size: 13, color: const Color(0xFF64748B)),
        ),
        const SizedBox(height: 16),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1F2563EB),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Indeks Beban Kerja Rata-rata',
                style: AppTheme.font(
                  size: 13,
                  weight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    avg.toStringAsFixed(1),
                    style: AppTheme.font(
                      size: 44,
                      weight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '/ 100',
                    style: AppTheme.font(
                      size: 16,
                      weight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _workloadLevel,
                  style: AppTheme.font(
                    size: 12,
                    weight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Breakdown bars
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rincian per Dimensi:',
                style: AppTheme.font(size: 13.5, weight: FontWeight.w700, color: const Color(0xFF0F172A)),
              ),
              const SizedBox(height: 12),
              _buildBreakdownRow('Mental Demand', _mentalDemand),
              _buildBreakdownRow('Physical Demand', _physicalDemand),
              _buildBreakdownRow('Temporal Demand', _temporalDemand),
              _buildBreakdownRow('Performance (Kegagalan)', _performance),
              _buildBreakdownRow('Effort', _effort),
              _buildBreakdownRow('Frustration', _frustration),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SusQuestionnaireScreen()),
              );
            },
            icon: const Icon(Icons.checklist_rounded, size: 18),
            label: Text(
              'Lanjut ke Kuesioner SUS →',
              style: AppTheme.font(size: 13, weight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownRow(String label, double val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: AppTheme.font(size: 11.5, color: const Color(0xFF475569)),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: val / 100.0,
                minHeight: 8,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF2563EB)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 28,
            child: Text(
              '${val.round()}',
              textAlign: TextAlign.end,
              style: AppTheme.font(size: 11.5, weight: FontWeight.w800, color: const Color(0xFF0F172A)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14, color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: AppTheme.font(size: 12.5, color: const Color(0xFF475569), height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
