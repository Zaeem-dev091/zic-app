import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const ZicWheelApp());

class ZicWheelApp extends StatelessWidget {
  const ZicWheelApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF040D1A),
      ),
      home: const SpinWheelScreen(),
    );
  }
}

// ─── Reward Model ─────────────────────────────────────────────────
class Reward {
  final String label;
  final String emoji;
  final Color color;
  const Reward({required this.label, required this.emoji, required this.color});
}

const List<Reward> kRewards = [
  Reward(label: 'ZIC Drone', emoji: '🚁', color: Color(0xFF0097A7)),
  Reward(label: '20 Token', emoji: '🪙', color: Color(0xFF00695C)),
  Reward(label: '3D Coins', emoji: '💰', color: Color(0xFF1565C0)),
  Reward(label: 'Double Z-hr', emoji: '⚡', color: Color(0xFF6A1B9A)),
  Reward(label: 'Z Token', emoji: '🔵', color: Color(0xFF00838F)),
  Reward(label: 'Mystery Box', emoji: '🎁', color: Color(0xFF004D40)),
  Reward(label: 'x10 Boost', emoji: '🚀', color: Color(0xFF0D47A1)),
  Reward(label: 'VVIP Key', emoji: '🗝️', color: Color(0xFF37474F)),
];

// ─── Spin Wheel Screen ────────────────────────────────────────────
class SpinWheelScreen extends StatefulWidget {
  const SpinWheelScreen({super.key});
  @override
  State<SpinWheelScreen> createState() => _SpinWheelScreenState();
}

class _SpinWheelScreenState extends State<SpinWheelScreen>
    with TickerProviderStateMixin {
  late AnimationController _spinCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _pointerCtrl;
  late Animation<double> _spinAnim;
  late Animation<double> _glowAnim;
  late Animation<double> _pointerAnim;

  bool _isSpinning = false;
  int _resultIndex = -1;
  double _currentAngle = 0;

  @override
  void initState() {
    super.initState();

    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pointerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _glowAnim = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
    _pointerAnim = Tween<double>(begin: -0.08, end: 0.08).animate(
      CurvedAnimation(parent: _pointerCtrl, curve: Curves.elasticInOut),
    );
  }

  @override
  void dispose() {
    _spinCtrl.dispose();
    _glowCtrl.dispose();
    _pointerCtrl.dispose();
    super.dispose();
  }

  void _spin() {
    if (_isSpinning) return;
    setState(() {
      _isSpinning = true;
      _resultIndex = -1;
    });

    final rng = Random();
    final targetIndex = rng.nextInt(kRewards.length);
    final sliceAngle = (2 * pi) / kRewards.length;

    // Extra full rotations + land on target
    final extraSpins = (5 + rng.nextInt(4)) * 2 * pi;
    final targetAngle =
        extraSpins + (targetIndex * sliceAngle) + (sliceAngle / 2);

    _spinAnim = Tween<double>(
      begin: _currentAngle,
      end: _currentAngle + targetAngle,
    ).animate(CurvedAnimation(parent: _spinCtrl, curve: Curves.easeOutExpo));

    _spinCtrl.reset();
    _spinCtrl.forward().then((_) {
      _currentAngle = (_currentAngle + targetAngle) % (2 * pi);
      setState(() {
        _isSpinning = false;
        _resultIndex = targetIndex;
      });
      _pointerCtrl.forward().then((_) => _pointerCtrl.reverse());
      _showResult(targetIndex);
    });
  }

  void _showResult(int index) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => _ResultDialog(reward: kRewards[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF040D1A),
      body: Stack(
        children: [
          // Radial bg glow
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _glowAnim,
              builder: (_, _) => Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFF00E5FF).withOpacity(0.06 * _glowAnim.value),
                      Colors.transparent,
                    ],
                    radius: 0.8,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Title
                _buildTitle(),
                const SizedBox(height: 32),
                // Wheel + pointer
                Expanded(child: Center(child: _buildWheelSection())),
                // Spin button
                _buildSpinButton(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (_, _) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF061828),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(
              0xFF00E5FF,
            ).withOpacity(0.4 + 0.2 * _glowAnim.value),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(
                0xFF00E5FF,
              ).withOpacity(0.15 * _glowAnim.value),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Text(
          'CLAIM REWARD',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF00E5FF),
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
          ),
        ),
      ),
    );
  }

  Widget _buildWheelSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = min(constraints.maxWidth, constraints.maxHeight) * 0.92;
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring
              AnimatedBuilder(
                animation: _glowAnim,
                builder: (_, _) => Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFF00E5FF,
                        ).withOpacity(0.2 * _glowAnim.value),
                        blurRadius: 40,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
              // Spinning wheel
              AnimatedBuilder(
                animation: _spinCtrl,
                builder: (_, _) {
                  final angle = _isSpinning ? _spinAnim.value : _currentAngle;
                  return Transform.rotate(
                    angle: angle,
                    child: CustomPaint(
                      size: Size(size, size),
                      painter: WheelPainter(rewards: kRewards),
                    ),
                  );
                },
              ),
              // Center Z logo
              _buildCenterHub(size * 0.22),
              // Pointer at top
              Positioned(
                top: 0,
                child: AnimatedBuilder(
                  animation: _pointerAnim,
                  builder: (_, _) => Transform.rotate(
                    angle: _pointerAnim.value,
                    child: _buildPointer(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCenterHub(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFF1565C0), Color(0xFF0D2A5C), Color(0xFF071529)],
        ),
        border: Border.all(
          color: const Color(0xFFFFD700).withOpacity(0.8),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.2),
            blurRadius: 12,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'Z',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 36,
            fontWeight: FontWeight.w900,
            shadows: [Shadow(color: Color(0xFFFFD700), blurRadius: 16)],
          ),
        ),
      ),
    );
  }

  Widget _buildPointer() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF00E5FF),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00E5FF).withOpacity(0.8),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        CustomPaint(size: const Size(24, 28), painter: PointerPainter()),
      ],
    );
  }

  Widget _buildSpinButton() {
    return GestureDetector(
      onTap: _isSpinning ? null : _spin,
      child: AnimatedBuilder(
        animation: _glowAnim,
        builder: (_, _) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Color(0xFF0097A7), Color(0xFF00E5FF)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF00E5FF,
                ).withOpacity(0.4 * _glowAnim.value),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Text(
            _isSpinning ? 'SPINNING...' : 'SPIN NOW',
            style: TextStyle(
              color: _isSpinning ? Colors.white.withOpacity(0.6) : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Wheel Painter ────────────────────────────────────────────────
class WheelPainter extends CustomPainter {
  final List<Reward> rewards;
  WheelPainter({required this.rewards});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final sliceAngle = (2 * pi) / rewards.length;

    for (int i = 0; i < rewards.length; i++) {
      final startAngle = i * sliceAngle - pi / 2;

      // Slice fill
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            rewards[i].color.withOpacity(0.95),
            rewards[i].color.withOpacity(0.6),
            const Color(0xFF040D1A),
          ],
          stops: const [0.0, 0.6, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sliceAngle,
        true,
        paint,
      );

      // Slice border
      final borderPaint = Paint()
        ..color = const Color(0xFF00E5FF).withOpacity(0.35)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sliceAngle,
        true,
        borderPaint,
      );

      // Outer cyan arc highlight
      final outerArcPaint = Paint()
        ..color = const Color(0xFF00E5FF).withOpacity(0.6)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 4),
        startAngle + 0.04,
        sliceAngle - 0.08,
        false,
        outerArcPaint,
      );

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(startAngle + sliceAngle / 2);

      final textRadius = radius * 0.68;
      final textPainter = TextPainter(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${rewards[i].emoji}\n',
              style: const TextStyle(fontSize: 18, height: 1.3),
            ),
            TextSpan(
              text: rewards[i].label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: radius * 0.45);

      canvas.translate(textRadius, 0);
      canvas.rotate(pi / 2);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }

    // Inner dark ring
    final innerRingPaint = Paint()
      ..color = const Color(0xFF040D1A)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.25, innerRingPaint);

    // Inner cyan ring border
    final innerBorderPaint = Paint()
      ..color = const Color(0xFF00E5FF).withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius * 0.25, innerBorderPaint);

    // Gear teeth around the outer edge
    _drawGearTeeth(canvas, center, radius, rewards.length * 3);
  }

  void _drawGearTeeth(Canvas canvas, Offset center, double radius, int count) {
    final toothPaint = Paint()
      ..color = const Color(0xFF00E5FF).withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final angleStep = (2 * pi) / count;
    for (int i = 0; i < count; i++) {
      final angle = i * angleStep;
      final inner = Offset(
        center.dx + (radius - 6) * cos(angle),
        center.dy + (radius - 6) * sin(angle),
      );
      final outer = Offset(
        center.dx + (radius + 6) * cos(angle),
        center.dy + (radius + 6) * sin(angle),
      );
      canvas.drawLine(inner, outer, toothPaint);
    }
  }

  @override
  bool shouldRepaint(covariant WheelPainter old) => false;
}

// ─── Pointer Painter ──────────────────────────────────────────────
class PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF00E5FF), Color(0xFF006064)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);

    // Glow outline
    final glowPaint = Paint()
      ..color = const Color(0xFF00E5FF).withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, glowPaint);
  }

  @override
  bool shouldRepaint(covariant PointerPainter old) => false;
}

// ─── Result Dialog ────────────────────────────────────────────────
class _ResultDialog extends StatefulWidget {
  final Reward reward;
  const _ResultDialog({required this.reward});

  @override
  State<_ResultDialog> createState() => _ResultDialogState();
}

class _ResultDialogState extends State<_ResultDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF061828),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF00E5FF).withOpacity(0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00E5FF).withOpacity(0.2),
                  blurRadius: 40,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.reward.emoji, style: const TextStyle(fontSize: 64)),
                const SizedBox(height: 12),
                const Text(
                  'YOU WON!',
                  style: TextStyle(
                    color: Color(0xFF00E5FF),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.reward.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0097A7), Color(0xFF00E5FF)],
                      ),
                    ),
                    child: const Text(
                      'CLAIM',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
