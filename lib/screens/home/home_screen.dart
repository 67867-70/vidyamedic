import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/health_models.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import 'pedagogy_detail_sheet.dart';
import '../pedagogy/pedagogy_screen_where_am_i.dart';
import '../pedagogy/pedagogy_screen_what_changed.dart';
import '../pedagogy/pedagogy_screen_why.dart';
import '../pedagogy/pedagogy_screen_recovery.dart';
import '../pedagogy/pedagogy_screen_action.dart';
import '../pedagogy/patient_journey_screen.dart';
import '../input/guided_daily_flow_screen.dart';
import '../input/symptom_input_screen.dart';
import '../input/activity_input_screen.dart';
import '../input/sleep_input_screen.dart';
import '../input/manual_measurement_screen.dart';
import '../input/event_marker_screen.dart';
import '../input/free_note_screen.dart';
import '../summary/daily_summary_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _PedagogyDashboard(onNavigateToInput: () => setState(() => _currentIndex = 1)),
      const _InputFlowTab(),
      const DailySummaryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9F8),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Container(
            color: AppTheme.background,
            child: Scaffold(
              body: pages[_currentIndex],
              bottomNavigationBar: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppTheme.borderLight, width: 1)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0A0B7A5A),
                      blurRadius: 16,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: NavigationBar(
                    selectedIndex: _currentIndex,
                    onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
                    backgroundColor: Colors.white,
                    indicatorColor: AppTheme.primarySoft,
                    elevation: 0,
                    height: 65,
                    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                    destinations: const [
                      NavigationDestination(
                        icon: Icon(Icons.favorite_border_rounded, size: 22),
                        selectedIcon: Icon(Icons.favorite_rounded, color: AppTheme.primary, size: 23),
                        label: 'Home',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.edit_note_outlined, size: 24),
                        selectedIcon: Icon(Icons.edit_note_rounded, color: AppTheme.primary, size: 25),
                        label: 'Input',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.assessment_outlined, size: 22),
                        selectedIcon: Icon(Icons.assessment_rounded, color: AppTheme.primary, size: 23),
                        label: 'Ringkasan',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.person_outline_rounded, size: 22),
                        selectedIcon: Icon(Icons.person_rounded, color: AppTheme.primary, size: 23),
                        label: 'Profil',
                      ),
                    ],
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

// ---------------------------------------------------------------------------
// Tab 0: Dashboard Utama (Pedagogi Kesehatan, Sensor Realtime, CAPAR)
// ---------------------------------------------------------------------------
class _PedagogyDashboard extends StatelessWidget {
  final VoidCallback onNavigateToInput;
  const _PedagogyDashboard({required this.onNavigateToInput});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final triage = s.triageLevel;
    final w = s.wearable;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'VidyaMedic',
                  style: AppTheme.font(size: 18.5, weight: FontWeight.w800, color: AppTheme.primaryDark, letterSpacing: -0.3),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primarySoft,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('AI Health',
                      style: AppTheme.font(size: 9.5, weight: FontWeight.w800, color: AppTheme.primaryDark)),
                ),
              ],
            ),
            const SizedBox(height: 1),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const PulsingStatusDot(size: 6, color: AppTheme.statusGreen),
                const SizedBox(width: 5),
                Text('Sensor Aktif • ${w.deviceName}',
                    style: AppTheme.font(size: 11, color: AppTheme.textSecondary, weight: FontWeight.w500)),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              color: AppTheme.primarySoft,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.sync_rounded, color: AppTheme.primary, size: 20),
              tooltip: 'Sinkronkan Sensor',
              onPressed: () {
                s.syncWearable();
                showSaved(context, 'Sensor wearable berhasil disinkronkan');
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. User Greeting & Date Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderLight),
                boxShadow: AppTheme.shadowSoft,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              s.userProfile.name.isNotEmpty ? s.userProfile.name.substring(0, 1).toUpperCase() : 'U',
                              style: AppTheme.font(size: 14.5, weight: FontWeight.w800, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Halo, ${s.userProfile.name} 👋',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTheme.font(size: 13.5, weight: FontWeight.w800, color: AppTheme.textPrimary),
                              ),
                              DateLine(date: s.logDate),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.statusGreenBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.statusGreen.withValues(alpha: 0.35)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const PulsingStatusDot(size: 6, color: AppTheme.statusGreen),
                        const SizedBox(width: 5),
                        Text('Live BLE',
                            style: AppTheme.font(size: 10.5, weight: FontWeight.w700, color: AppTheme.statusGreen)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // 2. Continuous Sensing Hero Card (Smartwatch + Live Vitals)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppTheme.heroGradient,
                borderRadius: BorderRadius.circular(22),
                boxShadow: AppTheme.shadowCard,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      WatchFace(
                        width: 96,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              fmtTime(TimeOfDay.fromDateTime(w.lastSync)),
                              style: AppTheme.font(size: 9, color: Colors.white70, height: 1.1),
                            ),
                            const SizedBox(height: 1),
                            const Icon(Icons.favorite, size: 12, color: AppTheme.faceRed),
                            Text(
                              '${w.heartRate}',
                              style: AppTheme.font(size: 16.5, weight: FontWeight.w800, color: Colors.white, height: 1.1),
                            ),
                            Text('bpm', style: AppTheme.font(size: 7.5, color: Colors.white70, height: 1.0)),
                            const SizedBox(height: 2),
                            const PulseLine(color: AppTheme.accentMint, height: 10),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    w.deviceName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTheme.font(size: 15, weight: FontWeight.w800, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.battery_charging_full_rounded, color: AppTheme.accentMint, size: 12),
                                      const SizedBox(width: 2),
                                      Text('${w.batteryPercent}%', style: AppTheme.font(size: 9.5, color: Colors.white, weight: FontWeight.w700)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Text('Tersinkron: ${fmtTime(TimeOfDay.fromDateTime(w.lastSync))}',
                                style: AppTheme.font(size: 11, color: Colors.white70)),
                            const SizedBox(height: 10),
                            _metricRow('Detak Jantung (HR)', '${w.heartRate} bpm'),
                            _metricRow('Variabilitas HR (RMSSD)', '${w.hrvRmssd} ms'),
                            _metricRow('Aktivitas Harian', '${w.steps} lk'),
                            _metricRow('Saturasi SpO₂ Nokturnal', '${w.spO2}%'),
                            _metricRow('Suhu Kulit Basal', '${w.skinTemp}°C'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // 3. Quick Recovery & Readiness Score Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.borderLight),
                boxShadow: AppTheme.shadowSoft,
              ),
              child: Row(
                children: [
                  const CircularScoreGauge(
                    score: 82,
                    size: 82,
                    subtitle: 'Prima',
                    primaryColor: AppTheme.accent,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Indeks Kesiapan & Pemulihan',
                            style: AppTheme.font(size: 13.5, weight: FontWeight.w800, color: AppTheme.textPrimary)),
                        const SizedBox(height: 3),
                        Text(
                          'Sistem otonom stabil. Tubuh siap untuk aktivitas harian normal.',
                          style: AppTheme.font(size: 11, color: AppTheme.textSecondary, height: 1.3),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: AppTheme.primarySoft,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text('Baseline Normal',
                                  style: AppTheme.font(size: 9.5, weight: FontWeight.w700, color: AppTheme.primaryDark)),
                            ),
                            Text('HRV +4 ms • D(t) Stabil',
                                style: AppTheme.font(size: 10, color: AppTheme.textMuted, weight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // 4. Quick Daily Action Shortcuts
            Row(
              children: [
                Expanded(
                  child: _quickShortcutTile(
                    context,
                    label: 'Gejala',
                    icon: Icons.sick_outlined,
                    color: AppTheme.faceGreen,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SymptomInputScreen())),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _quickShortcutTile(
                    context,
                    label: 'Aktivitas',
                    icon: Icons.directions_run_rounded,
                    color: const Color(0xFF0284C7),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ActivityInputScreen())),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _quickShortcutTile(
                    context,
                    label: 'Tidur',
                    icon: Icons.bedtime_outlined,
                    color: const Color(0xFF7C5CDB),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SleepInputScreen())),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _quickShortcutTile(
                    context,
                    label: 'Event',
                    icon: Icons.bookmark_add_outlined,
                    color: const Color(0xFFD97706),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EventMarkerScreen())),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // 5. Action Engine Banner (Triage Protocol - Mockup Halaman 9)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: triage.bgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: triage.color.withValues(alpha: 0.35), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: triage.color,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: triage.color.withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Text(
                          triage.code,
                          style: AppTheme.font(size: 11, weight: FontWeight.w800, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          triage.title,
                          style: AppTheme.font(size: 14, weight: FontWeight.w700, color: AppTheme.textPrimary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    triage.description,
                    style: AppTheme.font(size: 12.5, color: AppTheme.textSecondary, height: 1.35),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ActionGuidanceScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: triage.color.withValues(alpha: 0.25)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Lihat Panduan Tindakan Lengkap',
                              style: AppTheme.font(size: 12, weight: FontWeight.w700, color: triage.color)),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, size: 14, color: triage.color),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // 6. Card: Patient Journey Simulation (Mockup Halaman 15)
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PatientJourneyScreen()),
              ),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF064E3B), Color(0xFF0F766E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppTheme.shadowCard,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), shape: BoxShape.circle),
                      child: const Icon(Icons.timeline_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Simulasi Patient Journey (1x24 Jam)',
                              style: AppTheme.font(size: 13.5, weight: FontWeight.w800, color: Colors.white)),
                          const SizedBox(height: 2),
                          Text('Alur temporal: Baseline → Deviasi → Recovery',
                              style: AppTheme.font(size: 11.5, color: Colors.white70)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 15),
                  ],
                ),
              ),
            ),

            const SectionTitle('Enam Pertanyaan Pedagogi Kesehatan (CAPAR)',
                padding: EdgeInsets.only(top: 22, bottom: 12)),

            // 7. The 6 CAPAR Pedagogical Framework Tiles
            ...s.pedagogyAnswers.map((p) => _PedagogyTile(item: p)),
          ],
        ),
      ),
    );
  }

  Widget _metricRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '✓ $label',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.font(size: 10.5, color: Colors.white70),
            ),
          ),
          const SizedBox(width: 4),
          Text(val, style: AppTheme.font(size: 10.5, weight: FontWeight.w700, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _quickShortcutTile(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.borderLight),
          boxShadow: AppTheme.shadowSoft,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 17, color: color),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.font(size: 11, weight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class _PedagogyTile extends StatelessWidget {
  final PedagogyAnswer item;
  const _PedagogyTile({required this.item});

  void _openScreen(BuildContext context) {
    Widget target;
    switch (item.number) {
      case 1:
        target = const WhereAmIScreen();
      case 2:
        target = const WhatChangedScreen();
      case 3:
        target = const WhyScreen();
      case 4:
      case 5:
        target = const RecoveryScreen();
      case 6:
      default:
        target = const ActionGuidanceScreen();
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => target));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: AppTheme.shadowSoft,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openScreen(context),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primarySoft,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primaryLight.withValues(alpha: 0.3)),
                  ),
                  child: Center(
                    child: Text(
                      '${item.number}',
                      style: AppTheme.font(size: 13.5, weight: FontWeight.w800, color: AppTheme.primaryDark),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.question,
                              style: AppTheme.font(size: 14, weight: FontWeight.w700),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: item.statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.status,
                              style: AppTheme.font(size: 10.5, weight: FontWeight.w700, color: item.statusColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.summary,
                        style: AppTheme.font(size: 12.5, color: AppTheme.textSecondary, height: 1.3),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Buka Analisis Detail',
                                  style: AppTheme.font(size: 11.5, weight: FontWeight.w700, color: AppTheme.primary)),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward, size: 12, color: AppTheme.primary),
                            ],
                          ),
                          InkWell(
                            onTap: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => PedagogyDetailSheet(answer: item),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.info_outline, size: 13, color: AppTheme.textMuted),
                                  const SizedBox(width: 3),
                                  Text('Info Algoritma',
                                      style: AppTheme.font(size: 10.5, color: AppTheme.textMuted)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 1: Peta Lengkap Input Mobile (Mockup Halaman 2, 4, 5)
// ---------------------------------------------------------------------------
class _InputFlowTab extends StatelessWidget {
  const _InputFlowTab();

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Alur Input Harian', style: AppTheme.font(size: 17, weight: FontWeight.w800, color: AppTheme.primaryDark)),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 32),
        children: [
          // Banner for Guided Wizard
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryDark, AppTheme.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: AppTheme.shadowCard,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.playlist_play_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alur Input Harian Terpadu',
                            style: AppTheme.font(size: 15, weight: FontWeight.w800, color: Colors.white),
                          ),
                          Text(
                            'Langkah 5 s/d 11 secara berurutan',
                            style: AppTheme.font(size: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaryDark,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GuidedDailyFlowScreen(initialStep: 5)),
                    ),
                    child: Text(
                      'Mulai Input Harian (Langkah 5 - 11) →',
                      style: AppTheme.font(size: 13, weight: FontWeight.w800, color: AppTheme.primaryDark),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text('Atau buka langkah tertentu secara langsung:',
              style: AppTheme.font(size: 12.5, color: AppTheme.textSecondary, weight: FontWeight.w700)),
          const SizedBox(height: 10),

          _FlowStepCard(
            stepNumber: 5,
            title: 'Konteks Aktivitas & Gaya Hidup',
            desc: 'Aktivitas: ${s.activity} • Stres: ${s.stress.label}',
            icon: Icons.directions_run_outlined,
            color: const Color(0xFF0284C7),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ActivityInputScreen())),
          ),
          _FlowStepCard(
            stepNumber: 6,
            title: 'Gejala & Perasaan (Catat Hari Ini)',
            desc: 'Perasaan: ${s.mood.label} • Gejala: ${s.symptoms.join(", ")}',
            icon: Icons.groups_2_outlined,
            color: AppTheme.faceGreen,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SymptomInputScreen())),
          ),
          _FlowStepCard(
            stepNumber: 7,
            title: 'Input Tidur (Tidur Malam Ini)',
            desc: '${s.sleepDurationLabel} (${s.sleepQuality.label})',
            icon: Icons.bedtime_outlined,
            color: const Color(0xFF7C5CDB),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SleepInputScreen())),
          ),
          _FlowStepCard(
            stepNumber: 8,
            title: 'Pengukuran Manual (Opsional)',
            desc: 'TD, Suhu, Berat, SpO₂, Glukosa',
            icon: Icons.speed_outlined,
            color: const Color(0xFF059669),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManualMeasurementScreen())),
          ),
          _FlowStepCard(
            stepNumber: 9,
            title: 'Catat Event Marker',
            desc: '${s.events.length} event tercatat',
            icon: Icons.bookmark_add_outlined,
            color: const Color(0xFFD97706),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EventMarkerScreen())),
          ),
          _FlowStepCard(
            stepNumber: 10,
            title: 'Input Catatan Bebas (Catatan Saya)',
            desc: s.note.isEmpty ? 'Belum ada catatan' : s.note,
            icon: Icons.edit_note_outlined,
            color: const Color(0xFF64748B),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FreeNoteScreen())),
          ),
          _FlowStepCard(
            stepNumber: 11,
            title: 'Ringkasan Input Harian',
            desc: 'Konfirmasi sebelum data dikirim ke pipeline analitik',
            icon: Icons.assignment_turned_in_outlined,
            color: AppTheme.primary,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DailySummaryScreen())),
          ),
        ],
      ),
    );
  }
}

class _FlowStepCard extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String desc;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FlowStepCard({
    required this.stepNumber,
    required this.title,
    required this.desc,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: AppTheme.shadowSoft,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      '$stepNumber',
                      style: AppTheme.font(size: 13, weight: FontWeight.w800, color: color),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTheme.font(size: 13.5, weight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(desc,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.font(size: 11.5, color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, size: 18, color: AppTheme.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
