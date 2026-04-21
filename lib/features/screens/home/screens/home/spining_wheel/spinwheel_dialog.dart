import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:zic/features/screens/home/screens/home/spining_wheel/controller.dart';

class SpinWheelDialog extends StatelessWidget {
  const SpinWheelDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SpinWheelControllerX>();
    final screen = MediaQuery.of(context).size;
    final double wheelSize = min(310.0, max(220.0, screen.width - 96.0));

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 390,
          maxHeight: screen.height * 0.92,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF182430),
                  Color(0xFF0D1622),
                  Color(0xFF08111B),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border.all(
                color: const Color(0xFF95A0AA).withValues(alpha: 0.78),
                width: 1.1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 22,
                  offset: const Offset(0, 14),
                ),
                BoxShadow(
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.14),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Obx(() {
              if (controller.isLoading.value) {
                return const _LoadingState();
              }

              if (controller.segments.isEmpty) {
                return _ErrorState(onRetry: controller.loadRewardsPublic);
              }

              return SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _DialogHeader(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ── Stats row ──
                          Row(
                            children: [
                              Expanded(child: _buildSpinsCard(controller)),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // ── Wheel ──
                          _buildWheelFrame(
                            controller: controller,
                            wheelSize: wheelSize,
                          ),
                          const SizedBox(height: 14),

                          // ── Result panel ──
                          _buildResultPanel(controller),
                          const SizedBox(height: 14),

                          // ── Spin button ──
                          _buildSpinButton(controller),
                          const SizedBox(height: 8),

                          // ── Close ──
                          TextButton.icon(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Color(0xFF8F9AA6),
                              size: 18,
                            ),
                            label: const Text(
                              'Close',
                              style: TextStyle(
                                color: Color(0xFF8F9AA6),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // ─── Spins Card ───
  Widget _buildSpinsCard(SpinWheelControllerX controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFF273744), Color(0xFF162533)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFF53F7FF).withValues(alpha: 0.85),
          width: 1.1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.casino_rounded, color: Color(0xFF53F7FF), size: 19),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Spins Left',
                  style: TextStyle(
                    color: Color(0xFFA9B7C6),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Obx(
                  () => Text(
                    // Show '?' until first spin reveals real value
                    controller.hasSpunOnce.value
                        ? controller.spinsLeft.value.toString()
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Wheel Frame ───
  Widget _buildWheelFrame({
    required SpinWheelControllerX controller,
    required double wheelSize,
  }) {
    return Container(
      width: wheelSize + 14,
      height: wheelSize + 14,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFF53F7FF).withValues(alpha: 0.2),
            const Color(0xFF53F7FF).withValues(alpha: 0.08),
            Colors.transparent,
          ],
          stops: const [0, 0.55, 1],
        ),
      ),
      child: Obx(
        () => Stack(
          alignment: Alignment.center,
          children: [
            // ── Wheel ──────────────────────────────────────────────
            SizedBox(
              width: wheelSize,
              height: wheelSize,
              child: FortuneWheel(
                selected: controller.spinStream.stream,
                animateFirst: false,
                duration: const Duration(seconds: 4),
                onAnimationEnd: controller.onSpinComplete,

                indicators: const [
                  FortuneIndicator(
                    alignment: Alignment.topCenter,
                    child: TriangleIndicator(
                      color: Color(0xFF53F7FF),
                      width: 28,
                      height: 28,
                    ),
                  ),
                ],

                items: controller.segments.map((seg) {
                  return FortuneItem(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        seg.label,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 11.5,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                    style: FortuneItemStyle(
                      color: seg.color,
                      borderColor: const Color(0xFF334F61),
                      borderWidth: 2,
                    ),
                  );
                }).toList(),
              ),
            ),

            // ── Center bolt button (overlaid via Stack) ────────────
            // fortune_wheel has no centerChild prop — Stack handles this
            IgnorePointer(
              child: Container(
                width: wheelSize * 0.17,
                height: wheelSize * 0.17,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFAE8D4B),
                      Color(0xFFE8D59B),
                      Color(0xFF816A31),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF53F7FF).withValues(alpha: 0.25),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  color: Color(0xFF132435),
                  size: 26,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Result Panel ───
  Widget _buildResultPanel(SpinWheelControllerX controller) {
    return Obx(() {
      final msg = controller.selectedReward.value.trim();
      final hasMsg = msg.isNotEmpty;
      final lower = msg.toLowerCase();
      final isWin = lower.contains('won');
      final isLose = lower.contains('luck');

      final Color border = isWin
          ? const Color(0xFFE8D59B)
          : isLose
          ? const Color(0xFFFF9E9E)
          : const Color(0xFF53F7FF).withValues(alpha: 0.6);

      final Color textColor = isWin
          ? const Color(0xFFE8D59B)
          : isLose
          ? const Color(0xFFFFC7C7)
          : const Color(0xFFE1EDF7);

      return AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Color(0xFF273744), Color(0xFF162533)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: border, width: 1.2),
        ),
        child: Text(
          hasMsg ? msg : 'Spin the wheel to claim your reward.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
        ),
      );
    });
  }

  // ─── Spin Button ───
  Widget _buildSpinButton(SpinWheelControllerX controller) {
    return Obx(() {
      final isSpinning = controller.isSpinning.value;
      final isClaiming = controller.isClaiming.value;
      final busy = isSpinning || isClaiming;

      // Only block if we KNOW spins are 0 (after at least one spin)
      final noSpins =
          controller.hasSpunOnce.value && controller.spinsLeft.value <= 0;
      final canSpin = !busy && !noSpins;

      final String label;
      final IconData icon;

      if (isClaiming) {
        label = 'CONNECTING...';
        icon = Icons.cloud_sync_rounded;
      } else if (isSpinning) {
        label = 'SPINNING...';
        icon = Icons.sync_rounded;
      } else if (noSpins) {
        label = 'NO SPINS LEFT';
        icon = Icons.block_rounded;
      } else {
        label = 'SPIN NOW';
        icon = Icons.bolt_rounded;
      }

      return SizedBox(
        height: 58,
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: canSpin ? controller.spin : null,
          icon: busy
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                )
              : Icon(icon, color: Colors.white, size: 22),
          label: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 16,
              letterSpacing: 1.4,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF223744),
            disabledBackgroundColor: const Color(0xFF27313B),
            foregroundColor: Colors.white,
            elevation: canSpin ? 8 : 1,
            shadowColor: const Color(0xFF53F7FF).withValues(alpha: 0.32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color: const Color(
                  0xFF53F7FF,
                ).withValues(alpha: canSpin ? 0.9 : 0.3),
                width: 1.4,
              ),
            ),
          ),
        ),
      );
    });
  }
}

// ─── Header ───
class _DialogHeader extends StatelessWidget {
  const _DialogHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7D8791), Color(0xFF424B56), Color(0xFF66707A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF53F7FF).withValues(alpha: 0.4),
          ),
        ),
      ),
      child: const Text(
        'SPIN THE WHEEL',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF53F7FF),
          fontSize: 21,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.9,
          shadows: [Shadow(color: Color(0x8040E0FF), blurRadius: 10)],
        ),
      ),
    );
  }
}

// ─── Loading State ───
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Color(0xFF53F7FF), strokeWidth: 2.5),
          SizedBox(height: 18),
          Text(
            'Loading wheel...',
            style: TextStyle(
              color: Color(0xFF8F9AA6),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Error State ───
class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            color: Color(0xFFFF6B6B),
            size: 48,
          ),
          const SizedBox(height: 14),
          const Text(
            'Failed to load rewards',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Check your connection and try again.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF8F9AA6), fontSize: 13),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF223744),
              foregroundColor: const Color(0xFF53F7FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Color(0xFF53F7FF)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
