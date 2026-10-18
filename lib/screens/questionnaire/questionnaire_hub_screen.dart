import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'sus_questionnaire_screen.dart';
import 'nasa_tlx_questionnaire_screen.dart';

/// Hub Evaluasi & Kuesioner (SUS & NASA-TLX)
class QuestionnaireHubScreen extends StatelessWidget {
  const QuestionnaireHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Kuesioner Evaluasi Vidyamedic',
          style: AppTheme.font(
            size: 17,
            weight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
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
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.rate_review_outlined, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Evaluasi Pengalaman Pengguna',
                          style: AppTheme.font(
                            size: 14.5,
                            weight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Bantu kami mengevaluasi kebergunaan dan tingkat beban kerja sistem Vidyamedic.',
                          style: AppTheme.font(
                            size: 11.5,
                            color: Colors.white70,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Pilih Kuesioner yang Ingin Diisi:',
              style: AppTheme.font(
                size: 14,
                weight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            // Card 1: Kuesioner SUS
            _buildQuestionnaireLauncherCard(
              context,
              title: 'Kuesioner SUS (System Usability Scale)',
              badge: '10 Pernyataan',
              subtitle:
                  'Mengukur kemudahan penggunaan, kejelasan antarmuka, dan integrasi fitur aplikasi Vidyamedic.',
              icon: Icons.checklist_rounded,
              buttonColor: const Color(0xFF2563EB),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SusQuestionnaireScreen()),
              ),
            ),
            const SizedBox(height: 14),

            // Card 2: Kuesioner NASA-TLX
            _buildQuestionnaireLauncherCard(
              context,
              title: 'Kuesioner NASA-TLX (Task Load Index)',
              badge: '6 Dimensi Beban Kerja',
              subtitle:
                  'Mengukur beban mental, fisik, tekanan waktu, performa, usaha, dan frustrasi saat menggunakan aplikasi.',
              icon: Icons.speed_rounded,
              buttonColor: const Color(0xFF1D4ED8),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NasaTlxQuestionnaireScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionnaireLauncherCard(
    BuildContext context, {
    required String title,
    required String badge,
    required String subtitle,
    required IconData icon,
    required Color buttonColor,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: buttonColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.font(
                        size: 13.5,
                        weight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badge,
                        style: AppTheme.font(
                          size: 10,
                          weight: FontWeight.w700,
                          color: buttonColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: AppTheme.font(
              size: 11.5,
              color: const Color(0xFF64748B),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: onTap,
              icon: const Icon(Icons.edit_document, size: 16),
              label: Text(
                'Buka $title',
                style: AppTheme.font(size: 12.5, weight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
