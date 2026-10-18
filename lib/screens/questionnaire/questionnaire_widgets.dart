import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Reusable widgets for SUS and NASA-TLX Questionnaires matching user design

/// Questionnaire Top Header with Vidyamedic brand & step counter indicator
class QuestionnaireHeader extends StatelessWidget {
  final int currentStep; // 1, 2, or 3
  final int totalSteps;

  const QuestionnaireHeader({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.favorite_rounded,
                    color: Color(0xFF2563EB),
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Vidyamedic',
                style: AppTheme.font(
                  size: 16.5,
                  weight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '$currentStep dari $totalSteps',
                style: AppTheme.font(
                  size: 11.5,
                  weight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 2.5,
                  color: const Color(0xFF2563EB),
                  backgroundColor: const Color(0xFFE2E8F0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Stepper Item for the 3 steps (Pendahuluan, Kuesioner, Selesai)
class QuestionnaireStepper extends StatelessWidget {
  final int activeStep; // 1, 2, 3
  final String questionnaireTitle;
  final ValueChanged<int>? onStepTapped;

  const QuestionnaireStepper({
    super.key,
    required this.activeStep,
    required this.questionnaireTitle,
    this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepItem(
          stepNumber: 1,
          label: 'Pendahuluan',
          isDone: activeStep > 1,
          isActive: activeStep == 1,
        ),
        _buildConnector(isDone: activeStep > 1),
        _buildStepItem(
          stepNumber: 2,
          label: questionnaireTitle,
          isDone: activeStep > 2,
          isActive: activeStep == 2,
        ),
        _buildConnector(isDone: activeStep > 2),
        _buildStepItem(
          stepNumber: 3,
          label: 'Selesai',
          isDone: false,
          isActive: activeStep == 3,
        ),
      ],
    );
  }

  Widget _buildStepItem({
    required int stepNumber,
    required String label,
    required bool isDone,
    required bool isActive,
  }) {
    return InkWell(
      onTap: onStepTapped != null ? () => onStepTapped!(stepNumber) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isDone
                    ? const Color(0xFFEFF6FF)
                    : isActive
                        ? const Color(0xFF1D4ED8)
                        : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDone
                      ? const Color(0xFF93C5FD)
                      : isActive
                          ? const Color(0xFF1D4ED8)
                          : const Color(0xFFCBD5E1),
                  width: 1.2,
                ),
              ),
              child: Center(
                child: isDone
                    ? const Icon(Icons.check, size: 14, color: Color(0xFF2563EB))
                    : Text(
                        '$stepNumber',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: isActive ? Colors.white : const Color(0xFF64748B),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTheme.font(
                size: 12,
                weight: isActive ? FontWeight.w800 : FontWeight.w600,
                color: isActive
                    ? const Color(0xFF0F172A)
                    : isDone
                        ? const Color(0xFF475569)
                        : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnector({required bool isDone}) {
    return Container(
      width: 1.5,
      height: 16,
      margin: const EdgeInsets.only(left: 11),
      color: isDone ? const Color(0xFF93C5FD) : const Color(0xFFE2E8F0),
    );
  }
}

/// Horizontal Stepper for Mobile devices
class QuestionnaireStepperHorizontal extends StatelessWidget {
  final int activeStep;
  final String questionnaireTitle;
  final ValueChanged<int>? onStepTapped;

  const QuestionnaireStepperHorizontal({
    super.key,
    required this.activeStep,
    required this.questionnaireTitle,
    this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildItem(1, 'Pendahuluan', activeStep > 1, activeStep == 1),
          _buildLine(activeStep > 1),
          _buildItem(2, questionnaireTitle.replaceAll('\n', ' '), activeStep > 2, activeStep == 2),
          _buildLine(activeStep > 2),
          _buildItem(3, 'Selesai', false, activeStep == 3),
        ],
      ),
    );
  }

  Widget _buildItem(int number, String label, bool isDone, bool isActive) {
    return InkWell(
      onTap: onStepTapped != null ? () => onStepTapped!(number) : null,
      borderRadius: BorderRadius.circular(6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: isDone
                  ? const Color(0xFFEFF6FF)
                  : isActive
                      ? const Color(0xFF1D4ED8)
                      : const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
              border: Border.all(
                color: isDone
                    ? const Color(0xFF93C5FD)
                    : isActive
                        ? const Color(0xFF1D4ED8)
                        : const Color(0xFFCBD5E1),
                width: 1.2,
              ),
            ),
            child: Center(
              child: isDone
                  ? const Icon(Icons.check, size: 13, color: Color(0xFF2563EB))
                  : Text(
                      '$number',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: isActive ? Colors.white : const Color(0xFF64748B),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTheme.font(
              size: 11,
              weight: isActive ? FontWeight.w800 : FontWeight.w600,
              color: isActive
                  ? const Color(0xFF0F172A)
                  : isDone
                      ? const Color(0xFF475569)
                      : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLine(bool isDone) {
    return Expanded(
      child: Container(
        height: 1.5,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: isDone ? const Color(0xFF93C5FD) : const Color(0xFFE2E8F0),
      ),
    );
  }
}

/// Information callout banner (Blue soft box with icon)
class QuestionnaireInfoBanner extends StatelessWidget {
  final String text;

  const QuestionnaireInfoBanner({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: Color(0xFF2563EB), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTheme.font(
                size: 11.5,
                color: const Color(0xFF1E3A8A),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom navigation buttons for questionnaires (Kembali & Lanjut)
class QuestionnaireBottomBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;
  final String nextLabel;
  final bool isNextEnabled;

  const QuestionnaireBottomBar({
    super.key,
    required this.onBack,
    required this.onNext,
    this.nextLabel = 'Lanjut',
    this.isNextEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFFF8FAFC),
              foregroundColor: const Color(0xFF334155),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              minimumSize: const Size(100, 42),
            ),
            onPressed: onBack,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_back_rounded, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Kembali',
                  style: AppTheme.font(
                    size: 13,
                    weight: FontWeight.w600,
                    color: const Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              minimumSize: const Size(110, 42),
            ),
            onPressed: isNextEnabled ? onNext : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  nextLabel,
                  style: AppTheme.font(
                    size: 13,
                    weight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_forward_rounded, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
