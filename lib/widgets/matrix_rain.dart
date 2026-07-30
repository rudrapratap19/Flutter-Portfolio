// import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MatrixRainWidget extends StatefulWidget {
  const MatrixRainWidget({super.key});

  @override
  State<MatrixRainWidget> createState() => _MatrixRainWidgetState();
}

class _MatrixRainWidgetState extends State<MatrixRainWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  List<_MatrixColumn> _columns = [];

  static const String _chars =
      'アカサタナハマヤラワ0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ@#\$%&*';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initColumns(double width, double height) {
    final colCount = (width / 18).floor();
    if (_columns.length == colCount) return;

    _columns = List.generate(colCount, (i) {
      return _MatrixColumn(
        x: i * 18.0,
        speed: 2.0 + _random.nextDouble() * 4.0,
        length: 8 + _random.nextInt(16),
        y: _random.nextDouble() * -height,
        characters: List.generate(
          24,
          (_) => _chars[_random.nextInt(_chars.length)],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _initColumns(constraints.maxWidth, constraints.maxHeight);

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            for (var col in _columns) {
              col.y += col.speed;
              if (col.y > constraints.maxHeight + (col.length * 20)) {
                col.y = -col.length * 20.0;
                col.speed = 2.0 + _random.nextDouble() * 4.0;
              }
              if (_random.nextDouble() < 0.05) {
                final idx = _random.nextInt(col.characters.length);
                col.characters[idx] = _chars[_random.nextInt(_chars.length)];
              }
            }

            return CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _MatrixPainter(_columns),
            );
          },
        );
      },
    );
  }
}

class _MatrixColumn {
  final double x;
  double y;
  double speed;
  final int length;
  final List<String> characters;

  _MatrixColumn({
    required this.x,
    required this.y,
    required this.speed,
    required this.length,
    required this.characters,
  });
}

class _MatrixPainter extends CustomPainter {
  final List<_MatrixColumn> columns;

  _MatrixPainter(this.columns);

  @override
  void paint(Canvas canvas, Size size) {
    const fontSize = 14.0;

    for (var col in columns) {
      for (int i = 0; i < col.length; i++) {
        final charY = col.y + (i * fontSize);
        if (charY < 0 || charY > size.height) continue;

        final isHead = i == col.length - 1;
        final alpha = isHead ? 1.0 : (i / col.length) * 0.75;
        final color = isHead
            ? const Color(0xFFE0FFEB)
            : const Color(0xFF00FF66).withValues(alpha: alpha);

        final span = TextSpan(
          text: col.characters[i % col.characters.length],
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontFamily: 'monospace',
            fontWeight: isHead ? FontWeight.bold : FontWeight.normal,
          ),
        );

        final painter = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
        );
        painter.layout();
        painter.paint(canvas, Offset(col.x, charY));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MatrixPainter oldDelegate) => true;
}
