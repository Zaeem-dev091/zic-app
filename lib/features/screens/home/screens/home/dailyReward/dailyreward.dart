import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/controller/daily_reward_controller.dart';
import 'package:zic/utils/models/dailyreward.dart';

class DailyRewardOverlay extends StatefulWidget {
  const DailyRewardOverlay({super.key});

  @override
  State<DailyRewardOverlay> createState() => _DailyRewardOverlayState();
}

class _DailyRewardOverlayState extends State<DailyRewardOverlay>
    with TickerProviderStateMixin {
  late AnimationController _fallController;
  late AnimationController _shakeController;
  late AnimationController _particleController;
  late AnimationController _panelController;

  late Animation<double> _fallAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _panelAnimation;

  bool _isShaking = false;
  bool _showParticles = false;
  bool _showPanel = false;

  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();

    _fallController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fallAnimation = CurvedAnimation(
      parent: _fallController,
      curve: Curves.bounceOut,
    );
    _fallController.forward();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _panelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _panelAnimation = CurvedAnimation(
      parent: _panelController,
      curve: Curves.easeOutBack,
    );

    _generateParticles();
  }

  void _generateParticles() {
    final rng = Random();
    _particles.clear();
    for (int i = 0; i < 20; i++) {
      _particles.add(_Particle(rng));
    }
  }

  Future<void> _onTapBox() async {
    if (_isShaking || _showPanel) return;

    if (!Get.isRegistered<DailyRewardController>()) {
      debugPrint('DailyRewardController not registered');
      return;
    }

    setState(() => _isShaking = true);

    await _shakeController.forward();
    _shakeController.reset();

    final ctrl = Get.find<DailyRewardController>();

    // Show loading indicator or disable further taps
    await ctrl.claimReward();

    setState(() => _showParticles = true);
    _particleController.forward(from: 0);

    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() {
        _showPanel = true;
        _isShaking = false;
      });
      _panelController.forward(from: 0);
    }
  }

  void _onCollect() {
    if (!Get.isRegistered<DailyRewardController>()) return;

    final ctrl = Get.find<DailyRewardController>();

    // Dismiss the overlay
    ctrl.dismissOverlay();

    // Reset local state for next time
    setState(() {
      _showPanel = false;
      _showParticles = false;
      _isShaking = false;
    });

    // Reset animations
    _panelController.reset();
    _particleController.reset();

    // Restart fall animation for next time
    _fallController.forward(from: 0);
  }

  @override
  void dispose() {
    _fallController.dispose();
    _shakeController.dispose();
    _particleController.dispose();
    _panelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<DailyRewardController>()) {
      return const SizedBox.shrink();
    }

    try {
      final ctrl = Get.find<DailyRewardController>();

      return Obx(() {
        if (!ctrl.showOverlay.value) return const SizedBox.shrink();

        return Container(
          color: Colors.black.withOpacity(0.75),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Particles
              if (_showParticles)
                AnimatedBuilder(
                  animation: _particleController,
                  builder: (_, _) => CustomPaint(
                    size: Size(1.sw, 1.sh),
                    painter: _ParticlePainter(
                      particles: _particles,
                      progress: _particleController.value,
                    ),
                  ),
                ),

              // Gift box or reward panel
              if (!_showPanel) _buildGiftBox() else _buildRewardPanel(ctrl),
            ],
          ),
        );
      });
    } catch (e) {
      debugPrint('Error building DailyRewardOverlay: $e');
      return const SizedBox.shrink();
    }
  }

  Widget _buildGiftBox() {
    return AnimatedBuilder(
      animation: Listenable.merge([_fallAnimation, _shakeAnimation]),
      builder: (_, _) {
        final fallOffset = Tween<double>(
          begin: -300,
          end: 0,
        ).evaluate(_fallAnimation);

        final shakeOffset = _isShaking ? _shakeAnimation.value * 10.0 : 0.0;

        return Transform.translate(
          offset: Offset(shakeOffset, fallOffset),
          child: GestureDetector(
            onTap: _onTapBox,
            behavior: HitTestBehavior.opaque, // Ensures tap is registered
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.9, end: 1.0),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.elasticOut,
                  builder: (_, value, _) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.cyan.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Text(
                          '🎁',
                          style: TextStyle(
                            fontSize: 90.sp,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(
                      color: ZicColors.cyan.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Tap to claim your\ndaily reward!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRewardPanel(DailyRewardController ctrl) {
    return ScaleTransition(
      scale: _panelAnimation,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A2A3A), Color(0xFF0D1821)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: ZicColors.cyan, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: ZicColors.cyan.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Colors.white, ZicColors.cyan, Colors.white],
                stops: const [0.0, 0.5, 1.0],
              ).createShader(bounds),
              child: Text(
                '🎉 Reward Claimed!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8.h),

            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (_, value, _) {
                return Transform.scale(
                  scale: value,
                  child: Obx(
                    () => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFFFD67A).withOpacity(0.2),
                            const Color(0xFFFFD67A).withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                          color: const Color(0xFFFFD67A).withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            color: const Color(0xFFFFD67A),
                            size: 28.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '+${ctrl.claimedAmount.value}',
                            style: TextStyle(
                              color: const Color(0xFFFFD67A),
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            ' Coins',
                            style: TextStyle(
                              color: const Color(0xFFFFD67A).withOpacity(0.8),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 24.h),

            Obx(() => _buildStreakBar(ctrl.rewards)),
            SizedBox(height: 24.h),

            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutBack,
              builder: (_, value, _) {
                return Transform.scale(
                  scale: value,
                  child: GestureDetector(
                    onTap: _onCollect, // Use separate method
                    behavior:
                        HitTestBehavior.opaque, // Ensure tap is registered
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ZicColors.cyan,
                            ZicColors.cyan.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: ZicColors.cyan.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.black,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Collect',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakBar(List<DailyRewardItem> rewards) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rewards.map((r) {
          final isClaimed = r.isClaimed;
          final isToday = r.isClaimNow;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (r.rewardNo > 1)
                    Container(
                      width: 20.w,
                      height: 2,
                      color: isClaimed
                          ? ZicColors.cyan.withOpacity(0.5)
                          : Colors.white.withOpacity(0.1),
                    ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isClaimed
                          ? LinearGradient(
                              colors: [
                                ZicColors.cyan,
                                ZicColors.cyan.withOpacity(0.7),
                              ],
                            )
                          : isToday
                          ? LinearGradient(
                              colors: [
                                const Color(0xFFFFD67A),
                                const Color(0xFFFFD67A).withOpacity(0.7),
                              ],
                            )
                          : null,
                      color: !isClaimed && !isToday ? Colors.white12 : null,
                      border: Border.all(
                        color: isToday
                            ? const Color(0xFFFFD67A)
                            : isClaimed
                            ? ZicColors.cyan
                            : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: isToday || isClaimed
                          ? [
                              BoxShadow(
                                color:
                                    (isToday
                                            ? const Color(0xFFFFD67A)
                                            : ZicColors.cyan)
                                        .withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          isClaimed ? Icons.check : Icons.star,
                          key: ValueKey(isClaimed),
                          color: isClaimed || isToday
                              ? Colors.black
                              : Colors.white38,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                  if (r.rewardNo < 7)
                    Container(
                      width: 20.w,
                      height: 2,
                      color: isClaimed
                          ? ZicColors.cyan.withOpacity(0.5)
                          : Colors.white.withOpacity(0.1),
                    ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                '${r.amount}',
                style: TextStyle(
                  color: isClaimed
                      ? ZicColors.cyan
                      : isToday
                      ? const Color(0xFFFFD67A)
                      : Colors.white38,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Day ${r.rewardNo}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// Keep the _Particle and _ParticlePainter classes as they are
class _Particle {
  final double angle;
  final double speed;
  final Color color;
  final double size;

  _Particle(Random rng)
    : angle = rng.nextDouble() * 2 * pi,
      speed = 100 + rng.nextDouble() * 150,
      size = 3 + rng.nextDouble() * 8,
      color = [
        const Color(0xFF4DD9C0),
        const Color(0xFFFFD67A),
        Colors.white,
        Colors.pinkAccent,
        const Color(0xFF7C83FD),
        const Color(0xFF96BAFF),
      ][rng.nextInt(6)];
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final p in particles) {
      final dist = p.speed * progress;
      final dx = center.dx + dist * cos(p.angle);
      final dy = center.dy + dist * sin(p.angle) - (progress * 60);

      final opacity = (1 - progress).clamp(0.0, 1.0);

      final glowPaint = Paint()
        ..color = p.color.withOpacity(opacity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(Offset(dx, dy), p.size * 1.5, glowPaint);

      final paint = Paint()
        ..color = p.color.withOpacity(opacity)
        ..strokeCap = StrokeCap.round;

      canvas.drawCircle(Offset(dx, dy), p.size * (1 - progress * 0.5), paint);

      if (progress < 0.7) {
        final trailPaint = Paint()
          ..color = p.color.withOpacity(opacity * 0.5)
          ..strokeWidth = 2;

        final trailX = center.dx + (dist * 0.7) * cos(p.angle);
        final trailY =
            center.dy + (dist * 0.7) * sin(p.angle) - (progress * 40);

        canvas.drawLine(Offset(dx, dy), Offset(trailX, trailY), trailPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) {
    return old.progress != progress;
  }
}
