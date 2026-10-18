import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../widgets/experiment_widgets.dart';

class Stage5ResponsScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final VoidCallback? onStageSelect;
  final String initialContext;

  const Stage5ResponsScreen({
    super.key,
    required this.onNext,
    this.onBack,
    this.onStageSelect,
    this.initialContext = 'Saya sedang duduk',
  });

  @override
  State<Stage5ResponsScreen> createState() => _Stage5ResponsScreenState();
}

class _Stage5ResponsScreenState extends State<Stage5ResponsScreen> {
  late String _selectedContext;
  final Set<String> _selectedExperiences = {};
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedContext = widget.initialContext;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _toggleExperience(String title) {
    setState(() {
      if (title == 'Tidak ada gejala') {
        _selectedExperiences.clear();
        _selectedExperiences.add(title);
      } else {
        _selectedExperiences.remove('Tidak ada gejala');
        if (_selectedExperiences.contains(title)) {
          _selectedExperiences.remove(title);
        } else {
          _selectedExperiences.add(title);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF9),
      appBar: ExperimentAppBar(
        stageNumber: 5,
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
              title: 'Respons pengguna',
              subtitle: 'Koreksi dan pengalaman Anda membantu evaluasi ulang sistem.',
            ),

            // Card 1: Koreksi Konteks
            ExperimentCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE2F3F0),
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
                              'Koreksi konteks',
                              style: AppTheme.font(
                                size: 14.5,
                                weight: FontWeight.w800,
                                color: const Color(0xFF0F2B3C),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Pilih konteks aktivitas Anda saat ini. Koreksi ini akan digunakan untuk mengevaluasi ulang interpretasi sistem.',
                              style: AppTheme.font(
                                size: 11.5,
                                color: const Color(0xFF6B807B),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Option 1: Duduk
                  _buildContextRadioOption(
                    title: 'Saya sedang duduk',
                    icon: Icons.airline_seat_recline_normal_rounded,
                    isSelected: _selectedContext == 'Saya sedang duduk',
                    onTap: () => setState(() => _selectedContext = 'Saya sedang duduk'),
                  ),
                  const SizedBox(height: 10),

                  // Option 2: Berjalan
                  _buildContextRadioOption(
                    title: 'Saya baru berjalan',
                    icon: Icons.directions_walk_rounded,
                    isSelected: _selectedContext == 'Saya baru berjalan',
                    onTap: () => setState(() => _selectedContext = 'Saya baru berjalan'),
                  ),
                  const SizedBox(height: 10),

                  // Option 3: Tidak yakin
                  _buildContextRadioOption(
                    title: 'Saya tidak yakin',
                    icon: Icons.help_rounded,
                    isSelected: _selectedContext == 'Saya tidak yakin',
                    onTap: () => setState(() => _selectedContext = 'Saya tidak yakin'),
                  ),
                ],
              ),
            ),

            // Card 2: Tambahkan Pengalaman
            ExperimentCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F3F7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.article_outlined,
                          color: Color(0xFF0F3E4D),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tambahkan pengalaman',
                              style: AppTheme.font(
                                size: 14.5,
                                weight: FontWeight.w800,
                                color: const Color(0xFF0F2B3C),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Pilih gejala atau kondisi yang Anda rasakan saat ini (opsional). Beberapa pilihan dapat dipilih.',
                              style: AppTheme.font(
                                size: 11.5,
                                color: const Color(0xFF6B807B),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 2x2 grid of experiences
                  Row(
                    children: [
                      Expanded(
                        child: _buildExperienceChip(
                          icon: Icons.psychology_outlined,
                          title: 'Cemas',
                          isSelected: _selectedExperiences.contains('Cemas'),
                          onTap: () => _toggleExperience('Cemas'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildExperienceChip(
                          icon: Icons.coffee_rounded,
                          title: 'Baru minum kopi',
                          isSelected: _selectedExperiences.contains('Baru minum kopi'),
                          onTap: () => _toggleExperience('Baru minum kopi'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildExperienceChip(
                          icon: Icons.cyclone_rounded,
                          title: 'Pusing',
                          isSelected: _selectedExperiences.contains('Pusing'),
                          onTap: () => _toggleExperience('Pusing'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildExperienceChip(
                          icon: Icons.favorite_border_rounded,
                          title: 'Tidak ada gejala',
                          isSelected: _selectedExperiences.contains('Tidak ada gejala'),
                          onTap: () => _toggleExperience('Tidak ada gejala'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Short Note input
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFDCE6E4)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Icon(Icons.article_outlined, size: 18, color: Color(0xFF6B807B)),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _noteController,
                                maxLength: 200,
                                maxLines: 2,
                                onChanged: (_) => setState(() {}),
                                decoration: const InputDecoration(
                                  hintText: 'Tulis catatan singkat...',
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  filled: false,
                                  isDense: true,
                                  counterText: '',
                                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                                ),
                                style: AppTheme.font(size: 12.5),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${_noteController.text.length}/200',
                          style: AppTheme.font(size: 10.5, color: const Color(0xFF90A39E)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Card 3: Apa yang akan dilakukan sistem?
            ExperimentCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F3F7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.settings_outlined,
                          color: Color(0xFF0F3E4D),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Apa yang akan dilakukan sistem?',
                              style: AppTheme.font(
                                size: 14.5,
                                weight: FontWeight.w800,
                                color: const Color(0xFF0F2B3C),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Respons Anda akan diproses melalui empat lapisan sistem.',
                              style: AppTheme.font(
                                size: 11.5,
                                color: const Color(0xFF6B807B),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const FourLayerStepper(
                    activeLayer: 1,
                    layerTitles: [
                      'Respons\ndicatat di L1',
                      'Konteks\ndiperbarui di L2',
                      'Interpretasi\ndievaluasi ulang\ndi L3',
                      'Penjelasan baru\ndisajikan di L4',
                    ],
                    showDescriptions: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007A64),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: widget.onNext,
                icon: const Icon(Icons.send_rounded, size: 18),
                label: Text(
                  'Kirim respons',
                  style: AppTheme.font(
                    size: 13.5,
                    weight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Cancel Button
            ExperimentSecondaryButton(
              label: 'Batal',
              showChevron: false,
              onPressed: widget.onBack ?? () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextRadioOption({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3FAF7) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF007A64) : const Color(0xFFDCE6E4),
            width: isSelected ? 1.5 : 1,
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
                  color: isSelected ? const Color(0xFF007A64) : const Color(0xFFCBD8D5),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF007A64),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Icon(
              icon,
              size: 20,
              color: isSelected ? const Color(0xFF007A64) : const Color(0xFF0F2B3C),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: AppTheme.font(
                size: 13,
                weight: FontWeight.w700,
                color: const Color(0xFF0F2B3C),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceChip({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF1F9F6) : const Color(0xFFF8FAF9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF007A64) : const Color(0xFFDCE6E4),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 17,
              color: isSelected ? const Color(0xFF007A64) : const Color(0xFF0F2B3C),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.font(
                  size: 11.5,
                  weight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? const Color(0xFF007A64) : const Color(0xFF0F2B3C),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
