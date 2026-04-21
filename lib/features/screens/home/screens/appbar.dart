// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:zic/customization/app_colors.dart';
// import 'package:zic/features/screens/home/controller/home_controller.dart';
// import 'package:zic/features/screens/home/screens/info/info_screen_one.dart';
// import 'package:zic/features/screens/home/screens/settings/test_settings_screen.dart';
// import 'package:zic/features/screens/home/view/settings.dart';

// class ZicBar extends StatelessWidget {
//   const ZicBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<HomeController>();
//     return Container(
//       height: 70.h,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(50.r),

//         color: ZicColors.cyanDim,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: () => Get.to(
//                 () => const TestSettingsScreen(),
//                 transition: Transition.fadeIn,
//               ),
//               child: CircleAvatar(
//                 radius: 22.w,
//                 backgroundColor: kPrimarySoft,
//                 backgroundImage: const AssetImage('assets/images/profile.png'),
//               ),
//             ),
//             SizedBox(width: 10.w),
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Obx(
//                     () => Text(
//                       controller.userName.value.isNotEmpty
//                           ? '@${controller.userName.value}'
//                           : 'Empty',
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: kWhiteColor,
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Info button
//             GestureDetector(
//               onTap: () => Get.to(
//                 () => const InfoScreenOne(),
//                 transition: Transition.fadeIn,
//               ),
//               child: Container(
//                 width: 36.w,
//                 height: 36.w,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: kBlackColor.withOpacity(0.4),
//                 ),
//                 child: Center(
//                   child: Image.asset(
//                     'assets/icons/question.png',
//                     height: 25.h,
//                     width: 25.w,
//                     color: kWhiteColor,
//                   ),
//                 ),
//               ),
//             ),

//             // Settings button
//             SizedBox(width: 10.h),
//             Container(
//               width: 85.w,
//               height: 35.h,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20.r),
//                 color: kBlackColor.withOpacity(0.4),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Active Minet',
//                     style: TextStyle(
//                       color: kWhiteColor,
//                       fontSize: 12.sp,
//                       letterSpacing: 0.6,
//                     ),
//                   ),
//                   Obx(
//                     () => Text(
//                       controller.hasActiveSession
//                           ? controller.sessionTimeLabel
//                           : '0:00',
//                       style: TextStyle(
//                         color: Color(0xff68eee6),
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
