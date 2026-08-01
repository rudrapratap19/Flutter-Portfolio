import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../theme/app_colors.dart';
import '../theme/theme_notifier.dart';

class ChatMessage {
  final int id;
  final String text;
  final bool isUser;
  
  ChatMessage({required this.id, required this.text, required this.isUser});
}

class AiChatbot extends StatefulWidget {
  const AiChatbot({super.key});

  @override
  State<AiChatbot> createState() => _AiChatbotState();
}

class _AiChatbotState extends State<AiChatbot> {
  bool _isOpen = false;
  bool _isLoading = false;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  
  // Using the API key extracted from the old project
  static const _apiKey = 'AIzaSyDbzTvaa74gb_X2VUEo7jJ-qwWUwfGKETA';
  late final GenerativeModel _model;
  late final ChatSession _chat;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() {
    final systemInstruction = '''You are an AI assistant for Rudra Pratap Singh's portfolio. You represent Rudra and help visitors by answering questions about his skills, experience, and projects.

Key information about Rudra:
- **Role**: Junior Flutter Developer & AI/ML Enthusiast.
- **Education**: Studying at IIIT Raichur.
- **Coding Stats**: Solved over 474+ DSA problems (224+ on LeetCode, 250+ on GeeksforGeeks). LeetCode contest rating is 1501.

**Experience**:
- Junior Flutter Developer at Webintegratorz Technologies (May 2026 - Present)
- Flutter Developer Intern at Syflex Techno Solution Pvt. Ltd. (Mar 2026 - May 2026)
- Placement Coordinator at Student Leadership (Jan 2026 - May 2026)
- Teaching Assistant for Data Structures & Algorithms (Aug 2025 - Dec 2025)
- Internship Coordinator (Aug 2025 - Dec 2025)
- Academic Secretary (Aug 2024 - Aug 2025)

**Projects**:
- *Modern Retrieval-Augmented Discovery of RESTful Web APIs*: Research Paper - Under Review (AI/ML).
- *ArenaFlow*: Tournament Management App built with Flutter.
- *Decoder-Only Transformer for Language Modeling*: Generative LLM Architecture (AI/ML).
- *Flutter Task & To-Do App*: Cross-Platform Task Manager.

**Skills**:
- **Mobile & Frontend**: Flutter, Dart, Firebase, Supabase, BLoC, Provider, REST APIs, JavaScript.
- **Backend**: Node.js, Express.js, Prisma ORM, JWT Auth, MVC Architecture.
- **Databases**: PostgreSQL, SQL, Firestore, Supabase.
- **AI & Machine Learning**: Python, Deep Learning, Transformers, NLP, Machine Learning, Pandas, SciPy, Matplotlib.
- **Languages**: Dart, Python, JavaScript, C, C++, SQL.

Guidelines for your responses:
- **Tone**: Be highly enthusiastic, warm, and conversational. You are Rudra's personal hype-man/assistant! Use emojis naturally.
- **Brevity**: Keep responses short and punchy. DO NOT dump large blocks of text or lists unless the user explicitly asks for "all" of something. 
- **Formatting**: Use Markdown extensively. Bold key terms, use short bullet points for readability, and use spacing effectively.
- **Engagement**: Always try to highlight what makes Rudra impressive (e.g., his 474+ DSA problems or AI research) when relevant. End responses by asking if they want to know more about a specific topic.
- **Boundaries**: If asked something unrelated to Rudra or his portfolio, politely redirect the conversation back to his professional profile.''';

    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey,
      systemInstruction: Content.system(systemInstruction),
    );
    
    _chat = _model.startChat();
    
    // Add initial greeting
    _messages.add(ChatMessage(
      id: 0,
      text: "Hi there! 👋 I'm Rudra's AI Assistant. Want to know more about my projects, skills, or experience? Feel free to ask me anything!",
      isUser: false,
    ));
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(id: _messages.length, text: text, isUser: true));
      _isLoading = true;
      _textController.clear();
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    try {
      final response = await _chat.sendMessage(Content.text(text));
      final responseText = response.text;
      
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            id: _messages.length,
            text: responseText ?? "Sorry, I couldn't generate a response.",
            isUser: false,
          ));
          _isLoading = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            id: _messages.length,
            text: "Error connecting to Gemini: $e",
            isUser: false,
          ));
          _isLoading = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, themeMode, _) {
        final isDark = themeMode != AppThemeMode.light;
        
        return Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (_isOpen)
                  _buildChatWindow(isDark).animate().scaleXY(
                        begin: 0.8,
                        end: 1.0,
                        duration: 300.ms,
                        curve: Curves.easeOutBack,
                      ).fadeIn(duration: 200.ms),
                if (_isOpen) const SizedBox(height: 16),
                _buildFab(isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFab(bool isDark) {
    return GestureDetector(
      onTap: () => setState(() => _isOpen = !_isOpen),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00FF66), Color(0xFF00CC52)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00FF66).withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          _isOpen ? Icons.close_rounded : Icons.smart_toy_rounded,
          color: const Color(0xFF0F172A),
          size: 28,
        ),
      ),
    ).animate().scale(delay: 500.ms, duration: 400.ms, curve: Curves.easeOutBack);
  }

  Widget _buildChatWindow(bool isDark) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isMobile = width < 600;
    
    // Calculate max safe height to avoid bottom overflow (account for FAB + padding)
    final maxAllowedHeight = height - 120; 
    final defaultHeight = isMobile ? 500.0 : 600.0;
    final windowHeight = defaultHeight > maxAllowedHeight ? maxAllowedHeight : defaultHeight;
    
    return Container(
      width: isMobile ? width - 32 : 380,
      height: windowHeight,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.98) : Colors.white.withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? Colors.white.withValues(alpha: 0.05) : AppColors.lightBorder,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00FF66).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Color(0xFF00FF66),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rudra\'s AI Assistant',
                        style: GoogleFonts.inter(
                          color: AppColors.getTextPrimary(isDark),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Powered by Gemini',
                        style: GoogleFonts.inter(
                          color: AppColors.getTextSecondary(isDark),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: AppColors.getTextSecondary(isDark), size: 20),
                    onPressed: () => setState(() => _isOpen = false),
                    splashRadius: 20,
                  ),
                ],
              ),
            ),
            
            // Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                    return _buildTypingIndicator(isDark);
                  }
                  final msg = _messages[index];
                  return _buildMessageBubble(msg, isDark);
                },
              ),
            ),
            
            // Input Area
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A).withValues(alpha: 0.5) : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.white.withValues(alpha: 0.05) : AppColors.lightBorder,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
                        ),
                      ),
                      child: TextField(
                        controller: _textController,
                        style: GoogleFonts.inter(
                          color: AppColors.getTextPrimary(isDark),
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ask me anything...',
                          hintStyle: GoogleFonts.inter(
                            color: AppColors.getTextSecondary(isDark),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF00FF66), Color(0xFF00CC52)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Color(0xFF0F172A), size: 18),
                      onPressed: _sendMessage,
                      splashRadius: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, bool isDark) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: msg.isUser
              ? (isDark ? const Color(0xFF22C55E).withValues(alpha: 0.2) : const Color(0xFF22C55E).withValues(alpha: 0.15))
              : (isDark ? const Color(0xFF334155).withValues(alpha: 0.5) : const Color(0xFFF8FAFC)),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(msg.isUser ? 16 : 4),
            bottomRight: Radius.circular(msg.isUser ? 4 : 16),
          ),
          border: Border.all(
            color: msg.isUser
                ? const Color(0xFF22C55E).withValues(alpha: 0.3)
                : (isDark ? Colors.white.withValues(alpha: 0.05) : AppColors.lightBorder),
          ),
        ),
        child: msg.isUser
            ? Text(
                msg.text,
                style: GoogleFonts.inter(
                  color: AppColors.getTextPrimary(isDark),
                  fontSize: 14,
                  height: 1.5,
                ),
              )
            : MarkdownBody(
                data: msg.text,
                styleSheet: MarkdownStyleSheet(
                  p: GoogleFonts.inter(color: AppColors.getTextPrimary(isDark), fontSize: 14, height: 1.5),
                  listBullet: GoogleFonts.inter(color: AppColors.getTextPrimary(isDark), fontSize: 14),
                  code: GoogleFonts.shareTechMono(
                    color: const Color(0xFF00FF66), 
                    backgroundColor: Colors.transparent,
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                ),
              ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0, duration: 300.ms, curve: Curves.easeOut);
  }

  Widget _buildTypingIndicator(bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF334155).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _AnimatedDot(delay: 0),
            SizedBox(width: 4),
            _AnimatedDot(delay: 150),
            SizedBox(width: 4),
            _AnimatedDot(delay: 300),
          ],
        ),
      ),
    );
  }
}

class _AnimatedDot extends StatefulWidget {
  final int delay;
  const _AnimatedDot({required this.delay});

  @override
  State<_AnimatedDot> createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<_AnimatedDot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..repeat(reverse: true);
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }
  
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.2, end: 1.0).animate(_ctrl),
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: AppColors.textMuted,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
