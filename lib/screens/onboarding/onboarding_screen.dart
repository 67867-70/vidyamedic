import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/health_models.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import '../home/home_screen.dart';

/// Mockup halaman 3 – Profil Saya (1/4) → Riwayat Kesehatan (2/4)
/// → Hubungkan Wearable (3/4) → Preferensi Saya (4/4).
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _titles = ['Profil Saya', 'Riwayat Kesehatan', 'Hubungkan Wearable', 'Preferensi Saya'];
  int _step = 1;

  late final TextEditingController _name;
  late final TextEditingController _height;
  late final TextEditingController _weight;
  late final TextEditingController _otherCondition;
  late final TextEditingController _allergy;
  late DateTime _birth;
  late Gender _gender;
  late String _timeZone;
  String _device = 'Apple Watch';

  @override
  void initState() {
    super.initState();
    final s = context.read<AppState>();
    _name = TextEditingController(text: s.userProfile.name);
    _height = TextEditingController(text: s.userProfile.heightCm.toStringAsFixed(0));
    _weight = TextEditingController(text: s.userProfile.weightKg.toStringAsFixed(0));
    _otherCondition = TextEditingController(text: s.otherCondition);
    _allergy = TextEditingController(text: s.allergies);
    _birth = s.userProfile.birthDate;
    _gender = s.userProfile.gender;
    _timeZone = s.userProfile.timeZone;
  }

  @override
  void dispose() {
    for (final c in [_name, _height, _weight, _otherCondition, _allergy]) {
      c.dispose();
    }
    super.dispose();
  }

  void _back() => _step > 1 ? setState(() => _step--) : Navigator.pop(context);

  void _next() {
    final s = context.read<AppState>();
    switch (_step) {
      case 1:
        s.update(() {
          s.userProfile = UserProfile(
            name: _name.text.trim().isEmpty ? 'Pengguna' : _name.text.trim(),
            birthDate: _birth,
            gender: _gender,
            heightCm: double.tryParse(_height.text) ?? s.userProfile.heightCm,
            weightKg: double.tryParse(_weight.text) ?? s.userProfile.weightKg,
            timeZone: _timeZone,
          );
        });
      case 2:
        s.update(() {
          s.otherCondition = _otherCondition.text.trim();
          s.allergies = _allergy.text.trim();
        });
      case 3:
        s.connectWearable(_device);
        showSaved(context, '$_device berhasil terhubung');
      case 4:
        _finish();
        return;
    }
    setState(() => _step++);
  }

  void _finish() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _step == 1,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F9F8),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Container(
              color: Colors.white,
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  leading: IconButton(icon: const Icon(Icons.chevron_left_rounded, size: 30), onPressed: _back),
                  title: Text(_titles[_step - 1], style: AppTheme.font(size: 16, weight: FontWeight.w700)),
                ),
                body: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                        child: StepProgress(step: _step, total: 4),
                      ),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 280),
                          transitionBuilder: (child, a) => FadeTransition(
                            opacity: a,
                            child: SlideTransition(
                              position: Tween(begin: const Offset(0.06, 0), end: Offset.zero).animate(a),
                              child: child,
                            ),
                          ),
                          child: SingleChildScrollView(
                            key: ValueKey(_step),
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                            child: switch (_step) {
                              1 => _profile(),
                              2 => _health(),
                              3 => _wearable(),
                              _ => _preferences(),
                            },
                          ),
                        ),
                      ),
                      Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 16), child: _actions()),
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

  Widget _actions() {
    switch (_step) {
      case 2:
        return Row(children: [
          Expanded(child: OutlinedButton(onPressed: _back, child: const Text('Kembali'))),
          const SizedBox(width: 12),
          Expanded(child: ElevatedButton(onPressed: _next, child: const Text('Lanjut'))),
        ]);
      case 3:
        return ElevatedButton(onPressed: _next, child: const Text('Hubungkan'));
      case 4:
        return Column(mainAxisSize: MainAxisSize.min, children: [
          ElevatedButton(onPressed: _next, child: const Text('Selesai')),
          TextButton(
            onPressed: _finish,
            child: Text('Lewati dulu', style: AppTheme.font(size: 13, weight: FontWeight.w600, color: AppTheme.primary)),
          ),
        ]);
      default:
        return ElevatedButton(onPressed: _next, child: const Text('Lanjut'));
    }
  }

  // ---------------- 1/4 Profil Saya ----------------
  Widget _profile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Data dasar Anda membantu kami memahami kondisi tubuh dengan lebih baik.',
            style: AppTheme.font(size: 13, color: AppTheme.textSecondary, height: 1.4)),
        const FieldLabel('Nama Lengkap'),
        TextField(
          controller: _name,
          style: AppTheme.font(size: 14, weight: FontWeight.w500),
          decoration: const InputDecoration(
            hintText: 'Nama lengkap',
            fillColor: AppTheme.fieldFill,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
        ),
        const FieldLabel('Tanggal Lahir'),
        _PickerField(
          text: DateFormat('d MMM yyyy', 'id_ID').format(_birth),
          icon: Icons.calendar_month_outlined,
          onTap: () async {
            final d = await showDatePicker(
              context: context,
              initialDate: _birth,
              firstDate: DateTime(1920),
              lastDate: DateTime.now(),
            );
            if (d != null) setState(() => _birth = d);
          },
        ),
        const FieldLabel('Jenis Kelamin'),
        Row(children: [
          Expanded(child: _segment('Perempuan', Gender.female)),
          const SizedBox(width: 10),
          Expanded(child: _segment('Laki-laki', Gender.male)),
        ]),
        const FieldLabel('Tinggi Badan'),
        TextField(
          controller: _height,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(suffixText: 'cm'),
        ),
        const FieldLabel('Berat Badan'),
        TextField(
          controller: _weight,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(suffixText: 'kg'),
        ),
        const FieldLabel('Zona Waktu'),
        DropdownButtonFormField<String>(
          initialValue: _timeZone,
          icon: const Icon(Icons.expand_more_rounded),
          style: AppTheme.font(size: 14),
          items: const ['WIB (UTC+7)', 'WITA (UTC+8)', 'WIT (UTC+9)']
              .map((z) => DropdownMenuItem(value: z, child: Text(z)))
              .toList(),
          onChanged: (v) => setState(() => _timeZone = v ?? _timeZone),
        ),
      ],
    );
  }

  Widget _segment(String label, Gender g) {
    final sel = _gender == g;
    return GestureDetector(
      onTap: () => setState(() => _gender = g),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: sel ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: sel ? AppTheme.primary : AppTheme.border),
        ),
        child: Text(label,
            style: AppTheme.font(
                size: 14, weight: FontWeight.w600, color: sel ? Colors.white : AppTheme.textPrimary)),
      ),
    );
  }

  // ---------------- 2/4 Riwayat Kesehatan ----------------
  Widget _health() {
    final s = context.watch<AppState>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Apakah Anda memiliki kondisi kesehatan berikut?',
            style: AppTheme.font(size: 13.5, color: AppTheme.textSecondary, height: 1.4)),
        const SizedBox(height: 6),
        ...s.conditionOptions.map((c) => InkWell(
              onTap: () => s.toggleCondition(c),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(children: [
                  Checkbox(
                    value: s.medicalConditions.contains(c),
                    onChanged: (_) => s.toggleCondition(c),
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      c,
                      style: AppTheme.font(size: 13.5, height: 1.25),
                    ),
                  ),
                ]),
              ),
            )),
        const SizedBox(height: 6),
        TextField(
          controller: _otherCondition,
          decoration: const InputDecoration(hintText: 'Tulis kondisi lain...'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _allergy,
          decoration: const InputDecoration(hintText: 'Alergi (opsional)'),
        ),
        const SizedBox(height: 18),
        Row(children: [
          Expanded(child: Text('Obat Rutin', style: AppTheme.font(size: 14, weight: FontWeight.w700))),
          InkWell(
            onTap: () => _addMedication(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: AppTheme.primarySoft, borderRadius: BorderRadius.circular(20)),
              child: Text('+ Tambah Obat',
                  style: AppTheme.font(size: 12, weight: FontWeight.w600, color: AppTheme.primary)),
            ),
          ),
        ]),
        const SizedBox(height: 10),
        if (s.routineMedications.isEmpty)
          Text('Belum ada obat rutin.', style: AppTheme.font(size: 12.5, color: AppTheme.textMuted)),
        ...s.routineMedications.asMap().entries.map((e) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderLight),
                boxShadow: AppTheme.shadowSoft,
              ),
              child: Row(children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(color: const Color(0xFFFDECEC), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.medication, size: 18, color: AppTheme.faceRed),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${e.value.name} ${e.value.dosage}', style: AppTheme.font(size: 13, weight: FontWeight.w600)),
                    Text(e.value.frequency, style: AppTheme.font(size: 11.5, color: AppTheme.textSecondary)),
                  ]),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18, color: AppTheme.textSecondary),
                  onPressed: () => _addMedication(context, editIndex: e.key),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18, color: AppTheme.textSecondary),
                  onPressed: () => s.removeMedication(e.key),
                ),
              ]),
            )),
      ],
    );
  }

  void _addMedication(BuildContext context, {int? editIndex}) {
    final s = context.read<AppState>();
    final existing = editIndex != null ? s.routineMedications[editIndex] : null;
    final name = TextEditingController(text: existing?.name);
    final dose = TextEditingController(text: existing?.dosage);
    final freq = TextEditingController(text: existing?.frequency ?? '1x sehari (pagi)');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(existing == null ? 'Tambah Obat' : 'Ubah Obat',
                style: AppTheme.font(size: 17, weight: FontWeight.w700)),
            const FieldLabel('Nama obat'),
            TextField(controller: name, decoration: const InputDecoration(hintText: 'Contoh: Bisoprolol')),
            const FieldLabel('Dosis'),
            TextField(controller: dose, decoration: const InputDecoration(hintText: 'Contoh: 5 mg')),
            const FieldLabel('Aturan pakai'),
            TextField(controller: freq, decoration: const InputDecoration(hintText: 'Contoh: 1x sehari (pagi)')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (name.text.trim().isEmpty) return;
                final m = Medication(name: name.text.trim(), dosage: dose.text.trim(), frequency: freq.text.trim());
                if (editIndex != null) {
                  s.update(() => s.routineMedications[editIndex] = m);
                } else {
                  s.addMedication(m);
                }
                Navigator.pop(ctx);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- 3/4 Hubungkan Wearable ----------------
  Widget _wearable() {
    const devices = [
      ('Apple Watch', Icons.watch, true),
      ('Garmin', Icons.watch_outlined, false),
      ('Fitbit', Icons.fitbit, false),
      ('Other (Bluetooth)', Icons.bluetooth, false),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pilih perangkat yang ingin Anda hubungkan. Data akan tersinkron otomatis.',
            style: AppTheme.font(size: 13, color: AppTheme.textSecondary, height: 1.4)),
        const SizedBox(height: 14),
        ...devices.map((d) {
          final sel = _device == d.$1;
          final isBt = d.$2 == Icons.bluetooth;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: () => setState(() => _device = d.$1),
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: sel ? AppTheme.primarySoft : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: sel ? AppTheme.primaryLight : AppTheme.borderLight, width: sel ? 1.6 : 1),
                ),
                child: Row(children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: isBt ? const Color(0xFFE8F0FE) : const Color(0xFF1F2523),
                      borderRadius: BorderRadius.circular(isBt ? 23 : 12),
                    ),
                    child: Icon(d.$2, color: isBt ? const Color(0xFF2F80ED) : Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(d.$1, style: AppTheme.font(size: 14, weight: FontWeight.w600)),
                      if (d.$3)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(10)),
                          child: Text('Disarankan',
                              style: AppTheme.font(size: 9.5, weight: FontWeight.w600, color: Colors.white)),
                        ),
                    ]),
                  ),
                  Icon(sel ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: sel ? AppTheme.primary : AppTheme.textMuted, size: 22),
                ]),
              ),
            ),
          );
        }),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppTheme.primarySoft, borderRadius: BorderRadius.circular(12)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Data yang akan diambil:', style: AppTheme.font(size: 12.5, weight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: _Bullets(['Detak jantung (HR)', 'Aktivitas & langkah', 'Kualitas tidur'])),
              Expanded(child: _Bullets(['Variabilitas HR (RR)', 'SpO₂ (jika ada)', 'Suhu kulit (jika ada)'])),
            ]),
          ]),
        ),
      ],
    );
  }

  // ---------------- 4/4 Preferensi Saya ----------------
  Widget _preferences() {
    final s = context.watch<AppState>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tujuan utama menggunakan VidyaMedic', style: AppTheme.font(size: 14, weight: FontWeight.w700)),
        const SizedBox(height: 10),
        ...s.goalOptions.map((g) => RadioRow(
              label: g,
              selected: s.primaryGoal == g,
              onTap: () => s.update(() => s.primaryGoal = g),
            )),
        const SectionTitle('Waktu notifikasi'),
        ToggleRow(
          icon: Icons.event_available_outlined,
          label: 'Pagi (ringkasan harian)',
          sublabel: fmtTime(s.notifDailyTime),
          value: s.notifDailySummary,
          onChanged: (v) => s.update(() => s.notifDailySummary = v),
        ),
        ToggleRow(
          icon: Icons.notifications_none_rounded,
          label: 'Peringatan penting',
          value: s.notifCriticalAlerts,
          onChanged: (v) => s.update(() => s.notifCriticalAlerts = v),
        ),
        ToggleRow(
          icon: Icons.school_outlined,
          label: 'Edukasi kesehatan',
          value: s.notifHealthEducation,
          onChanged: (v) => s.update(() => s.notifHealthEducation = v),
        ),
        ToggleRow(
          icon: Icons.share_outlined,
          label: 'Izin berbagi data ke tenaga kesehatan',
          value: s.allowDataSharing,
          onChanged: (v) => s.update(() => s.allowDataSharing = v),
        ),
      ],
    );
  }
}

class _PickerField extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  const _PickerField({required this.text, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(children: [
          Expanded(child: Text(text, style: AppTheme.font(size: 14))),
          Icon(icon, size: 19, color: AppTheme.textSecondary),
        ]),
      ),
    );
  }
}

class _Bullets extends StatelessWidget {
  final List<String> items;
  const _Bullets(this.items);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text('•  $t', style: AppTheme.font(size: 11, color: AppTheme.textSecondary)),
              ))
          .toList(),
    );
  }
}
