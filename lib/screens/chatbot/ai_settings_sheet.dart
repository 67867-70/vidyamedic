import 'package:flutter/material.dart';
import 'package:nadiku/theme/app_theme.dart';
import 'ai_persona_model.dart';
import 'gemini_api_service.dart';

/// Modal Sheet Pengaturan Chatbot: Terpusat dari Web Portal barajacoffee.com/vidya
class AiSettingsSheet extends StatefulWidget {
  final VoidCallback? onSettingsSaved;

  const AiSettingsSheet({
    super.key,
    this.onSettingsSaved,
  });

  static Future<void> show(BuildContext context, {VoidCallback? onSettingsSaved}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AiSettingsSheet(onSettingsSaved: onSettingsSaved),
    );
  }

  @override
  State<AiSettingsSheet> createState() => _AiSettingsSheetState();
}

class _AiSettingsSheetState extends State<AiSettingsSheet> {
  final TextEditingController _remoteUrlController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _systemInstructionController = TextEditingController();

  bool _useRemoteServer = true;
  bool _isSyncing = false;
  bool _isLoading = true;
  bool _showManualOverride = false;
  bool _obscureApiKey = true;

  String _currentPersonaName = 'Dr. Vidya';
  String _currentPersonaDesc = '';
  String _selectedModel = 'gemini-1.5-flash';
  DateTime? _lastSync;

  @override
  void initState() {
    super.initState();
    _loadCurrentSettings();
  }

  Future<void> _loadCurrentSettings() async {
    await GeminiApiService.initialize();
    final key = await GeminiApiService.getApiKey();
    final persona = GeminiApiService.getCurrentPersona();
    final model = GeminiApiService.getSelectedModel();
    final remoteUrl = GeminiApiService.getRemoteApiUrl();
    final useRemote = GeminiApiService.getUseRemoteBackend();
    final lastSync = GeminiApiService.getLastSyncTime();

    if (mounted) {
      setState(() {
        _remoteUrlController.text = remoteUrl;
        _apiKeyController.text = key ?? '';
        _currentPersonaName = persona.name;
        _currentPersonaDesc = persona.description;
        _systemInstructionController.text = persona.systemInstruction;
        _selectedModel = model;
        _useRemoteServer = useRemote;
        _lastSync = lastSync;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _remoteUrlController.dispose();
    _apiKeyController.dispose();
    _systemInstructionController.dispose();
    super.dispose();
  }

  Future<void> _syncNow() async {
    setState(() => _isSyncing = true);
    final success = await GeminiApiService.syncFromRemoteServer();
    await _loadCurrentSettings();

    if (mounted) {
      setState(() => _isSyncing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? '✅ Berhasil menyinkronkan Persona & Konfigurasi dari barajacoffee.com/vidya'
                : '⚠️ Tidak dapat terhubung ke barajacoffee.com/vidya. Menggunakan cache offline.',
          ),
          backgroundColor: success ? const Color(0xFF007A64) : const Color(0xFFC05621),
          behavior: SnackBarBehavior.floating,
        ),
      );
      if (success) {
        widget.onSettingsSaved?.call();
      }
    }
  }

  Future<void> _saveLocalSettings() async {
    await GeminiApiService.setRemoteApiUrl(_remoteUrlController.text.trim());
    await GeminiApiService.setUseRemoteBackend(_useRemoteServer);

    if (!_useRemoteServer) {
      await GeminiApiService.setApiKey(_apiKeyController.text.trim());
      await GeminiApiService.setSelectedModel(_selectedModel);
      await GeminiApiService.setPersona(
        AiPersona(
          id: 'local_custom',
          name: _currentPersonaName,
          description: _currentPersonaDesc,
          systemInstruction: _systemInstructionController.text.trim(),
          model: _selectedModel,
        ),
      );
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pengaturan Chatbot berhasil disimpan.'),
          backgroundColor: Color(0xFF007A64),
        ),
      );
      widget.onSettingsSaved?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 250,
        child: Center(child: CircularProgressIndicator(color: Color(0xFF007A64))),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
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
                          color: Color(0xFFE2F5EF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.cloud_sync_outlined,
                        size: 20,
                        color: Color(0xFF007A64),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pusat Pengaturan AI (Web)',
                          style: AppTheme.font(
                            size: 16,
                            weight: FontWeight.w800,
                            color: const Color(0xFF0F2B3C),
                          ),
                        ),
                        Text(
                          'barajacoffee.com/vidya',
                          style: AppTheme.font(
                            size: 11,
                            weight: FontWeight.w600,
                            color: const Color(0xFF007A64),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(color: Color(0xFFEDF3F1), height: 20),

            // KARTU UTAMA: TERPUSAT DI WEB PORTAL
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF0FDF4), Color(0xFFE6FFFA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFB7E4D8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF007A64).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.language_rounded, size: 18, color: Color(0xFF007A64)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Pengaturan Dikelola dari Web Portal',
                          style: AppTheme.font(
                            size: 13,
                            weight: FontWeight.w800,
                            color: const Color(0xFF0B463A),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF007A64),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Web PHP',
                          style: AppTheme.font(
                            size: 10,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Kunci API Gemini, model AI, dan instruksi persona Dr. Vidya diatur melalui web admin di luar aplikasi tanpa perlu update APK.',
                    style: AppTheme.font(size: 11.5, color: const Color(0xFF234E43), height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFD6EBE4)),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow('🌐 Portal Web', 'https://barajacoffee.com/vidya/'),
                        const Divider(height: 12, color: Color(0xFFF0F4F3)),
                        _buildInfoRow('🩺 Nama Persona', _currentPersonaName),
                        const Divider(height: 12, color: Color(0xFFF0F4F3)),
                        _buildInfoRow('🤖 Model Gemini', _selectedModel),
                        const Divider(height: 12, color: Color(0xFFF0F4F3)),
                        _buildInfoRow(
                          '⏱️ Sinkron Terakhir',
                          _lastSync != null
                              ? '${_lastSync!.hour.toString().padLeft(2, '0')}:${_lastSync!.minute.toString().padLeft(2, '0')}'
                              : 'Tersimpan lokal',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton.icon(
                      onPressed: _isSyncing ? null : _syncNow,
                      icon: _isSyncing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.sync_rounded, size: 18),
                      label: Text(
                        _isSyncing ? 'Menyinkronkan...' : 'Sinkronkan Sekarang dari Web',
                        style: AppTheme.font(size: 12.5, weight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007A64),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // PANDUAN CARA AKSES
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 20, color: Color(0xFF0284C7)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cara Mengubah Persona & API Key:',
                          style: AppTheme.font(size: 11.5, weight: FontWeight.w700, color: const Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Buka browser ke barajacoffee.com/vidya lalu masukkan PIN bawaan: 1234. Setelah disimpan, klik tombol "Sinkronkan Sekarang" di atas.',
                          style: AppTheme.font(size: 11, color: const Color(0xFF475569)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ACCORDION PENGATURAN MANUAL / OVERRIDE
            InkWell(
              onTap: () => setState(() => _showManualOverride = !_showManualOverride),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Opsi Lanjutan & Override Manual',
                      style: AppTheme.font(
                        size: 12.5,
                        weight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    Icon(
                      _showManualOverride ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                      color: const Color(0xFF64748B),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),

            if (_showManualOverride) ...[
              const SizedBox(height: 10),
              SwitchListTile(
                value: _useRemoteServer,
                onChanged: (val) => setState(() => _useRemoteServer = val),
                title: Text(
                  'Gunakan Server barajacoffee.com/vidya',
                  style: AppTheme.font(size: 12.5, weight: FontWeight.w700),
                ),
                subtitle: Text(
                  'Matikan jika ingin memasukkan API Key Gemini langsung di HP ini.',
                  style: AppTheme.font(size: 11, color: const Color(0xFF6B807B)),
                ),
                contentPadding: EdgeInsets.zero,
                activeTrackColor: const Color(0xFF007A64),
              ),
              const SizedBox(height: 8),

              Text(
                'URL REST API Backend:',
                style: AppTheme.font(size: 12, weight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _remoteUrlController,
                decoration: InputDecoration(
                  hintText: 'https://barajacoffee.com/vidya/api.php',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                style: AppTheme.font(size: 12),
              ),

              if (!_useRemoteServer) ...[
                const SizedBox(height: 14),
                Text(
                  'Kunci Google Gemini API (Lokal):',
                  style: AppTheme.font(size: 12, weight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _apiKeyController,
                  obscureText: _obscureApiKey,
                  decoration: InputDecoration(
                    hintText: 'AIzaSy...',
                    suffixIcon: IconButton(
                      icon: Icon(_obscureApiKey ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscureApiKey = !_obscureApiKey),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  style: AppTheme.font(size: 12),
                ),
              ],

              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _saveLocalSettings,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF007A64),
                    side: const BorderSide(color: Color(0xFF007A64)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Simpan Pengaturan Manual'),
                ),
              ),
            ],

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.font(size: 11.5, color: const Color(0xFF64748B), weight: FontWeight.w600),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.font(size: 11.5, color: const Color(0xFF0F172A), weight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
