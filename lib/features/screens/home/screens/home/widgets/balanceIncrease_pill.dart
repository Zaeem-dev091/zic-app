import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/controller/profile_controller.dart';

class BalanceIncreasePill extends StatefulWidget {
  final ProfileController controller;

  const BalanceIncreasePill({required this.controller, super.key});

  @override
  State<BalanceIncreasePill> createState() => _BalanceIncreasePillState();
}

class _BalanceIncreasePillState extends State<BalanceIncreasePill>
    with SingleTickerProviderStateMixin {
  static const double _epsilon = 0.000001;

  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  Worker? _worker;
  Timer? _hideTimer;

  double _lastBalance = 0;
  double _increaseValue = 0;

  @override
  void initState() {
    super.initState();

    _lastBalance = widget.controller.walletBalance.value;

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 350),
    );

    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    _worker = ever<double>(widget.controller.walletBalance, _onBalanceChanged);
  }

  void _onBalanceChanged(double newBalance) {
    final diff = newBalance - _lastBalance;
    _lastBalance = newBalance;

    if (diff <= _epsilon || !mounted) return;

    setState(() => _increaseValue = diff);

    _ctrl.forward(from: 0);

    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) _ctrl.reverse();
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _worker?.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: ZicColors.cyan.withValues(alpha: 0.15),
            border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.trending_up_rounded,
                color: ZicColors.cyan,
                size: 14.w,
              ),
              SizedBox(width: 4.w),
              Text(
                '+${_increaseValue.toStringAsFixed(6)} ZIC',
                style: TextStyle(
                  color: ZicColors.cyan,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
