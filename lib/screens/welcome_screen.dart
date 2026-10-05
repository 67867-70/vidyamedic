import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_widgets.dart';
import 'onboarding/onboarding_screen.dart';
import 'home/home_screen.dart';

/// Mockup halaman 2, layar 1 – cover / registrasi awal.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9F8),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Container(
              color: Colors.white,
              child: LayoutBuilder(
                builder: (context, c) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: c.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 12),
                              const _Logo(),
                              const SizedBox(height: 10),
                              Text(
                                'VidyaMedic',
                                style: AppTheme.font(
                                  size: 28,
                                  weight: FontWeight.w800,
                                  color: AppTheme.primaryDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Kenali tubuhmu,\njalani hari dengan lebih aman',
                                textAlign: TextAlign.center,
                                style: AppTheme.font(
                                  size: 13.5,
                                  color: AppTheme.textSecondary,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const _WelcomeHeroCard(),
                            ],
                          ),
                          Column(
                            children: [
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                                ),
                                child: const Text('Daftar Akun'),
                              ),
                              const SizedBox(height: 10),
                              TonalButton(
                                label: 'Masuk',
                                onPressed: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                                ),
                              ),
                              const SizedBox(height: 22),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _Pillar(Icons.eco_outlined, 'Pantau\nSehari-hari', Color(0xFF22B573)),
                                  _Pillar(Icons.groups_2_outlined, 'Pahami\nPerubahan', Color(0xFF2F9E8F)),
                                  _Pillar(Icons.favorite_outline, 'Ambil Langkah\nTepat', Color(0xFFF2B630)),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 58,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ShaderMask(
            shaderCallback: (r) => const LinearGradient(
              colors: [AppTheme.primaryLight, AppTheme.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(r),
            child: const Icon(Icons.favorite, size: 64, color: Colors.white),
          ),
          const Positioned(
            top: 18,
            child: Icon(Icons.monitor_heart_outlined, size: 26, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _Pillar extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Pillar(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.14), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 6),
        Text(label,
            textAlign: TextAlign.center,
            style: AppTheme.font(size: 11, weight: FontWeight.w500, color: AppTheme.textSecondary, height: 1.25)),
      ],
    );
  }
}

class _WelcomeHeroCard extends StatelessWidget {
  const _WelcomeHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF064E3B), Color(0xFF0B7A5A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.shadowCard,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.directions_run_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Integrasi Smartwatch',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.font(size: 13.5, weight: FontWeight.w700, color: Colors.white),
                          ),
                          Text(
                            'Real-time Continuous Sync',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.font(size: 11, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.accentMint.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Aktif',
                    style: AppTheme.font(size: 10.5, weight: FontWeight.w800, color: AppTheme.accentMint)),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Mini metrics
          Row(
            children: [
              Expanded(
                child: _heroMetric(Icons.favorite, '72 bpm', 'Detak Jantung', AppTheme.faceRed),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _heroMetric(Icons.bedtime, '7.5 jam', 'Kualitas Tidur', const Color(0xFF818CF8)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _heroMetric(Icons.directions_walk, '6.240', 'Langkah Hari Ini', AppTheme.accentMint),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const PulseLine(color: AppTheme.accentMint),
        ],
      ),
    );
  }

  Widget _heroMetric(IconData icon, String val, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 4),
          Text(val, style: AppTheme.font(size: 13, weight: FontWeight.w800, color: Colors.white)),
          Text(label, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: AppTheme.font(size: 9, color: Colors.white70)),
        ],
      ),
    );
  }
}
