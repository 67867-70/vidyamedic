import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/health_models.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import '../input/symptom_input_screen.dart';

/// Mockup halaman 5 – Ringkasan input harian ("Ringkasan Hari Ini").
class DailySummaryScreen extends StatelessWidget {
  const DailySummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();

    final bp = s.measurement('bp').value;
    final temp = s.measurement('temp').value;
    final measureSummary = [
      if (bp != null) 'TD $bp',
      if (temp != null) 'Suhu $temp°C',
    ].join(', ');

    return MockupScaffold(
      title: 'Ringkasan Hari Ini',
      subtitle: DateLine(date: s.logDate, centered: true),
      trailing: TextButton.icon(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SymptomInputScreen()),
        ),
        icon: const Icon(Icons.edit_outlined, size: 15, color: AppTheme.primary),
        label: Text('Ubah', style: AppTheme.font(size: 12.5, weight: FontWeight.w600, color: AppTheme.primary)),
      ),
      body: Column(
        children: [
          _SummaryCard(
            rows: [
              _SummaryRowData(
                icon: Icons.groups_2_outlined,
                label: 'Perasaan',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaceBadge(expression: s.mood.face, color: s.mood.color, size: 18),
                    const SizedBox(width: 6),
                    Text(s.mood.label, style: AppTheme.font(size: 13, weight: FontWeight.w600)),
                  ],
                ),
              ),
              _SummaryRowData(
                icon: Icons.coronavirus_outlined,
                label: 'Gejala',
                trailing: Text(
                  s.symptoms.contains(kNoSymptom) ? 'Tidak ada gejala' : s.symptoms.join(', '),
                  style: AppTheme.font(
                    size: 13,
                    color: s.hasSymptoms ? AppTheme.faceRed : AppTheme.textPrimary,
                    weight: s.hasSymptoms ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              _SummaryRowData(
                icon: Icons.directions_run_outlined,
                label: 'Aktivitas',
                trailing: Text(s.activity, style: AppTheme.font(size: 13)),
              ),
              _SummaryRowData(
                icon: Icons.psychology_outlined,
                label: 'Stres',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaceBadge(expression: s.stress.face, color: s.stress.color, size: 18),
                    const SizedBox(width: 6),
                    Text(s.stress.label, style: AppTheme.font(size: 13, weight: FontWeight.w600)),
                  ],
                ),
              ),
              _SummaryRowData(
                icon: Icons.restaurant_outlined,
                label: 'Makan',
                trailing: Text(s.habitMeal ? 'Sudah makan' : 'Belum makan', style: AppTheme.font(size: 13)),
              ),
              _SummaryRowData(
                icon: Icons.medication_outlined,
                label: 'Minum obat',
                trailing: Text(s.habitMedication ? 'Ya' : 'Tidak', style: AppTheme.font(size: 13)),
              ),
              _SummaryRowData(
                icon: Icons.bedtime_outlined,
                label: 'Tidur (kemarin)',
                trailing: Text('${s.sleepShortLabel} (${s.sleepQuality.label})', style: AppTheme.font(size: 13)),
              ),
              _SummaryRowData(
                icon: Icons.thermostat_outlined,
                label: 'Pengukuran',
                trailing: Text(measureSummary.isEmpty ? '-' : measureSummary, style: AppTheme.font(size: 13)),
              ),
              _SummaryRowData(
                icon: Icons.description_outlined,
                label: 'Catatan',
                trailing: Text(s.note.isEmpty ? '-' : s.note,
                    maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTheme.font(size: 13)),
              ),
            ],
          ),
          const SizedBox(height: 14),
        ],
      ),
      bottom: ElevatedButton(
        onPressed: () {
          s.submitDaily();
          showSaved(context, 'Data harian berhasil dikonfirmasi dan dikirim ke analitik CAPAR');
        },
        child: const Text('✓ Konfirmasi & Kirim ke Analitik'),
      ),
    );
  }
}

class _SummaryRowData {
  final IconData icon;
  final String label;
  final Widget trailing;
  _SummaryRowData({required this.icon, required this.label, required this.trailing});
}

class _SummaryCard extends StatelessWidget {
  final List<_SummaryRowData> rows;
  const _SummaryCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: AppTheme.shadowSoft,
      ),
      child: Column(
        children: rows.asMap().entries.map((e) {
          final isLast = e.key == rows.length - 1;
          final r = e.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Icon(r.icon, size: 18, color: AppTheme.primaryDark),
                    const SizedBox(width: 10),
                    Text(r.label, style: AppTheme.font(size: 13, color: AppTheme.textSecondary)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: r.trailing,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(height: 1, indent: 42, endIndent: 14, color: AppTheme.borderLight),
            ],
          );
        }).toList(),
      ),
    );
  }
}
