import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/health_models.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';

/// Mockup halaman 5 – Catat event ("Tambah Event").
class EventMarkerScreen extends StatefulWidget {
  const EventMarkerScreen({super.key});

  @override
  State<EventMarkerScreen> createState() => _EventMarkerScreenState();
}

class _EventMarkerScreenState extends State<EventMarkerScreen> {
  String _selected = 'Mulai olahraga';

  void _save() {
    final s = context.read<AppState>();
    final chosen = kEvents.firstWhere((e) => e.$1 == _selected);
    s.addEvent(
      EventItem(
        title: chosen.$1,
        icon: chosen.$2,
        color: chosen.$3,
        timestamp: DateTime.now(),
      ),
    );
    showSaved(context, 'Event "${chosen.$1}" berhasil dicatat');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MockupScaffold(
      title: 'Tambah Event',
      body: Column(
        children: kEvents.map((e) {
          final sel = _selected == e.$1;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => setState(() => _selected = e.$1),
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: sel ? AppTheme.primarySoft : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: sel ? AppTheme.primaryLight : AppTheme.borderLight,
                    width: sel ? 1.6 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: e.$3.withValues(alpha: 0.13),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(e.$2, color: e.$3, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        e.$1,
                        style: AppTheme.font(
                          size: 14,
                          weight: sel ? FontWeight.w700 : FontWeight.w500,
                          color: sel ? AppTheme.primaryDark : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    if (sel)
                      const Icon(Icons.check_circle, color: AppTheme.primary, size: 20),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
      bottom: ElevatedButton(
        onPressed: _save,
        child: const Text('Simpan'),
      ),
    );
  }
}
