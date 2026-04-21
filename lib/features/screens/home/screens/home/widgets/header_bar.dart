import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/features/screens/home/controller/profile_controller.dart';
import 'package:zic/features/screens/home/screens/home/home.dart';
import 'package:zic/features/screens/home/screens/home/widgets/avatar.dart';
import 'package:zic/features/screens/home/screens/home/widgets/icon_button.dart';
import 'package:zic/features/screens/home/screens/home/widgets/miner_chip.dart';
import 'package:zic/features/screens/home/screens/home/widgets/steel_panel.dart';
import 'package:zic/features/screens/home/screens/settings/settings_screen.dart';
import 'package:zic/features/screens/home/screens/info/info_screen_one.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return SteelPanel(
      accent: T.cyan,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Avatar(
                onTap: () => Get.to(
                  () => const SettingsScreen(),
                  transition: Transition.fadeIn,
                ),
              ),
              SizedBox(width: 8.w),
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.name.value.trim().isEmpty
                          ? '@user'
                          : controller.name.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (controller.referralNo.value.trim().isNotEmpty)
                      Text(
                        controller.email.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: T.cyan.withValues(alpha: 0.82),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconBtn(
                icon: Icons.notifications_outlined,
                accent: T.cyan,
                onTap: () => Get.to(
                  () => const InfoScreenOne(),
                  transition: Transition.fadeIn,
                ),
              ),
              SizedBox(width: 8.w),

              Flexible(child: MinerChip()),
            ],
          ),
        ],
      ),
    );
  }
}
