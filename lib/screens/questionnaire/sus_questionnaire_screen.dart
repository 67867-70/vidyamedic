import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'questionnaire_widgets.dart';
import 'nasa_tlx_questionnaire_screen.dart';

/// Screen Kuesioner System Usability Scale (SUS)
/// Berdasarkan gambar kiri pada permintaan pengguna
class SusQuestionnaireScreen extends StatefulWidget {
  final VoidCallback? onFinished;

  const SusQuestionnaireScreen({
    super.key,
    this.onFinished,
  });

  @override
  State<SusQuestionnaireScreen> createState() => _SusQuestionnaireScreenState();
}

class _SusQuestionnaireScreenState extends State<SusQuestionnaireScreen> {
  int _currentStep = 2; // Default to step 2 (Kuesioner SUS) matching image

  // 10 SUS Questions
  final List<String> _questions = [
    'Saya berpikir akan sering menggunakan Vidyamedic.',
    'Saya merasa Vidyamedic rumit untuk digunakan.',
    'Saya merasa Vidyamedic mudah digunakan.',
    'Saya pikir saya memerlukan bantuan dari orang lain untuk dapat menggunakan Vidyamedic.',
    'Saya merasa berbagai fungsi dalam Vidyamedic terintegrasi dengan baik.',
    'Saya merasa terdapat terlalu banyak ketidakkonsistenan dalam Vidyamedic.',
    'Saya merasa kebanyakan orang akan cepat mempelajari cara menggunakan Vidyamedic.',
    'Saya merasa Vidyamedic membingungkan.',
    'Saya merasa tidak ada hambatan dalam menggunakan Vidyamedic.',
    'Saya perlu membiasakan diri terlebih dahulu sebelum dapat menggunakan Vidyamedic.',
  ];

  // Ratings for questions (1 to 5). Initial sample ratings
  late Map<int, int> _ratings;

  @override
  void initState() {
    super.initState();
    _ratings = {
      0: 4,
      1: 2,
      2: 4,
      3: 2,
      4: 5,
      5: 2,
      6: 4,
      7: 1,
      8: 4,
      9: 2,
    };
  }

  double get _calculatedSusScore {
    double total = 0;
    for (int i = 0; i < 10; i++) {
      final score = _ratings[i] ?? 3;
      if (i % 2 == 0) {
        // Odd items (1, 3, 5, 7, 9 in 1-based index) -> score - 1
        total += (score - 1);
      } else {
        // Even items (2, 4, 6, 8, 10 in 1-based index) -> 5 - score
        total += (5 - score);
      }
    }
    return (total * 2.5).clamp(0, 100);
  }

  String get _susGrade {
    final s = _calculatedSusScore;
    if (s >= 80.3) return 'A (Sangat Baik / Unggul)';
    if (s >= 68) return 'B (Baik / Di Atas Rata-rata)';
    if (s >= 51) return 'C (Cukup / Marginal)';
    return 'D (Perlu Peningkatan)';
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
                                questionnaireTitle: 'Kuesioner SUS',
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
                                questionnaireTitle: 'Kuesioner SUS',
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
      return _buildSusQuestionsContent();
    } else {
      return _buildSelesaiContent();
    }
  }

  Widget _buildPendahuluanContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pendahuluan Kuesioner SUS',
          style: AppTheme.font(
            size: 20,
            weight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Evaluasi kebergunaan sistem Vidyamedic menggunakan metode standar System Usability Scale (SUS).',
          style: AppTheme.font(
            size: 13,
            color: const Color(0xFF64748B),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        const QuestionnaireInfoBanner(
          text:
              'Kuesioner ini dirancang untuk mengukur tingkat kemudahan penggunaan dan kepuasan antarmuka Vidyamedic setelah Anda menyelesaikan sesi pemantauan.',
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
                'Petunjuk Pengisian:',
                style: AppTheme.font(size: 14, weight: FontWeight.w700, color: const Color(0xFF0F172A)),
              ),
              const SizedBox(height: 10),
              _buildBullet('Terdapat 10 butir pertanyaan skala Likert 1–5.'),
              _buildBullet('1 = Sangat Tidak Setuju, 5 = Sangat Setuju.'),
              _buildBullet('Jawab secara spontan berdasarkan pengalaman nyata Anda.'),
              _buildBullet('Tidak ada jawaban benar atau salah; masukan Anda sangat berharga.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSusQuestionsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kuesioner SUS',
          style: AppTheme.font(
            size: 21,
            weight: FontWeight.w900,
            color: const Color(0xFF0F172A),
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Mohon berikan penilaian Anda terhadap penggunaan Vidyamedic.',
          style: AppTheme.font(
            size: 13,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 14),

        // Info Banner
        const QuestionnaireInfoBanner(
          text:
              'Terdapat 10 pernyataan. Pilih jawaban yang paling sesuai dengan pengalaman Anda. Skala penilaian: 1 = Sangat tidak setuju, 5 = Sangat setuju.',
        ),
        const SizedBox(height: 16),

        // 10 Question Cards
        ...List.generate(_questions.length, (index) {
          return _buildSusQuestionCard(
            number: index + 1,
            statement: _questions[index],
            currentRating: _ratings[index] ?? 3,
            onChanged: (val) {
              setState(() {
                _ratings[index] = val;
              });
            },
          );
        }),
      ],
    );
  }

  Widget _buildSusQuestionCard({
    required int number,
    required String statement,
    required int currentRating,
    required ValueChanged<int> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: AppTheme.font(
                      size: 11.5,
                      weight: FontWeight.w800,
                      color: const Color(0xFF334155),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  statement,
                  style: AppTheme.font(
                    size: 12.5,
                    weight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Likert scale 1 to 5 radio buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (optIdx) {
              final val = optIdx + 1;
              final isSelected = currentRating == val;
              final isMin = val == 1;
              final isMax = val == 5;

              return InkWell(
                onTap: () => onChanged(val),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Column(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1),
                            width: isSelected ? 2 : 1.2,
                          ),
                          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
                        ),
                        child: isSelected
                            ? Center(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2563EB),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '$val',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                        ),
                      ),
                      if (isMin) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Sangat tidak setuju',
                          style: AppTheme.font(size: 8.5, color: const Color(0xFF94A3B8)),
                        ),
                      ] else if (isMax) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Sangat setuju',
                          style: AppTheme.font(size: 8.5, color: const Color(0xFF94A3B8)),
                        ),
                      ] else ...[
                        const SizedBox(height: 14),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSelesaiContent() {
    final score = _calculatedSusScore;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hasil Kuesioner SUS',
          style: AppTheme.font(
            size: 21,
            weight: FontWeight.w900,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Terima kasih telah melengkapi penilaian kebergunaan Vidyamedic.',
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
                'Skor SUS Vidyamedic',
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
                    score.toStringAsFixed(1),
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
                  'Kategori: $_susGrade',
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
                'Interpretasi Nilai SUS:',
                style: AppTheme.font(size: 13.5, weight: FontWeight.w700, color: const Color(0xFF0F172A)),
              ),
              const SizedBox(height: 8),
              Text(
                'Rata-rata skor SUS industri berkisar di angka 68. Skor Anda berada pada tingkat $_susGrade, yang mengindikasikan aplikasi ini mudah dipahami dan siap digunakan oleh pengguna mandiri.',
                style: AppTheme.font(size: 12, color: const Color(0xFF475569), height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D4ED8),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const NasaTlxQuestionnaireScreen()),
              );
            },
            icon: const Icon(Icons.speed_rounded, size: 18),
            label: Text(
              'Lanjut ke Kuesioner NASA-TLX →',
              style: AppTheme.font(size: 13, weight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ),
      ],
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
