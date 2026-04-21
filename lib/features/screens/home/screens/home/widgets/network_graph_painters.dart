import 'dart:math' as math;

import 'package:flutter/material.dart';

class NetworkGraphPainter extends CustomPainter {
  final int activeNodes;
  final Color primary;
  final Color secondary;

  const NetworkGraphPainter({
    required this.activeNodes,
    required this.primary,
    required this.secondary,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    final count = math.max(8, math.min(activeNodes + 5, 16));

    final nodes = List.generate(
      count,
      (_) =>
          Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
    );

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;

    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        if ((nodes[i] - nodes[j]).distance < size.width * 0.44) {
          final active = i < activeNodes || j < activeNodes;
          linePaint.color = (active ? primary : secondary).withValues(
            alpha: 0.25,
          );
          canvas.drawLine(nodes[i], nodes[j], linePaint);
        }
      }
    }

    for (int i = 0; i < nodes.length; i++) {
      final active = i < activeNodes;
      final color = active ? primary : secondary;
      final r = active ? 5.5 : 3.5;
      canvas.drawCircle(
        nodes[i],
        r + 3,
        Paint()..color = color.withValues(alpha: 0.14),
      );
      canvas.drawCircle(nodes[i], r, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(NetworkGraphPainter old) => old.activeNodes != activeNodes;
}

extension on math.Random {
  void nextDouble() {}
}

class CoreLinkPainter extends CustomPainter {
  final Color leftGlow;
  final Color rightGlow;

  const CoreLinkPainter({required this.leftGlow, required this.rightGlow});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final left = Offset(cx * 0.38, cy);
    final right = Offset(cx * 1.62, cy);

    void drawSpeakerRing(Offset center, Color color) {
      // Outer glow ring
      canvas.drawCircle(
        center,
        30,
        Paint()..color = color.withValues(alpha: 0.12),
      );
      // Ring 1 — outer border
      canvas.drawCircle(
        center,
        28,
        Paint()
          ..color = color.withValues(alpha: 0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
      // Ring 2 — mid
      canvas.drawCircle(
        center,
        20,
        Paint()
          ..color = color.withValues(alpha: 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
      // Ring 3 — inner fill
      canvas.drawCircle(
        center,
        12,
        Paint()
          ..color = color.withValues(alpha: 0.18)
          ..style = PaintingStyle.fill,
      );
      // Inner dot
      canvas.drawCircle(
        center,
        6,
        Paint()..color = color.withValues(alpha: 0.75),
      );
    }

    // Draw the two main speaker rings
    drawSpeakerRing(left, leftGlow);
    drawSpeakerRing(right, rightGlow);

    // Center link dot
    canvas.drawCircle(
      Offset(cx, cy),
      5,
      Paint()..color = Colors.white.withValues(alpha: 0.55),
    );

    // Link lines
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    line.color = leftGlow.withValues(alpha: 0.45);
    canvas.drawLine(Offset(left.dx + 28, cy), Offset(cx - 6, cy), line);
    line.color = rightGlow.withValues(alpha: 0.45);
    canvas.drawLine(Offset(cx + 6, cy), Offset(right.dx - 28, cy), line);

    // Satellite dots around each ring
    final sats = [
      _Sat(Offset(left.dx - 36, left.dy - 20), leftGlow),
      _Sat(Offset(left.dx - 38, left.dy + 22), leftGlow),
      _Sat(Offset(right.dx + 36, right.dy - 20), rightGlow),
      _Sat(Offset(right.dx + 38, right.dy + 22), rightGlow),
    ];

    for (final s in sats) {
      line.color = s.color.withValues(alpha: 0.28);
      canvas.drawLine(s.color == leftGlow ? left : right, s.pos, line);
      canvas.drawCircle(
        s.pos,
        4,
        Paint()..color = s.color.withValues(alpha: 0.6),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _Sat {
  final Offset pos;
  final Color color;
  const _Sat(this.pos, this.color);
}
