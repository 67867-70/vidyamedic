import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'stages/stage1_persiapan_screen.dart';
import 'stages/stage2_berjalan_screen.dart';
import 'stages/stage3_profil_screen.dart';
import 'stages/stage4_deviasi_screen.dart';
import 'stages/stage5_respons_screen.dart';
import 'stages/stage6_interpretasi_screen.dart';
import '../questionnaire/sus_questionnaire_screen.dart';
import '../questionnaire/nasa_tlx_questionnaire_screen.dart';

/// Alur Eksperimen & Deviasi 6 Tahap Vidyamedic
/// Mengakomodasi 6 layar lengkap sesuai rancangan di folder tambahan.
class ExperimentFlowScreen extends StatefulWidget {
  final int initialStage;

  const ExperimentFlowScreen({
    super.key,
    this.initialStage = 1,
  });

  @override
  State<ExperimentFlowScreen> createState() => _ExperimentFlowScreenState();
}

class _ExperimentFlowScreenState extends State<ExperimentFlowScreen> {
  late int _currentStage;
  String _userConfirmedActivity = 'Saya sedang duduk';

  final List<String> _stageNames = [
    'Persiapan pemantauan',
    'Eksperimen berjalan',
    'Profil kesehatan personal',
    'Perubahan data terdeteksi',
    'Respons pengguna',
    'Interpretasi diperbarui',
  ];

  @override
  void initState() {
    super.initState();
    _currentStage = widget.initialStage.clamp(1, 6);
  }

  void _goToStage(int stage) {
    if (stage >= 1 && stage <= 6) {
      setState(() {
        _currentStage = stage;
      });
    }
  }

  void _nextStage() {
    if (_currentStage < 6) {
      _goToStage(_currentStage + 1);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _prevStage() {
    if (_currentStage > 1) {
      _goToStage(_currentStage - 1);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _showStagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6E2DF),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Pilih Tahap Eksperimen (1 - 6)',
              style: AppTheme.font(
                size: 16,
                weight: FontWeight.w800,
                color: const Color(0xFF0F2B3C),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Beralih langsung ke layar tahap tertentu:',
              style: AppTheme.font(size: 12, color: const Color(0xFF6B807B)),
            ),
            const SizedBox(height: 14),
            ...List.generate(6, (index) {
              final stageNum = index + 1;
              final isCurrent = stageNum == _currentStage;
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: isCurrent ? const Color(0xFFE2F3EF) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCurrent ? const Color(0xFF007A64) : const Color(0xFFE5EDE9),
                  ),
                ),
                child: ListTile(
                  dense: true,
                  leading: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isCurrent ? const Color(0xFF007A64) : const Color(0xFFEDF3F1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$stageNum',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: isCurrent ? Colors.white : const Color(0xFF5E7582),
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    _stageNames[index],
                    style: AppTheme.font(
                      size: 13,
                      weight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                      color: isCurrent ? const Color(0xFF007A64) : const Color(0xFF0F2B3C),
                    ),
                  ),
                  subtitle: Text(
                    'Tahap $stageNum dari 6',
                    style: AppTheme.font(size: 10.5, color: const Color(0xFF7A8F8A)),
                  ),
                  trailing: isCurrent
                      ? const Icon(Icons.check_circle_rounded, color: Color(0xFF007A64), size: 18)
                      : const Icon(Icons.chevron_right_rounded, color: Color(0xFFCBD8D5), size: 18),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _goToStage(stageNum);
                  },
                ),
              );
            }),
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFE2E8F0)),
            const SizedBox(height: 8),
            Text(
              'Kuesioner Evaluasi:',
              style: AppTheme.font(
                size: 13,
                weight: FontWeight.w700,
                color: const Color(0xFF0F2B3C),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SusQuestionnaireScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.checklist_rounded, size: 16),
                    label: const Text('Kuesioner SUS', style: TextStyle(fontSize: 11.5)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D4ED8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NasaTlxQuestionnaireScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.speed_rounded, size: 16),
                    label: const Text('Kuesioner NASA-TLX', style: TextStyle(fontSize: 11.5)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget activeScreen;

    switch (_currentStage) {
      case 1:
        activeScreen = Stage1PersiapanScreen(
          onNext: _nextStage,
          onBack: _prevStage,
          onStageSelect: _showStagePicker,
        );
        break;
      case 2:
        activeScreen = Stage2BerjalanScreen(
          onNext: _nextStage,
          onBack: _prevStage,
          onStageSelect: _showStagePicker,
        );
        break;
      case 3:
        activeScreen = Stage3ProfilScreen(
          onNext: _nextStage,
          onBack: _prevStage,
          onStageSelect: _showStagePicker,
        );
        break;
      case 4:
        activeScreen = Stage4DeviasiScreen(
          onNext: _nextStage,
          onBack: _prevStage,
          onStageSelect: _showStagePicker,
          onConfirmActivity: (act) {
            setState(() {
              if (act == 'Duduk') {
                _userConfirmedActivity = 'Saya sedang duduk';
              } else if (act == 'Berjalan') {
                _userConfirmedActivity = 'Saya baru berjalan';
              } else {
                _userConfirmedActivity = 'Saya tidak yakin';
              }
            });
          },
        );
        break;
      case 5:
        activeScreen = Stage5ResponsScreen(
          initialContext: _userConfirmedActivity,
          onNext: _nextStage,
          onBack: _prevStage,
          onStageSelect: _showStagePicker,
        );
        break;
      case 6:
      default:
        activeScreen = Stage6InterpretasiScreen(
          onFinish: () => Navigator.of(context).pop(),
          onBack: _prevStage,
          onStageSelect: _showStagePicker,
        );
        break;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: activeScreen,
    );
  }
}
