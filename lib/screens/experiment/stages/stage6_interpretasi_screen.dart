import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../questionnaire/sus_questionnaire_screen.dart';
import '../../questionnaire/nasa_tlx_questionnaire_screen.dart';
import '../widgets/experiment_widgets.dart';

class Stage6InterpretasiScreen extends StatelessWidget {
  final VoidCallback onFinish;
  final VoidCallback? onBack;
  final VoidCallback? onStageSelect;
  final VoidCallback? onAddSymptoms;
  final VoidCallback? onShareSummary;

  const Stage6InterpretasiScreen({
    super.key,
    required this.onFinish,
    this.onBack,
    this.onStageSelect,
    this.onAddSymptoms,
    this.onShareSummary,
  });

  void _showShareConfirmation(BuildContext context) {
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
              'Bagikan Ringkasan Deviasi',
              style: AppTheme.font(size: 17, weight: FontWeight.w800, color: const Color(0xFF0F2B3C)),
            ),
            const SizedBox(height: 8),
            Text(
              'Ringkasan deviasi denyut jantung 110 bpm (12 menit) dan koreksi konteks aktivitas "Duduk" siap diekspor dalam format PDF / ringkasan konsultasi dokter.',
              style: AppTheme.font(size: 13, color: const Color(0xFF5E7582), height: 1.4),
            ),
            const SizedBox(height: 18),
            ExperimentPrimaryButton(
              label: 'Salin Ringkasan Teks',
              icon: Icons.copy_rounded,
              showChevron: false,
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ringkasan berhasil disalin ke papan klip.')),
                );
              },
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
        stageNumber: 6,
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
              title: 'Interpretasi diperbarui',
              subtitle: 'Respons Anda telah diproses oleh sistem.',
            ),

            // Card 1: Persistent Deviation Alert
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
                          color: const Color(0xFF007A64),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  '!',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF007A64),
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Deviasi persisten',
                              style: AppTheme.font(
                                size: 11,
                                weight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Context updated pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2F3EF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.airline_seat_recline_normal_rounded,
                          size: 15,
                          color: Color(0xFF007A64),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Konteks diperbarui: Duduk',
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
                    'Berdasarkan koreksi aktivitas Anda, denyut jantung saat duduk berbeda dari pola personal yang biasa diamati.',
                    style: AppTheme.font(
                      size: 12,
                      color: const Color(0xFF5E7582),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),

            // Card 2: Sebelum vs Sesudah Respons
            ExperimentCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sebelum vs sesudah respons',
                    style: AppTheme.font(
                      size: 14.5,
                      weight: FontWeight.w800,
                      color: const Color(0xFF0F2B3C),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      // Sebelum
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7FBFD),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE0ECF1)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sebelum',
                                style: AppTheme.font(
                                  size: 12.5,
                                  weight: FontWeight.w800,
                                  color: const Color(0xFF0F2B3C),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE5F1F6),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.directions_walk_rounded,
                                      size: 16,
                                      color: Color(0xFF0F3E4D),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Aktivitas terdeteksi:',
                                          style: AppTheme.font(size: 9.5, color: const Color(0xFF708781)),
                                        ),
                                        Text(
                                          'Berjalan',
                                          style: AppTheme.font(
                                            size: 12,
                                            weight: FontWeight.w800,
                                            color: const Color(0xFF0F2B3C),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Interpretasi:',
                                style: AppTheme.font(size: 10, color: const Color(0xFF708781)),
                              ),
                              Text(
                                'sesuai konteks berjalan',
                                style: AppTheme.font(
                                  size: 11,
                                  weight: FontWeight.w700,
                                  color: const Color(0xFF007A64),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Sesudah
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1FAF7),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFF90D9C8), width: 1.4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sesudah',
                                style: AppTheme.font(
                                  size: 12.5,
                                  weight: FontWeight.w800,
                                  color: const Color(0xFF007A64),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFD6F2EA),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.airline_seat_recline_normal_rounded,
                                      size: 16,
                                      color: Color(0xFF007A64),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Aktivitas dikoreksi:',
                                          style: AppTheme.font(size: 9.5, color: const Color(0xFF708781)),
                                        ),
                                        Text(
                                          'Duduk',
                                          style: AppTheme.font(
                                            size: 12,
                                            weight: FontWeight.w800,
                                            color: const Color(0xFF0F2B3C),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Interpretasi:',
                                style: AppTheme.font(size: 10, color: const Color(0xFF708781)),
                              ),
                              Text(
                                'deviasi terhadap pola duduk',
                                style: AppTheme.font(
                                  size: 11,
                                  weight: FontWeight.w800,
                                  color: const Color(0xFF0F2B3C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Card 3: Status Pemrosesan
            ExperimentCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status pemrosesan',
                    style: AppTheme.font(
                      size: 14.5,
                      weight: FontWeight.w800,
                      color: const Color(0xFF0F2B3C),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProcessedStep(
                        isCheck: true,
                        stepLabel: 'Respons\nditerima',
                        isLast: false,
                        showLine: true,
                      ),
                      _buildProcessedStep(
                        isCheck: true,
                        stepLabel: 'Dicatat\ndi L1',
                        isLast: false,
                        showLine: true,
                      ),
                      _buildProcessedStep(
                        isCheck: true,
                        stepLabel: 'Dievaluasi ulang\ndi L2/L3',
                        isLast: false,
                        showLine: true,
                      ),
                      _buildProcessedStep(
                        isCheck: false,
                        number: 4,
                        stepLabel: 'Penjelasan\nbaru di L4',
                        isLast: true,
                        showLine: false,
                        isHighlight: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Card 4: Bukti & Batas Interpretasi
            ExperimentCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F3F7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.article_outlined,
                          color: Color(0xFF0F3E4D),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Bukti & batas interpretasi',
                        style: AppTheme.font(
                          size: 13.5,
                          weight: FontWeight.w800,
                          color: const Color(0xFF0F2B3C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBulletItem('Kualitas sinyal: baik'),
                        const SizedBox(height: 4),
                        _buildBulletItem('Durasi perubahan: 12 menit'),
                        const SizedBox(height: 4),
                        _buildBulletItem('Penyebab fisiologis belum dapat dipastikan.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Card 5: Apa yang Ingin Anda Lakukan Berikutnya?
            ExperimentCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Apa yang ingin Anda lakukan berikutnya?',
                    style: AppTheme.font(
                      size: 14.5,
                      weight: FontWeight.w800,
                      color: const Color(0xFF0F2B3C),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Option 1: Solid teal
                  ExperimentPrimaryButton(
                    label: 'Lanjutkan pemantauan',
                    icon: Icons.play_arrow_rounded,
                    onPressed: onFinish,
                  ),
                  const SizedBox(height: 10),

                  // Option 2: Outline Tambahkan gejala / pengalaman
                  ExperimentSecondaryButton(
                    label: 'Tambahkan gejala / pengalaman',
                    icon: Icons.article_outlined,
                    onPressed: onAddSymptoms ?? () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 10),

                  // Option 3: Outline Bagikan ringkasan
                  ExperimentSecondaryButton(
                    label: 'Bagikan ringkasan',
                    icon: Icons.share_outlined,
                    onPressed: () => _showShareConfirmation(context),
                  ),
                ],
              ),
            ),

            // Card 6: Kuesioner Evaluasi (SUS & NASA-TLX)
            ExperimentCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEFF6FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.assignment_turned_in_rounded,
                          size: 18,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Kuesioner Evaluasi Sesi',
                        style: AppTheme.font(
                          size: 14,
                          weight: FontWeight.w800,
                          color: const Color(0xFF0F2B3C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Mohon berikan penilaian kebergunaan dan beban kerja setelah menyelesaikan sesi pemantauan ini.',
                    style: AppTheme.font(
                      size: 11.5,
                      color: const Color(0xFF5E7582),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SusQuestionnaireScreen(),
                            ),
                          ),
                          icon: const Icon(Icons.checklist_rounded, size: 16),
                          label: const Text('Kuesioner SUS', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NasaTlxQuestionnaireScreen(),
                            ),
                          ),
                          icon: const Icon(Icons.speed_rounded, size: 16),
                          label: const Text('Kuesioner NASA-TLX', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1D4ED8),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),
            const ExperimentFooterDisclaimer(
              text: 'Koreksi pengguna membantu memperbarui interpretasi, tetapi tidak otomatis mengonfirmasi diagnosis.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessedStep({
    required bool isCheck,
    int? number,
    required String stepLabel,
    required bool isLast,
    required bool showLine,
    bool isHighlight = false,
  }) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: showLine && isLast
                    ? Container(height: 2, color: const Color(0xFF007A64))
                    : const SizedBox(),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: isHighlight ? const Color(0xFF007A64) : const Color(0xFF0F2B3C),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCheck
                      ? const Icon(Icons.check, size: 15, color: Colors.white)
                      : Text(
                          '${number ?? ''}',
                          style: AppTheme.font(
                            size: 11.5,
                            weight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              Expanded(
                child: showLine
                    ? Container(height: 2, color: const Color(0xFF007A64))
                    : const SizedBox(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            stepLabel,
            textAlign: TextAlign.center,
            style: AppTheme.font(
              size: 10,
              weight: isHighlight ? FontWeight.w800 : FontWeight.w600,
              color: isHighlight ? const Color(0xFF007A64) : const Color(0xFF0F2B3C),
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(fontSize: 14, color: Color(0xFF0F2B3C), fontWeight: FontWeight.w900),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTheme.font(
              size: 12,
              color: const Color(0xFF5E7582),
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
