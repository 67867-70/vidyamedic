import 'package:flutter/material.dart';
import 'package:nadiku/theme/app_theme.dart';
import 'ai_persona_model.dart';
import 'ai_settings_sheet.dart';
import 'chat_database_sqlite.dart';
import 'gemini_api_service.dart';

/// Layar Obrolan Asisten Chatbot AI Vidyamedic
/// Terhubung dengan SQLite Database dan Google Gemini API
class AiChatScreen extends StatefulWidget {
  final Map<String, dynamic>? initialHealthContext;

  const AiChatScreen({
    super.key,
    this.initialHealthContext,
  });

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _apiKey;
  late AiPersona _currentPersona;

  final List<String> _quickPrompts = [
    'Apa arti deviasi HR 110 bpm saya?',
    'Cara menenangkan denyut nadi berdebar',
    'Jelaskan skor pemulihan (RMSSD)',
    'Tips tidur nyenyak malam ini',
  ];

  @override
  void initState() {
    super.initState();
    _currentPersona = GeminiApiService.getCurrentPersona();
    _initData();
  }

  Future<void> _initData() async {
    await GeminiApiService.initialize();
    final key = await GeminiApiService.getApiKey();
    final history = await ChatDatabaseSqlite.instance.getMessages();

    setState(() {
      _apiKey = key;
      _currentPersona = GeminiApiService.getCurrentPersona();
      _messages.clear();
      _messages.addAll(history);
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    final query = text.trim();
    if (query.isEmpty) return;

    _textController.clear();

    // Simpan pesan user ke SQLite dan UI
    final userMsg = ChatMessage(
      text: query,
      isUser: true,
      timestamp: DateTime.now(),
    );
    await ChatDatabaseSqlite.instance.insertMessage(userMsg);

    setState(() {
      _messages.add(userMsg);
      _isLoading = true;
    });
    _scrollToBottom();

    // Panggil Gemini API
    final botResponse = await GeminiApiService.sendMessage(
      userMessage: query,
      conversationHistory: _messages,
      patientHealthContext: widget.initialHealthContext ??
          {
            'Detak Jantung': '82 bpm',
            'Aktivitas': 'Duduk tenang',
            'Status Sensor': 'Stabil',
          },
    );

    // Simpan respons model ke SQLite dan UI
    final botMsg = ChatMessage(
      text: botResponse,
      isUser: false,
      timestamp: DateTime.now(),
      modelUsed: GeminiApiService.getSelectedModel(),
    );
    await ChatDatabaseSqlite.instance.insertMessage(botMsg);

    if (mounted) {
      setState(() {
        _messages.add(botMsg);
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasKey = _apiKey != null && _apiKey!.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Asisten AI Vidyamedic',
                  style: AppTheme.font(
                    size: 16,
                    weight: FontWeight.w800,
                    color: const Color(0xFF0F2B3C),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2F3EF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    GeminiApiService.getUseRemoteBackend() ? 'Web barajacoffee' : (hasKey ? 'Gemini AI' : 'Mode Offline'),
                    style: AppTheme.font(
                      size: 9.5,
                      weight: FontWeight.w800,
                      color: const Color(0xFF007A64),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              _currentPersona.description.isNotEmpty ? _currentPersona.description : _currentPersona.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.font(
                size: 11,
                color: const Color(0xFF708781),
                weight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_sync_outlined, color: Color(0xFF007A64), size: 22),
            tooltip: 'Sinkronkan dengan barajacoffee.com/vidya',
            onPressed: () => AiSettingsSheet.show(
              context,
              onSettingsSaved: _initData,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFF90A39E), size: 20),
            tooltip: 'Hapus Riwayat Chat',
            onPressed: () async {
              await ChatDatabaseSqlite.instance.clearMessages();
              _initData();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner Status Sinkronisasi Web barajacoffee.com/vidya
          InkWell(
            onTap: () => AiSettingsSheet.show(
              context,
              onSettingsSaved: _initData,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFFF0FDF4),
                border: Border(bottom: BorderSide(color: Color(0xFFBBF7D0))),
              ),
              child: Row(
                children: [
                  const Icon(Icons.language_rounded, color: Color(0xFF15803D), size: 15),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pengaturan AI & Persona terpusat di barajacoffee.com/vidya. Ketuk untuk sinkronisasi.',
                      style: AppTheme.font(
                        size: 11,
                        color: const Color(0xFF166534),
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(Icons.sync_rounded, size: 15, color: Color(0xFF15803D)),
                ],
              ),
            ),
          ),

          // Daftar Pesan Chat
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),

          // Indikator Mengetik
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 8),
              child: Row(
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF007A64)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Asisten sedang menganalisis...',
                    style: AppTheme.font(size: 11.5, color: const Color(0xFF708781)),
                  ),
                ],
              ),
            ),

          // Quick Prompt Chips
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _quickPrompts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                return ActionChip(
                  label: Text(_quickPrompts[i]),
                  labelStyle: AppTheme.font(size: 11, color: const Color(0xFF0F2B3C)),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFDCE6E4)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  onPressed: () => _sendMessage(_quickPrompts[i]),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Input Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFEDF3F1))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F4),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _textController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                      decoration: InputDecoration(
                        hintText: 'Tanyakan sesuatu tentang tubuh Anda...',
                        hintStyle: AppTheme.font(size: 12.5, color: const Color(0xFF8B9E99)),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      style: AppTheme.font(size: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _sendMessage(_textController.text),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFF007A64),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10, left: 48),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF007A64),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(4),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            msg.text,
            style: AppTheme.font(size: 13, color: Colors.white, height: 1.35),
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12, right: 36),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFF0F2B3C),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF6EE7B7), size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(color: const Color(0xFFE2EBE8)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x06000000),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    msg.text,
                    style: AppTheme.font(
                      size: 12.5,
                      color: const Color(0xFF1E293B),
                      height: 1.45,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
