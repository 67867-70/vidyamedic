import 'dart:async';
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../widgets/experiment_widgets.dart';
import 'stage2_laporkan_gejala_screen.dart';

class Stage2BerjalanScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final VoidCallback? onStageSelect;
  final int heartRate;

  const Stage2BerjalanScreen({
    super.key,
    required this.onNext,
    this.onBack,
    this.onStageSelect,
    this.heartRate = 82,
  });

  @override
  State<Stage2BerjalanScreen> createState() => _Stage2BerjalanScreenState();
}

class _Stage2BerjalanScreenState extends State<Stage2BerjalanScreen> {
  int _seconds = 252; // 04:12 start
  Timer? _timer;
  SymptomReportData? _reportedSymptom;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _seconds++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedDuration {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _showAddNoteDialog() {
    final noteCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambahkan Catatan'),
        content: TextField(
          controller: noteCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Tuliskan catatan kondisi saat ini...',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Catatan berhasil direkam dalam sesi.')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _openReportSymptomScreen() async {
    final result = await Navigator.push<SymptomReportData>(
      context,
      MaterialPageRoute(
        builder: (_) => Stage2LaporkanGejalaScreen(
          currentBpm: widget.heartRate,
          elapsedDuration: _formattedDuration,
          onEscalateToDeviation: () {
            widget.onNext();
          },
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _reportedSymptom = result;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ Gejala "${result.selectedSymptoms.first}" (${result.severity}) berhasil dicatat dalam riwayat sesi.',
          ),
          backgroundColor: const Color(0xFF007A64),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF9),
      appBar: ExperimentAppBar(
        stageNumber: 2,
        onBackPressed: widget.onBack,
        onStageSelect: widget.onStageSelect,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ExperimentPageHeader(
              title: 'Eksperimen berjalan',
              subtitle: 'Sistem sedang mengumpulkan data dan konteks aktivitas.',
            ),

            // Card 1: Realtime Metrics Banner
            ExperimentCard(
              padding: const EdgeInsets.all(18),
              child: Column(
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
                              color: Color(0xFFE3F5F0),
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
                                    '${widget.heartRate}',
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.airline_seat_recline_normal_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Sesi duduk tenang',
                              style: AppTheme.font(
                                size: 11.5,
                                weight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FAF9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2EBE9)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.timer_outlined, size: 20, color: Color(0xFF0F2B3C)),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Durasi sesi',
                                    style: AppTheme.font(
                                      size: 10.5,
                                      color: const Color(0xFF708781),
                                    ),
                                  ),
                                  Text(
                                    _formattedDuration,
                                    style: AppTheme.font(
                                      size: 18,
                                      weight: FontWeight.w800,
                                      color: const Color(0xFF0F2B3C),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(width: 1, height: 32, color: const Color(0xFFDDE7E5)),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: Row(
                              children: [
                                const Icon(Icons.bar_chart_rounded, size: 22, color: Color(0xFF007A64)),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Kualitas sinyal:',
                                      style: AppTheme.font(
                                        size: 10.5,
                                        color: const Color(0xFF708781),
                                      ),
                                    ),
                                    Text(
                                      'baik',
                                      style: AppTheme.font(
                                        size: 15,
                                        weight: FontWeight.w800,
                                        color: const Color(0xFF007A64),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Card 2: Protokol Sesi
            ExperimentCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Protokol sesi',
                    style: AppTheme.font(
                      size: 14.5,
                      weight: FontWeight.w800,
                      color: const Color(0xFF0F2B3C),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Horizontal Stepper: 1 Duduk tenang - 2 Berdiri - 3 Jalan - 4 EMA
                  Row(
                    children: [
                      _buildProtocolStep(number: 1, label: 'Duduk tenang', isActive: true),
                      _buildProtocolStepLine(isCompleted: false),
                      _buildProtocolStep(number: 2, label: 'Berdiri', isActive: false),
                      _buildProtocolStepLine(isCompleted: false),
                      _buildProtocolStep(number: 3, label: 'Jalan', isActive: false),
                      _buildProtocolStepLine(isCompleted: false),
                      _buildProtocolStep(number: 4, label: 'EMA', isActive: false),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Instruction highlight box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F8F6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD6EAE3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFFD8EFE8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.airline_seat_recline_normal_rounded,
                            color: Color(0xFF007A64),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Instruksi saat ini',
                                style: AppTheme.font(
                                  size: 10.5,
                                  color: const Color(0xFF6B807B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Tetap duduk rileks dan hindari gerakan berlebihan.',
                                style: AppTheme.font(
                                  size: 12.5,
                                  weight: FontWeight.w700,
                                  color: const Color(0xFF0F2B3C),
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Card 3: Input yang Direkam
            ExperimentCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Input yang direkam',
                    style: AppTheme.font(
                      size: 14.5,
                      weight: FontWeight.w800,
                      color: const Color(0xFF0F2B3C),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildRecordedItem(
                    icon: Icons.favorite_rounded,
                    title: 'HR (detak jantung)',
                    subtitle: 'Nilai real-time dari sensor',
                  ),
                  const Divider(height: 16, color: Color(0xFFEDF3F1)),

                  _buildRecordedItem(
                    icon: Icons.air_rounded,
                    title: 'RR/IBI (laju napas / interval antar detak)',
                    subtitle: 'Dihitung dari sinyal fisiologis',
                  ),
                  const Divider(height: 16, color: Color(0xFFEDF3F1)),

                  _buildRecordedItem(
                    icon: Icons.directions_walk_rounded,
                    title: 'Konteks aktivitas',
                    subtitle: 'Sesi duduk tenang (otomatis)',
                  ),
                  const Divider(height: 16, color: Color(0xFFEDF3F1)),

                  _buildRecordedItem(
                    icon: Icons.access_time_rounded,
                    title: 'Waktu',
                    subtitle: 'Stempel waktu setiap data',
                  ),
                  const Divider(height: 16, color: Color(0xFFEDF3F1)),

                  _buildRecordedItem(
                    icon: Icons.article_outlined,
                    title: 'Catatan pengguna',
                    subtitle: 'Keluhan, perasaan, atau kejadian khusus',
                  ),
                ],
              ),
            ),

            // Card 4: Jika ada perubahan
            ExperimentCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jika ada perubahan',
                    style: AppTheme.font(
                      size: 14.5,
                      weight: FontWeight.w800,
                      color: const Color(0xFF0F2B3C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _showAddNoteDialog,
                          icon: const Icon(Icons.article_outlined, size: 16),
                          label: const Text('Tambahkan catatan', style: TextStyle(fontSize: 12)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0F3E4D),
                            side: const BorderSide(color: Color(0xFFCBD8D5)),
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _openReportSymptomScreen,
                          icon: const Icon(Icons.warning_amber_rounded, size: 16),
                          label: const Text('Laporkan gejala', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF007A64),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Tampilan Feedback jika gejala sudah dilaporkan
                  if (_reportedSymptom != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF86EFAC)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFDCFCE7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check_circle_rounded, size: 18, color: Color(0xFF16A34A)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gejala Dicatat: ${_reportedSymptom!.selectedSymptoms.join(", ")}',
                                  style: AppTheme.font(
                                    size: 12,
                                    weight: FontWeight.w700,
                                    color: const Color(0xFF166534),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Intensitas ${_reportedSymptom!.severity} • ${_reportedSymptom!.onset}',
                                  style: AppTheme.font(size: 11, color: const Color(0xFF15803D)),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF15803D)),
                            tooltip: 'Perbarui Gejala',
                            onPressed: _openReportSymptomScreen,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Navigation to Next Stage
            ExperimentPrimaryButton(
              label: 'Lanjut ke Profil Personal',
              icon: Icons.arrow_forward_rounded,
              onPressed: widget.onNext,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolStep({
    required int number,
    required String label,
    required bool isActive,
  }) {
    return Column(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF007A64) : const Color(0xFFE8EFF0),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: AppTheme.font(
                size: 11,
                weight: FontWeight.w800,
                color: isActive ? Colors.white : const Color(0xFF6B807B),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTheme.font(
            size: 10,
            weight: isActive ? FontWeight.w800 : FontWeight.w600,
            color: isActive ? const Color(0xFF007A64) : const Color(0xFF6B807B),
          ),
        ),
      ],
    );
  }

  Widget _buildProtocolStepLine({required bool isCompleted}) {
    return Expanded(
      child: Container(
        height: 1.5,
        margin: const EdgeInsets.only(bottom: 16),
        color: isCompleted ? const Color(0xFF007A64) : const Color(0xFFD6E2DF),
      ),
    );
  }

  Widget _buildRecordedItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFFEBF6F3),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF007A64), size: 17),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.font(
                  size: 12.5,
                  weight: FontWeight.w700,
                  color: const Color(0xFF0F2B3C),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                style: AppTheme.font(
                  size: 10.5,
                  color: const Color(0xFF708781),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
