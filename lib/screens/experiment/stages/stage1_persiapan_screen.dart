import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../profile/wearable_pairing_screen.dart';
import '../widgets/experiment_widgets.dart';

/// Layar Tahap 1: Persiapan Pemantauan
/// Mendukung interaksi lengkap untuk:
/// 1. Sambung Polar (Wearable terhubung)
/// 2. Pop-up Sinyal Sensor Real-time
/// 3. Input 5 Tanda Vital (SpO2, TD, Suhu, RR, GDS/Nadi)
/// 4. Formulir Pernyataan Persetujuan & Privasi Penelitian (Informed Consent + Checkbox)
class Stage1PersiapanScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final VoidCallback? onStageSelect;

  const Stage1PersiapanScreen({
    super.key,
    required this.onNext,
    this.onBack,
    this.onStageSelect,
  });

  @override
  State<Stage1PersiapanScreen> createState() => _Stage1PersiapanScreenState();
}

class _Stage1PersiapanScreenState extends State<Stage1PersiapanScreen> {
  // Status 4 Elemen Persiapan
  bool _isPolarConnected = true;
  final String _polarDeviceName = 'Polar H10 88921A';
  final int _polarBattery = 88;

  bool _isSensorSignalChecked = true;
  final int _signalQualityPercent = 96;

  bool _isVitalSignsFilled = false;
  String _valSpO2 = '98';
  String _valBloodPressure = '120/80';
  String _valTemperature = '36.5';
  String _valRespirationRate = '16';
  String _valBloodGlucose = '105';

  bool _isConsentAgreed = true;

  int get _readyCount {
    int count = 0;
    if (_isPolarConnected) count++;
    if (_isSensorSignalChecked) count++;
    if (_isVitalSignsFilled) count++;
    if (_isConsentAgreed) count++;
    return count;
  }

  // ---------------------------------------------------------------------------
  // 1. MODAL SHEET: SAMBUNG POLAR (HITAM)
  // ---------------------------------------------------------------------------
  void _showConnectPolarSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              14,
              20,
              MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
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
                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE2F5EF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.watch_rounded, size: 20, color: Color(0xFF007A64)),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Koneksi Sensor Polar (BLE)',
                          style: AppTheme.font(
                            size: 16,
                            weight: FontWeight.w800,
                            color: const Color(0xFF0F2B3C),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.pop(sheetCtx),
                    ),
                  ],
                ),
                const Divider(height: 20, color: Color(0xFFEDF3F1)),

                // Kartu Status Perangkat Polar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isPolarConnected ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isPolarConnected ? const Color(0xFF86EFAC) : const Color(0xFFFECACA),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _isPolarConnected ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isPolarConnected ? Icons.bluetooth_connected_rounded : Icons.bluetooth_disabled_rounded,
                          color: _isPolarConnected ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isPolarConnected ? _polarDeviceName : 'Polar Belum Terhubung',
                              style: AppTheme.font(
                                size: 14,
                                weight: FontWeight.w800,
                                color: const Color(0xFF0F2B3C),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _isPolarConnected
                                  ? 'Baterai $_polarBattery% • Detak Jantung: 74 BPM (Aktif)'
                                  : 'Aktifkan Bluetooth & basahi strap elektroda dada',
                              style: AppTheme.font(
                                size: 11.5,
                                color: _isPolarConnected ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isPolarConnected,
                        activeTrackColor: const Color(0xFF007A64),
                        onChanged: (val) {
                          setSheetState(() => _isPolarConnected = val);
                          setState(() => _isPolarConnected = val);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                Text(
                  'Perangkat Polar Tersedia:',
                  style: AppTheme.font(size: 12.5, weight: FontWeight.w700, color: const Color(0xFF334155)),
                ),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2EBE9)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite_rounded, color: Color(0xFFE11D48), size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Polar H10 (Chest Strap)',
                              style: AppTheme.font(size: 13, weight: FontWeight.w700),
                            ),
                            Text(
                              'ID: 88921A • Standar EKG Penelitian',
                              style: AppTheme.font(size: 11, color: const Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2F5EF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Tersambung',
                          style: AppTheme.font(
                            size: 10.5,
                            weight: FontWeight.w700,
                            color: const Color(0xFF007A64),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Tombol Buka Pairing Lengkap
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(sheetCtx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WearablePairingScreen()),
                      );
                    },
                    icon: const Icon(Icons.settings_bluetooth_rounded, size: 18),
                    label: const Text('Buka Layar Pindai & Pairing Polar Lengkap'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF007A64),
                      side: const BorderSide(color: Color(0xFF007A64)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Tombol Simpan & Tutup
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _isPolarConnected = true);
                      Navigator.pop(sheetCtx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✅ Polar H10 terkonfirmasi siap untuk pemantauan.'),
                          backgroundColor: Color(0xFF007A64),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007A64),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Simpan & Konfirmasi Polar Siap'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. POP-UP SINYAL SENSOR (MERAH)
  // ---------------------------------------------------------------------------
  void _showSensorSignalPopup() {
    showDialog(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        contentPadding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: const BoxDecoration(
                color: Color(0xFFE2F5EF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.sensors_rounded, color: Color(0xFF007A64), size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status Sinyal Sensor',
                    style: AppTheme.font(size: 16, weight: FontWeight.w800, color: const Color(0xFF0F2B3C)),
                  ),
                  Text(
                    'Polar H10 Live Telemetri',
                    style: AppTheme.font(size: 11, color: const Color(0xFF708781), weight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indikator Indeks Kualitas Sinyal
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF86EFAC)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Indeks Kualitas Sinyal (SQI)',
                        style: AppTheme.font(size: 12, weight: FontWeight.w700, color: const Color(0xFF166534)),
                      ),
                      Text(
                        '$_signalQualityPercent% (Sangat Baik)',
                        style: AppTheme.font(size: 12, weight: FontWeight.w800, color: const Color(0xFF16A34A)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: _signalQualityPercent / 100,
                      minHeight: 8,
                      backgroundColor: const Color(0xFFDCFCE7),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF16A34A)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Rincian Sensor
            _buildSignalMetricRow('💓 Detak Jantung', '74 BPM (Sinus Reguler)'),
            const Divider(height: 14, color: Color(0xFFF1F5F4)),
            _buildSignalMetricRow('🧲 Kontak Elektroda (Lead)', 'Menempel Baik (Impedansi Rendah)'),
            const Divider(height: 14, color: Color(0xFFF1F5F4)),
            _buildSignalMetricRow('🏃 Gerak / Artefak', 'Stabil / Diam (Variasi 0.02g)'),
            const Divider(height: 14, color: Color(0xFFF1F5F4)),
            _buildSignalMetricRow('📊 Akselerometer 3-Sumbu', 'X: 0.02g • Y: 0.98g • Z: 0.12g'),
            const Divider(height: 14, color: Color(0xFFF1F5F4)),
            _buildSignalMetricRow('📶 Kecepatan Paket BLE', '130 paket/dtk • Packet Loss: 0%'),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() => _isSensorSignalChecked = true);
                Navigator.pop(dlgCtx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007A64),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Tutup & Sinyal Terverifikasi'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignalMetricRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTheme.font(size: 11.5, color: const Color(0xFF64748B), weight: FontWeight.w600)),
        Text(value, style: AppTheme.font(size: 11.5, color: const Color(0xFF0F172A), weight: FontWeight.w700)),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 3. PENGISIAN 5 TANDA VITAL (IJO)
  // ---------------------------------------------------------------------------
  void _showVitalSignsSheet() {
    final spo2Ctrl = TextEditingController(text: _valSpO2);
    final bpCtrl = TextEditingController(text: _valBloodPressure);
    final tempCtrl = TextEditingController(text: _valTemperature);
    final rrCtrl = TextEditingController(text: _valRespirationRate);
    final bgCtrl = TextEditingController(text: _valBloodGlucose);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          14,
          20,
          MediaQuery.of(sheetCtx).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
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
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE2F5EF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.monitor_heart_rounded, size: 20, color: Color(0xFF007A64)),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pengisian 5 Tanda Vital',
                            style: AppTheme.font(
                              size: 16,
                              weight: FontWeight.w800,
                              color: const Color(0xFF0F2B3C),
                            ),
                          ),
                          Text(
                            'Kondisi fisiologis awal sebelum sesi dimulai',
                            style: AppTheme.font(size: 11, color: const Color(0xFF708781)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.pop(sheetCtx),
                  ),
                ],
              ),
              const Divider(height: 20, color: Color(0xFFEDF3F1)),

              // 1. SpO2
              _buildVitalInputField(
                label: '1. Kadar Oksigen Darah (SpO₂)',
                hint: 'Contoh: 98',
                unit: '%',
                reference: 'Normal: 95% – 100%',
                controller: spo2Ctrl,
                icon: Icons.air_rounded,
                iconColor: const Color(0xFF0284C7),
              ),

              // 2. Tekanan Darah
              _buildVitalInputField(
                label: '2. Tekanan Darah (Sistolik / Diastolik)',
                hint: 'Contoh: 120/80',
                unit: 'mmHg',
                reference: 'Normal: 90/60 – 120/80 mmHg',
                controller: bpCtrl,
                icon: Icons.favorite_outline_rounded,
                iconColor: const Color(0xFFE11D48),
              ),

              // 3. Suhu Tubuh
              _buildVitalInputField(
                label: '3. Suhu Tubuh',
                hint: 'Contoh: 36.5',
                unit: '°C',
                reference: 'Normal: 36.1°C – 37.2°C',
                controller: tempCtrl,
                icon: Icons.thermostat_rounded,
                iconColor: const Color(0xFFEA580C),
              ),

              // 4. Laju Pernapasan (RR)
              _buildVitalInputField(
                label: '4. Laju Pernapasan (Respiratory Rate)',
                hint: 'Contoh: 16',
                unit: 'x/menit',
                reference: 'Normal dewasa istirahat: 12 – 20 x/menit',
                controller: rrCtrl,
                icon: Icons.waves_rounded,
                iconColor: const Color(0xFF0D9488),
              ),

              // 5. Gula Darah / Denyut Nadi Istirahat
              _buildVitalInputField(
                label: '5. Gula Darah Sewaktu (GDS) / Nadi Awal',
                hint: 'Contoh: 105',
                unit: 'mg/dL',
                reference: 'Normal sewaktu: < 140 mg/dL',
                controller: bgCtrl,
                icon: Icons.water_drop_outlined,
                iconColor: const Color(0xFF7C3AED),
              ),

              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _valSpO2 = spo2Ctrl.text.trim().isEmpty ? '98' : spo2Ctrl.text.trim();
                      _valBloodPressure = bpCtrl.text.trim().isEmpty ? '120/80' : bpCtrl.text.trim();
                      _valTemperature = tempCtrl.text.trim().isEmpty ? '36.5' : tempCtrl.text.trim();
                      _valRespirationRate = rrCtrl.text.trim().isEmpty ? '16' : rrCtrl.text.trim();
                      _valBloodGlucose = bgCtrl.text.trim().isEmpty ? '105' : bgCtrl.text.trim();
                      _isVitalSignsFilled = true;
                    });
                    Navigator.pop(sheetCtx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ 5 Tanda Vital awal berhasil disimpan ke profil sesi.'),
                        backgroundColor: Color(0xFF007A64),
                      ),
                    );
                  },
                  icon: const Icon(Icons.check_circle_rounded, size: 18),
                  label: const Text('Simpan 5 Tanda Vital'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007A64),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVitalInputField({
    required String label,
    required String hint,
    required String unit,
    required String reference,
    required TextEditingController controller,
    required IconData icon,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 15, color: iconColor),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: AppTheme.font(size: 12, weight: FontWeight.w700, color: const Color(0xFF1E293B)),
                  ),
                ],
              ),
              Text(
                reference,
                style: AppTheme.font(size: 10, color: const Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            style: AppTheme.font(size: 13, weight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: hint,
              suffixText: unit,
              suffixStyle: AppTheme.font(size: 12, weight: FontWeight.w700, color: const Color(0xFF007A64)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFCBD8D5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF007A64), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 4. PERSETUJUAN & PRIVASI (INFORMED CONSENT DENGAN CHECKBOX)
  // ---------------------------------------------------------------------------
  void _showConsentSheet() {
    bool tempAgree = _isConsentAgreed;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              14,
              20,
              MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
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
                  const SizedBox(height: 14),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEDE9FE),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.verified_user_outlined, size: 20, color: Color(0xFF7C3AED)),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Persetujuan & Privasi Penelitian',
                            style: AppTheme.font(
                              size: 16,
                              weight: FontWeight.w800,
                              color: const Color(0xFF0F2B3C),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.pop(sheetCtx),
                      ),
                    ],
                  ),
                  const Divider(height: 20, color: Color(0xFFEDF3F1)),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pernyataan Kesediaan Subjek Penelitian:',
                          style: AppTheme.font(
                            size: 13,
                            weight: FontWeight.w800,
                            color: const Color(0xFF0F2B3C),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Butir 1
                        _buildConsentPoint(
                          '1. Saya menyatakan bahwa saya telah membaca/mendapat penjelasan.',
                        ),
                        // Butir 2
                        _buildConsentPoint(
                          '2. Saya telah diberikan kesempatan untuk bertanya dan semua pertanyaan saya telah dijawab dengan jelas.',
                        ),
                        // Butir 3
                        _buildConsentPoint(
                          '3. Saya memahami bahwa penelitian menggunakan wearable, aplikasi Android, data aktivitas/postur, protocol marker, dan EMA; sistem yang diteliti bukan alat diagnosis.',
                        ),
                        // Butir 4
                        _buildConsentPoint(
                          '4. Saya memahami risiko dan ketidaknyamanan yang mungkin terjadi serta hak saya untuk berhenti kapan saja tanpa konsekuensi.',
                        ),
                        // Butir 5
                        _buildConsentPoint(
                          '5. Dengan ini saya menyatakan bersedia untuk berpartisipasi secara sukarela sebagai subjek dalam penelitian ini.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // CHECKBOX SETUJU
                  Container(
                    decoration: BoxDecoration(
                      color: tempAgree ? const Color(0xFFF0FDF4) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: tempAgree ? const Color(0xFF86EFAC) : const Color(0xFFCBD8D5),
                      ),
                    ),
                    child: CheckboxListTile(
                      value: tempAgree,
                      activeColor: const Color(0xFF007A64),
                      title: Text(
                        'Saya setuju dan menyatakan kesediaan berpartisipasi secara sukarela.',
                        style: AppTheme.font(
                          size: 12.5,
                          weight: FontWeight.w700,
                          color: tempAgree ? const Color(0xFF166534) : const Color(0xFF0F2B3C),
                        ),
                      ),
                      subtitle: Text(
                        'Centang kotak di atas sebagai tanda konfirmasi persetujuan etis penelitian.',
                        style: AppTheme.font(size: 11, color: const Color(0xFF64748B)),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      onChanged: (val) {
                        setSheetState(() => tempAgree = val ?? false);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: !tempAgree
                          ? null
                          : () {
                              setState(() {
                                _isConsentAgreed = true;
                              });
                              Navigator.pop(sheetCtx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('✅ Surat persetujuan subjek penelitian berhasil dikonfirmasi.'),
                                  backgroundColor: Color(0xFF007A64),
                                ),
                              );
                            },
                      icon: const Icon(Icons.verified_rounded, size: 18),
                      label: const Text('Konfirmasi & Simpan Persetujuan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007A64),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildConsentPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline_rounded, size: 15, color: Color(0xFF007A64)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTheme.font(
                size: 12,
                color: const Color(0xFF334155),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF9),
      appBar: ExperimentAppBar(
        stageNumber: 1,
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
              title: 'Persiapan pemantauan',
              subtitle: 'Siapkan perangkat, profil awal, dan izin pengukuran.',
            ),

            // Card 1: Status Persiapan (Dengan 4 Pemicu Sesuai Permintaan Pengguna)
            ExperimentCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status persiapan',
                        style: AppTheme.font(
                          size: 14.5,
                          weight: FontWeight.w800,
                          color: const Color(0xFF0F2B3C),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _readyCount == 4 ? const Color(0xFFE2F5EF) : const Color(0xFFFEF3E2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$_readyCount dari 4 siap',
                          style: AppTheme.font(
                            size: 11.5,
                            weight: FontWeight.w800,
                            color: _readyCount == 4 ? const Color(0xFF007A64) : const Color(0xFFD97706),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 1. Wearable terhubung (Hitam -> Sambung Polar)
                  _buildInteractivePreparationItem(
                    icon: Icons.watch_rounded,
                    title: 'Wearable terhubung',
                    subtitle: _isPolarConnected
                        ? '$_polarDeviceName terhubung.'
                        : 'Ketuk untuk menghubungkan Polar H10.',
                    statusLabel: _isPolarConnected ? 'Siap' : 'Belum siap',
                    isSuccess: _isPolarConnected,
                    isWarning: !_isPolarConnected,
                    onTap: _showConnectPolarSheet,
                  ),
                  const Divider(height: 20, color: Color(0xFFEDF3F1)),

                  // 2. Sinyal sensor (Merah -> Pop up sinyal sensor)
                  _buildInteractivePreparationItem(
                    icon: Icons.sensors_rounded,
                    title: 'Sinyal sensor',
                    subtitle: 'Detak jantung & gerakan stabil ($_signalQualityPercent%).',
                    statusLabel: 'Baik',
                    isSuccess: _isSensorSignalChecked,
                    onTap: _showSensorSignalPopup,
                  ),
                  const Divider(height: 20, color: Color(0xFFEDF3F1)),

                  // 3. Profil dasar (Ijo -> Pengisian 5 tanda vital spt SpO2 dll)
                  _buildInteractivePreparationItem(
                    icon: Icons.monitor_heart_outlined,
                    title: 'Profil dasar',
                    subtitle: _isVitalSignsFilled
                        ? 'SpO₂: $_valSpO2%, TD: $_valBloodPressure, Suhu: $_valTemperature°C'
                        : 'Ketuk untuk mengisi 5 tanda vital awal (SpO2, TD, dll).',
                    statusLabel: _isVitalSignsFilled ? 'Lengkap' : 'Belum lengkap',
                    isSuccess: _isVitalSignsFilled,
                    isWarning: !_isVitalSignsFilled,
                    onTap: _showVitalSignsSheet,
                  ),
                  const Divider(height: 20, color: Color(0xFFEDF3F1)),

                  // 4. Persetujuan & privasi (Ungu -> Teks Persetujuan Penelitian + Checkbox)
                  _buildInteractivePreparationItem(
                    icon: Icons.shield_outlined,
                    title: 'Persetujuan & privasi',
                    subtitle: _isConsentAgreed
                        ? 'Izin subjek penelitian telah diberikan.'
                        : 'Ketuk untuk membaca pernyataan & menyetujui.',
                    statusLabel: _isConsentAgreed ? 'Disetujui' : 'Belum disetujui',
                    isSuccess: _isConsentAgreed,
                    isWarning: !_isConsentAgreed,
                    onTap: _showConsentSheet,
                  ),
                ],
              ),
            ),

            // Card 2: Rencana Sesi
            ExperimentCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rencana sesi',
                    style: AppTheme.font(
                      size: 14.5,
                      weight: FontWeight.w800,
                      color: const Color(0xFF0F2B3C),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Urutan aktivitas yang akan Anda lakukan.',
                    style: AppTheme.font(
                      size: 12,
                      color: const Color(0xFF6B807B),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildSessionPlanStep(
                    stepNumber: 1,
                    icon: Icons.airline_seat_recline_normal_rounded,
                    title: 'Duduk tenang 5 menit',
                    subtitle: 'Untuk kondisi istirahat awal.',
                    isLast: false,
                  ),
                  _buildSessionPlanStep(
                    stepNumber: 2,
                    icon: Icons.accessibility_new_rounded,
                    title: 'Berdiri 3 menit',
                    subtitle: 'Mengamati perubahan saat berdiri.',
                    isLast: false,
                  ),
                  _buildSessionPlanStep(
                    stepNumber: 3,
                    icon: Icons.directions_walk_rounded,
                    title: 'Jalan 5 menit',
                    subtitle: 'Mengamati respons saat aktivitas ringan.',
                    isLast: false,
                  ),
                  _buildSessionPlanStep(
                    stepNumber: 4,
                    icon: Icons.assignment_outlined,
                    title: 'EMA singkat setelah perubahan',
                    subtitle: 'Jawab pertanyaan singkat tentang pengalaman Anda.',
                    isLast: true,
                  ),
                ],
              ),
            ),

            // Card 3: Yang Akan Dilakukan Sistem (L1-L4)
            ExperimentCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Yang akan dilakukan sistem',
                    style: AppTheme.font(
                      size: 14.5,
                      weight: FontWeight.w800,
                      color: const Color(0xFF0F2B3C),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Tahapan otomatis sistem Vidyamedic selama sesi pemantauan.',
                    style: AppTheme.font(
                      size: 12,
                      color: const Color(0xFF6B807B),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const FourLayerStepper(activeLayer: 1),
                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'L1: Mengumpulkan Sinyal Sensor & Konteks',
                                style: AppTheme.font(
                                  size: 12.5,
                                  weight: FontWeight.w700,
                                  color: const Color(0xFF166534),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Data PPG mentah, detak jantung (BPM), dan akselerometer direkam setiap detik untuk memetakan kondisi fisiologis normal Anda.',
                                style: AppTheme.font(
                                  size: 11,
                                  color: const Color(0xFF15803D),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Tombol Mulai Eksperimen
            ExperimentPrimaryButton(
              label: 'Mulai Eksperimen',
              icon: Icons.play_arrow_rounded,
              onPressed: widget.onNext,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractivePreparationItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String statusLabel,
    required bool isSuccess,
    bool isWarning = false,
    required VoidCallback onTap,
  }) {
    final statusBg = isSuccess
        ? const Color(0xFFE6F5EF)
        : isWarning
            ? const Color(0xFFFEF3E2)
            : const Color(0xFFF1F5F4);
    final statusColor = isSuccess
        ? const Color(0xFF007A64)
        : isWarning
            ? const Color(0xFFD97706)
            : const Color(0xFF5E7582);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFFEBF6F3),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF007A64), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.font(
                      size: 13,
                      weight: FontWeight.w700,
                      color: const Color(0xFF0F2B3C),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.font(
                      size: 11,
                      color: const Color(0xFF708781),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSuccess
                        ? Icons.check_rounded
                        : isWarning
                            ? Icons.priority_high_rounded
                            : Icons.info_outline,
                    size: 13,
                    color: statusColor,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    statusLabel,
                    style: AppTheme.font(
                      size: 10.5,
                      weight: FontWeight.w800,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFFB0C4BF)),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionPlanStep({
    required int stepNumber,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Color(0xFFEDF5F3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$stepNumber',
                    style: AppTheme.font(
                      size: 11.5,
                      weight: FontWeight.w800,
                      color: const Color(0xFF007A64),
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: const Color(0xFFD6E4E0),
                    margin: const EdgeInsets.symmetric(vertical: 2),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F7F5),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF007A64)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.font(
                      size: 13,
                      weight: FontWeight.w700,
                      color: const Color(0xFF0F2B3C),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTheme.font(
                      size: 11,
                      color: const Color(0xFF6B807B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
