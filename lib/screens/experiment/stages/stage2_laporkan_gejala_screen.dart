import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../widgets/experiment_widgets.dart';

/// Model sederhana data pelaporan gejala
class SymptomReportData {
  final List<String> selectedSymptoms;
  final String severity;
  final int severityScore;
  final String onset;
  final String trigger;
  final String notes;
  final DateTime timestamp;
  final int recordedBpm;

  const SymptomReportData({
    required this.selectedSymptoms,
    required this.severity,
    required this.severityScore,
    required this.onset,
    required this.trigger,
    required this.notes,
    required this.timestamp,
    required this.recordedBpm,
  });
}

/// Halaman Khusus Pelaporan Gejala Real-Time (Tahap 2 - Input Subjektif Pasien)
class Stage2LaporkanGejalaScreen extends StatefulWidget {
  final int currentBpm;
  final String elapsedDuration;
  final VoidCallback? onEscalateToDeviation;

  const Stage2LaporkanGejalaScreen({
    super.key,
    this.currentBpm = 74,
    this.elapsedDuration = '12:45',
    this.onEscalateToDeviation,
  });

  @override
  State<Stage2LaporkanGejalaScreen> createState() => _Stage2LaporkanGejalaScreenState();
}

class _Stage2LaporkanGejalaScreenState extends State<Stage2LaporkanGejalaScreen> {
  final TextEditingController _notesController = TextEditingController();

  // Kumpulan gejala terpilih
  final Set<String> _selectedSymptoms = {'Dada berdebar cepat'};

  // Tingkat keparahan (1: Ringan, 2: Sedang, 3: Berat, 4: Sangat Berat)
  int _selectedSeverityIndex = 1; // Default: Sedang
  final List<Map<String, dynamic>> _severityLevels = [
    {
      'title': 'Ringan',
      'range': '1 - 3',
      'desc': 'Terasa sepintas, tidak mengganggu duduk santai',
      'color': const Color(0xFF10B981),
      'bgColor': const Color(0xFFECFDF5),
    },
    {
      'title': 'Sedang',
      'range': '4 - 6',
      'desc': 'Mengganggu fokus, detak terasa hingga leher',
      'color': const Color(0xFFF59E0B),
      'bgColor': const Color(0xFFFFFBEB),
    },
    {
      'title': 'Berat',
      'range': '7 - 8',
      'desc': 'Sangat tidak nyaman, ada dorongan berbaring',
      'color': const Color(0xFFEF4444),
      'bgColor': const Color(0xFFFEF2F2),
    },
    {
      'title': 'Sangat Berat',
      'range': '9 - 10',
      'desc': 'Disertai lemas akut / alarm darurat',
      'color': const Color(0xFF991B1B),
      'bgColor': const Color(0xFFFEE2E2),
    },
  ];

  // Awitan / Onset
  String _selectedOnset = 'Baru saja (< 1 menit lalu)';
  final List<String> _onsetOptions = [
    'Baru saja (< 1 menit lalu)',
    '1 - 3 menit yang lalu',
    '> 5 menit (konstan terasa)',
  ];

  // Pemicu
  String _selectedTrigger = 'Sedang duduk diam relaks';
  final List<String> _triggerOptions = [
    'Sedang duduk diam relaks',
    'Mengubah posisi duduk',
    'Baru saja minum / menelan',
    'Fokus pikiran / membaca layar',
    'Tanpa pemicu yang jelas',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _toggleSymptom(String symptom) {
    setState(() {
      if (_selectedSymptoms.contains(symptom)) {
        if (_selectedSymptoms.length > 1) {
          _selectedSymptoms.remove(symptom);
        }
      } else {
        _selectedSymptoms.add(symptom);
      }
    });
  }

  void _addQuickNote(String text) {
    final current = _notesController.text.trim();
    if (current.isEmpty) {
      _notesController.text = text;
    } else {
      _notesController.text = '$current, $text';
    }
  }

  void _saveReport() {
    final level = _severityLevels[_selectedSeverityIndex];
    final report = SymptomReportData(
      selectedSymptoms: _selectedSymptoms.toList(),
      severity: level['title'] as String,
      severityScore: _selectedSeverityIndex + 1,
      onset: _selectedOnset,
      trigger: _selectedTrigger,
      notes: _notesController.text.trim(),
      timestamp: DateTime.now(),
      recordedBpm: widget.currentBpm,
    );

    Navigator.pop(context, report);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F2B3C), size: 24),
          onPressed: () => Navigator.of(context).pop(),
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
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFFCCD3), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded, size: 14, color: Color(0xFFE11D48)),
                const SizedBox(width: 5),
                Text(
                  'Tahap 2 • Lapor Gejala',
                  style: AppTheme.font(
                    size: 11.5,
                    weight: FontWeight.w700,
                    color: const Color(0xFFBE123C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER JUDUL
            const ExperimentPageHeader(
              title: 'Laporkan Gejala Saat Ini',
              subtitle:
                  'Sistem merekam sensasi tubuh yang Anda rasakan untuk dicocokkan dengan grafik sinyal sensor PPG real-time.',
            ),

            // 1. KARTU SNAPSHOT DATA TELEMETRI REAL-TIME
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F3E4D), Color(0xFF007A64)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF007A64).withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF34D399),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'SINKRONISASI SENSOR AKTIF',
                            style: AppTheme.font(
                              size: 10.5,
                              weight: FontWeight.w800,
                              color: const Color(0xFFA7F3D0),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Sesi: ${widget.elapsedDuration}',
                          style: AppTheme.font(
                            size: 11,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detak Jantung',
                              style: AppTheme.font(size: 11, color: const Color(0xFFD1FAE5)),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '${widget.currentBpm}',
                                  style: AppTheme.font(
                                    size: 28,
                                    weight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'BPM',
                                  style: AppTheme.font(
                                    size: 12,
                                    weight: FontWeight.w700,
                                    color: const Color(0xFFA7F3D0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 38, color: Colors.white.withValues(alpha: 0.2)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'HRV (RMSSD)',
                              style: AppTheme.font(size: 11, color: const Color(0xFFD1FAE5)),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '45',
                                  style: AppTheme.font(
                                    size: 28,
                                    weight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'ms',
                                  style: AppTheme.font(
                                    size: 12,
                                    weight: FontWeight.w700,
                                    color: const Color(0xFFA7F3D0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 38, color: Colors.white.withValues(alpha: 0.2)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Posisi Tubuh',
                              style: AppTheme.font(size: 11, color: const Color(0xFFD1FAE5)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Duduk SOP',
                              style: AppTheme.font(
                                size: 14,
                                weight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. KARTU PILIH GEJALA YANG DIRASAKAN
            ExperimentCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE4E6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.favorite_rounded, size: 18, color: Color(0xFFE11D48)),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '1. Apa yang sedang Anda rasakan?',
                        style: AppTheme.font(
                          size: 14.5,
                          weight: FontWeight.w800,
                          color: const Color(0xFF0F2B3C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pilih satu atau beberapa gejala di bawah yang paling menggambarkan kondisi Anda:',
                    style: AppTheme.font(size: 12, color: const Color(0xFF5E7582)),
                  ),
                  const SizedBox(height: 14),

                  // KELOMPOK A: JANTUNG & DADA
                  _buildCategoryLabel('🫀 Sensasi di Area Dada & Jantung'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSymptomChip('Dada berdebar cepat'),
                      _buildSymptomChip('Sensasi detak melompat (jeda)'),
                      _buildSymptomChip('Dada bergetar halus (flutter)'),
                      _buildSymptomChip('Rasa tertekan / sesak berat'),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // KELOMPOK B: KEPALA & NEUROLOGIS
                  _buildCategoryLabel('🧠 Sensasi di Kepala & Keseimbangan'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSymptomChip('Pusing melayang (ringan)'),
                      _buildSymptomChip('Kliyengan / limbung saat gerak'),
                      _buildSymptomChip('Pandangan berkunang-kunang'),
                      _buildSymptomChip('Sakit kepala berdenyut'),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // KELOMPOK C: PERNAPASAN & FISIK
                  _buildCategoryLabel('🫁 Pernapasan & Respon Fisik Tubuh'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSymptomChip('Napas memburu / pendek'),
                      _buildSymptomChip('Keringat dingin di telapak'),
                      _buildSymptomChip('Lemas otot mendadak'),
                      _buildSymptomChip('Tegang / cemas mendadak'),
                    ],
                  ),
                ],
              ),
            ),

            // 3. KARTU SKALA KEPARAHAN GEJALA
            ExperimentCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.speed_rounded, size: 18, color: Color(0xFFD97706)),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '2. Seberapa kuat intensitas gejalanya?',
                        style: AppTheme.font(
                          size: 14.5,
                          weight: FontWeight.w800,
                          color: const Color(0xFF0F2B3C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 4 Segmen Tingkat Keparahan
                  ...List.generate(_severityLevels.length, (idx) {
                    final item = _severityLevels[idx];
                    final isSelected = _selectedSeverityIndex == idx;
                    final itemColor = item['color'] as Color;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedSeverityIndex = idx),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? (item['bgColor'] as Color) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? itemColor : const Color(0xFFE2EBE9),
                            width: isSelected ? 1.8 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? itemColor : const Color(0xFFCBD8D5),
                                  width: 2,
                                ),
                                color: isSelected ? itemColor : Colors.transparent,
                              ),
                              child: isSelected
                                  ? const Center(
                                      child: Icon(Icons.check, size: 13, color: Colors.white),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        item['title'] as String,
                                        style: AppTheme.font(
                                          size: 13.5,
                                          weight: FontWeight.w800,
                                          color: isSelected ? itemColor : const Color(0xFF0F2B3C),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                        decoration: BoxDecoration(
                                          color: itemColor.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Skala ${item['range']}',
                                          style: AppTheme.font(
                                            size: 10,
                                            weight: FontWeight.w700,
                                            color: itemColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item['desc'] as String,
                                    style: AppTheme.font(
                                      size: 11.5,
                                      color: const Color(0xFF6B807B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // 4. KARTU AWITAN & PEMICU TERAKHIR
            ExperimentCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.timer_outlined, size: 18, color: Color(0xFF0284C7)),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '3. Waktu Muncul & Konteks Pemicu',
                        style: AppTheme.font(
                          size: 14.5,
                          weight: FontWeight.w800,
                          color: const Color(0xFF0F2B3C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Text(
                    'Kapan gejala mulai dirasakan?',
                    style: AppTheme.font(size: 12.5, weight: FontWeight.w700, color: const Color(0xFF0F2B3C)),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _onsetOptions.map((opt) {
                      final isSel = _selectedOnset == opt;
                      return ChoiceChip(
                        label: Text(opt),
                        selected: isSel,
                        onSelected: (_) => setState(() => _selectedOnset = opt),
                        selectedColor: const Color(0xFFE2F5EF),
                        backgroundColor: Colors.white,
                        labelStyle: AppTheme.font(
                          size: 12,
                          weight: isSel ? FontWeight.w700 : FontWeight.w500,
                          color: isSel ? const Color(0xFF007A64) : const Color(0xFF475569),
                        ),
                        side: BorderSide(
                          color: isSel ? const Color(0xFF007A64) : const Color(0xFFCBD8D5),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Apa aktivitas tepat sebelum gejala muncul?',
                    style: AppTheme.font(size: 12.5, weight: FontWeight.w700, color: const Color(0xFF0F2B3C)),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _triggerOptions.map((trig) {
                      final isSel = _selectedTrigger == trig;
                      return ChoiceChip(
                        label: Text(trig),
                        selected: isSel,
                        onSelected: (_) => setState(() => _selectedTrigger = trig),
                        selectedColor: const Color(0xFFE0F2FE),
                        backgroundColor: Colors.white,
                        labelStyle: AppTheme.font(
                          size: 12,
                          weight: isSel ? FontWeight.w700 : FontWeight.w500,
                          color: isSel ? const Color(0xFF0284C7) : const Color(0xFF475569),
                        ),
                        side: BorderSide(
                          color: isSel ? const Color(0xFF0284C7) : const Color(0xFFCBD8D5),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // 5. KARTU CATATAN TAMBAHAN
            ExperimentCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE9FE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.edit_note_rounded, size: 18, color: Color(0xFF7C3AED)),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '4. Catatan Tambahan (Opsional)',
                        style: AppTheme.font(
                          size: 14.5,
                          weight: FontWeight.w800,
                          color: const Color(0xFF0F2B3C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    maxLength: 200,
                    style: AppTheme.font(size: 13),
                    decoration: InputDecoration(
                      hintText: 'Deskripsikan sensasi yang Anda rasakan di dada atau tubuh secara lebih detail...',
                      hintStyle: AppTheme.font(size: 12.5, color: const Color(0xFF94A3B8)),
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFCBD8D5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF007A64), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Saran deskripsi cepat:',
                    style: AppTheme.font(size: 11, color: const Color(0xFF64748B), weight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _buildQuickNoteChip('Ketukan keras di leher'),
                      _buildQuickNoteChip('Mereda saat tarik napas'),
                      _buildQuickNoteChip('Perut terasa kembung'),
                    ],
                  ),
                ],
              ),
            ),

            // 6. PERINGATAN PROTOKOL DARURAT MEDIS
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFECDD3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.emergency_rounded, size: 20, color: Color(0xFFE11D48)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Peringatan Keselamatan Darurat:',
                          style: AppTheme.font(
                            size: 12,
                            weight: FontWeight.w800,
                            color: const Color(0xFF9F1239),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Jika sensasi berdebar disertai nyeri dada menjalar ke lengan kiri/leher, sesak napas berat, atau pandangan gelap, segera hentikan pemantauan dan hubungi ambulans / IGD (119).',
                          style: AppTheme.font(
                            size: 11,
                            color: const Color(0xFFBE123C),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 7. TOMBOL TINDAKAN UTAMA
            ExperimentPrimaryButton(
              label: 'Simpan Laporan Gejala ke Sesi',
              icon: Icons.check_circle_outline_rounded,
              onPressed: _saveReport,
            ),
            const SizedBox(height: 10),

            // Tombol Opsi: Eskalasi langsung ke deviasi jika berat
            if (_selectedSeverityIndex >= 2) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _saveReport();
                    widget.onEscalateToDeviation?.call();
                  },
                  icon: const Icon(Icons.alt_route_rounded, size: 16),
                  label: const Text('Eskalasi ke Konfirmasi Deviasi (Tahap 4)'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE11D48),
                    side: const BorderSide(color: Color(0xFFE11D48)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],

            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Batal dan Kembali ke Pemantauan',
                  style: AppTheme.font(
                    size: 12.5,
                    weight: FontWeight.w700,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryLabel(String label) {
    return Text(
      label,
      style: AppTheme.font(
        size: 12,
        weight: FontWeight.w700,
        color: const Color(0xFF334155),
      ),
    );
  }

  Widget _buildSymptomChip(String name) {
    final isSelected = _selectedSymptoms.contains(name);
    return FilterChip(
      label: Text(name),
      selected: isSelected,
      onSelected: (_) => _toggleSymptom(name),
      selectedColor: const Color(0xFFE2F5EF),
      backgroundColor: Colors.white,
      checkmarkColor: const Color(0xFF007A64),
      labelStyle: AppTheme.font(
        size: 12,
        weight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? const Color(0xFF007A64) : const Color(0xFF1E293B),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected ? const Color(0xFF007A64) : const Color(0xFFCBD8D5),
          width: isSelected ? 1.5 : 1,
        ),
      ),
    );
  }

  Widget _buildQuickNoteChip(String text) {
    return ActionChip(
      label: Text(
        text,
        style: AppTheme.font(size: 11, color: const Color(0xFF475569)),
      ),
      backgroundColor: const Color(0xFFF1F5F9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onPressed: () => _addQuickNote(text),
    );
  }
}
