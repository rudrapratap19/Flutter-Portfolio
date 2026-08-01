import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/terminal_engine.dart';
import '../theme/theme_notifier.dart';
import '../widgets/matrix_rain.dart';
import 'dart:html' as html;

class TerminalView extends StatefulWidget {
  const TerminalView({super.key});

  @override
  State<TerminalView> createState() => _TerminalViewState();
}

class _TerminalViewState extends State<TerminalView> {
  final TextEditingController _inputCtrl = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollCtrl = ScrollController();

  final List<TerminalOutputLine> _history = [];
  final List<String> _cmdHistory = [];
  int _historyIndex = -1;
  bool _showMatrix = false;

  @override
  void initState() {
    super.initState();
    // Initialize welcome banner lines
    final welcomeLines = TerminalEngine.welcomeBanner
        .split('\n')
        .map((l) => TerminalOutputLine(l, type: 'accent'))
        .toList();
    _history.addAll(welcomeLines);

    // Auto-focus input
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      try {
        html.window.dispatchEvent(html.Event('flutter-first-frame'));
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _focusNode.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    final trimmed = text.trim();
    _cmdHistory.add(trimmed);
    _historyIndex = _cmdHistory.length;

    setState(() {
      _history.add(TerminalOutputLine('${TerminalEngine.currentDir}> $trimmed', type: 'input'));
      _inputCtrl.clear();
    });

    if (trimmed.toLowerCase() == 'cls' || trimmed.toLowerCase() == 'clear') {
      setState(() {
        _history.clear();
      });
      return;
    }

    if (trimmed.toLowerCase() == 'matrix') {
      setState(() {
        _showMatrix = !_showMatrix;
        _history.add(TerminalOutputLine(
          _showMatrix
              ? 'Matrix Digital Code Rain: ENABLED 🟢'
              : 'Matrix Digital Code Rain: DISABLED 🔴',
          type: 'success',
        ));
      });
      _scrollToBottom();
      return;
    }

    final outputs = await TerminalEngine.executeCommand(trimmed);
    setState(() {
      _history.addAll(outputs);
    });

    // Handle URL-launching lines from 'open' command
    for (final line in outputs) {
      if (line.type == '__url__' && line.text.startsWith('>> OPEN_URL:')) {
        final urlStr = line.text.replaceFirst('>> OPEN_URL:', '');
        try {
          await launchUrl(Uri.parse(urlStr), mode: LaunchMode.externalApplication);
        } catch (_) {}
      }
    }

    _scrollToBottom();
  }

  void _onKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (_cmdHistory.isNotEmpty && _historyIndex > 0) {
          _historyIndex--;
          _inputCtrl.text = _cmdHistory[_historyIndex];
          _inputCtrl.selection = TextSelection.collapsed(offset: _inputCtrl.text.length);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        if (_cmdHistory.isNotEmpty && _historyIndex < _cmdHistory.length - 1) {
          _historyIndex++;
          _inputCtrl.text = _cmdHistory[_historyIndex];
          _inputCtrl.selection = TextSelection.collapsed(offset: _inputCtrl.text.length);
        } else {
          _historyIndex = _cmdHistory.length;
          _inputCtrl.clear();
        }
      } else if (event.logicalKey == LogicalKeyboardKey.tab) {
        final currentText = _inputCtrl.text;
        final completed = TerminalEngine.autocomplete(currentText);
        if (completed != currentText) {
          _inputCtrl.text = completed;
          _inputCtrl.selection = TextSelection.collapsed(offset: completed.length);
        }
      }
    }
  }

  Color _getLineColor(String type) {
    switch (type) {
      case 'input':
        return const Color(0xFF38BDF8); // Cyan prompt text
      case 'accent':
        return const Color(0xFF00FF66); // Neon Matrix Green
      case 'success':
        return const Color(0xFF22C55E); // Green
      case 'error':
        return const Color(0xFFEF4444); // Red
      case 'warning':
        return const Color(0xFFF59E0B); // Amber
      default:
        return const Color(0xFFE2E8F0); // Off-white
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E14),
      body: Stack(
        children: [
          // Optional Matrix Rain Background
          if (_showMatrix) const Positioned.fill(child: MatrixRainWidget()),

          // Main Terminal Container
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0C1017).withValues(alpha: _showMatrix ? 0.85 : 0.98),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black87,
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 1. Windows CMD Titlebar
                  _buildTitleBar(),

                  // 2. Menu Bar
                  _buildMenuBar(),

                  const Divider(color: Color(0xFF1E293B), height: 1),

                  // 3. Scrollable Terminal Console Output
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _focusNode.requestFocus(),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: KeyboardListener(
                          focusNode: FocusNode(),
                          onKeyEvent: _onKeyEvent,
                          child: ListView(
                            controller: _scrollCtrl,
                            children: [
                              ..._history.map((line) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: SelectableText(
                                    line.text,
                                    style: GoogleFonts.shareTechMono(
                                      color: _getLineColor(line.type),
                                      fontSize: 14,
                                      height: 1.35,
                                    ),
                                  ),
                                );
                              }),

                              const SizedBox(height: 8),

                              // Interactive Input Prompt Line
                              Row(
                                children: [
                                  Text(
                                    '${TerminalEngine.currentDir}> ',
                                    style: GoogleFonts.shareTechMono(
                                      color: const Color(0xFF38BDF8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: _inputCtrl,
                                      focusNode: _focusNode,
                                      style: GoogleFonts.shareTechMono(
                                        color: const Color(0xFF00FF66),
                                        fontSize: 14,
                                      ),
                                      cursorColor: const Color(0xFF00FF66),
                                      cursorWidth: 8,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      onSubmitted: _handleSubmitted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildTitleBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.terminal_rounded, color: Color(0xFF38BDF8), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Administrator: Command Prompt - C:\\Windows\\System32\\cmd.exe',
              style: GoogleFonts.shareTechMono(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Window Control Buttons
          IconButton(
            icon: const Icon(Icons.blur_on_rounded, size: 16, color: Color(0xFF00FF66)),
            tooltip: 'Toggle Matrix Rain',
            onPressed: () {
              setState(() => _showMatrix = !_showMatrix);
            },
          ),
          IconButton(
            icon: const Icon(Icons.dark_mode_outlined, size: 16, color: Colors.white70),
            tooltip: 'Switch to Dark Mode',
            onPressed: () {
              ThemeNotifier.instance.setTheme(AppThemeMode.dark);
            },
          ),
          IconButton(
            icon: const Icon(Icons.light_mode_outlined, size: 16, color: Colors.white70),
            tooltip: 'Switch to Light Mode',
            onPressed: () {
              ThemeNotifier.instance.setTheme(AppThemeMode.light);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: const Color(0xFF0F172A),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          _menuItem('File', () => _handleSubmitted('help')),
          _menuItem('Edit', () => _handleSubmitted('cls')),
          _menuItem('System', () => _handleSubmitted('neofetch')),
          _menuItem('Projects', () => _handleSubmitted('projects')),
          _menuItem('Stats', () => _handleSubmitted('stats')),
          _menuItem('Matrix', () {
            setState(() => _showMatrix = !_showMatrix);
          }),
        ],
      ),
    );
  }

  Widget _menuItem(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.white10,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          label,
          style: GoogleFonts.shareTechMono(
            color: const Color(0xFF94A3B8),
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
