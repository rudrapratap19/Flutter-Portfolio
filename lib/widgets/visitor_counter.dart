import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import '../theme/app_colors.dart';

class VisitorCounter extends StatefulWidget {
  final bool isDark;
  const VisitorCounter({super.key, required this.isDark});

  @override
  State<VisitorCounter> createState() => _VisitorCounterState();
}

class _VisitorCounterState extends State<VisitorCounter> {
  int _viewCount = 1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCount();
  }

  Future<void> _fetchCount() async {
    try {
      // Hits a free public counting API that increments on every GET request
      final res = await http
          .get(Uri.parse('https://api.counterapi.dev/v1/rudrapratap19/portfolio/up'))
          .timeout(const Duration(seconds: 4));
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (mounted) {
          setState(() {
            _viewCount = data['count'] as int;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: widget.isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: widget.isDark
              ? Colors.white.withValues(alpha: 0.1)
              : AppColors.lightBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF22C55E),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: _isLoading 
                ? SizedBox(
                    height: 12, 
                    width: 12, 
                    child: CircularProgressIndicator(
                      strokeWidth: 2, 
                      valueColor: AlwaysStoppedAnimation(AppColors.getTextSecondary(widget.isDark)),
                    ),
                  )
                : Text(
                    '👀 $_viewCount profile ${_viewCount == 1 ? 'view' : 'views'}',
                    style: GoogleFonts.inter(
                      color: AppColors.getTextSecondary(widget.isDark),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 1100.ms, duration: 700.ms);
  }
}
