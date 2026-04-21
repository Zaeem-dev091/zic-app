// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:zic/customization/app_colors.dart';
// import 'package:zic/features/screens/home/controller/home_controller.dart';
// import 'package:zic/features/screens/home/screens/widgets/coin_animation.dart';

// class ZicScreen extends StatelessWidget {
//   const ZicScreen({super.key});

//   HomeController _resolveController() {
//     if (Get.isRegistered<HomeController>()) {
//       return Get.find<HomeController>();
//     }
//     return Get.put(HomeController());
//   }

//   Future<void> _handleRefresh(HomeController controller) async {
//     await controller.loadUserProfile();
//     await controller.fetchStreakStatus();
//     await controller.refreshWeeklyClaimStatus();
//     await controller.fetchUserLevels();
//   }

//   Future<void> _handleClaimReward(
//     BuildContext context,
//     HomeController controller,
//   ) async {
//     final claimed = await controller.claimReward();
//     if (!context.mounted) return;
//     if (claimed) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Weekend reward claimed successfully',
//             style: TextStyle(fontSize: 13.sp, color: kWhiteColor),
//           ),
//           backgroundColor: const Color(0xFF1A2D3D),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.r),
//             side: BorderSide(color: ZicColors.cyan.withValues(alpha: 0.5)),
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = _resolveController();

//     return Stack(
//       children: [
//         Positioned.fill(
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(30.r),
//             child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
//           ),
//         ),
//         Scaffold(
//           backgroundColor: Colors.transparent,
//           body: RefreshIndicator(
//             onRefresh: () => _handleRefresh(controller),
//             color: ZicColors.cyanDim,
//             child: Stack(
//               children: [
//                 SingleChildScrollView(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 12.w,
//                       vertical: 20.h,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         SizedBox(height: 30.h),
//                         _HeaderBar(
//                           title: 'MINE ZIC',
//                           onBackTap: () => Navigator.maybePop(context),
//                         ),
//                         SizedBox(height: 14.h),
//                         _OverviewCard(controller: controller),
//                         SizedBox(height: 12.h),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Obx(
//                                 () => _FactorCard(
//                                   title: 'LEVEL',
//                                   value: controller.currentLevelName.value,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 8.w),
//                             Expanded(
//                               child: Obx(
//                                 () => _FactorCard(
//                                   title: 'REFERRALS',
//                                   value:
//                                       '${controller.totalReferrals.value} Team',
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 8.w),
//                             Expanded(
//                               child: Obx(
//                                 () => _FactorCard(
//                                   title: 'ACTIVE',
//                                   value:
//                                       '${controller.activeMiners.value} Miner${controller.activeMiners.value == 1 ? '' : 's'}',
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 14.h),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Obx(
//                                 () => _ActionButton(
//                                   label: 'START SESSION',
//                                   icon: Icons.bolt_rounded,
//                                   // isLoading: controller.isStartingSession.value,
//                                   isLoading: controller.isClaimingReward.value,
//                                   onTap: () async {
//                                     await controller.startMiningSession();
//                                   },
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 8.w),
//                             Expanded(
//                               child: Obx(
//                                 () => _ActionButton(
//                                   label: 'CLAIM REWARD',
//                                   icon: Icons.card_giftcard_rounded,
//                                   isLoading: controller.isClaimingReward.value,
//                                   onTap: () =>
//                                       _handleClaimReward(context, controller),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 10.h),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: _SocialButton(
//                                 label: 'TELEGRAM',
//                                 icon: Icons.telegram_rounded,
//                                 onTap: controller.openTelegram,
//                               ),
//                             ),
//                             SizedBox(width: 8.w),
//                             Expanded(
//                               child: _SocialButton(
//                                 label: 'X / TWITTER',
//                                 icon: Icons.alternate_email_rounded,
//                                 onTap: controller.openX,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 14.h),
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 12.w,
//                             vertical: 16.h,
//                           ),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16.r),
//                             gradient: const LinearGradient(
//                               colors: [Color(0xFF101C27), Color(0xFF0A1119)],
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                             ),
//                             border: Border.all(
//                               color: ZicColors.cyan.withValues(alpha: 0.16),
//                             ),
//                           ),
//                           child: Text(
//                             'Zic Mainnet Launching Soon\nDevelopment in progress...',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: kWhiteColor.withValues(alpha: 0.76),
//                               fontSize: 14.sp,
//                               fontWeight: FontWeight.w600,
//                               height: 1.45,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 4.h),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _HeaderBar extends StatelessWidget {
//   final String title;
//   final VoidCallback onBackTap;

//   const _HeaderBar({required this.title, required this.onBackTap});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(8.w),
//       decoration: _steelDecoration(radius: 22.r, glow: 0.18),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: onBackTap,
//             child: Container(
//               height: 44.w,
//               width: 44.w,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12.r),
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF4D5966), Color(0xFF273340)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 border: Border.all(
//                   color: ZicColors.cyan.withValues(alpha: 0.45),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: ZicColors.cyan.withValues(alpha: 0.24),
//                     blurRadius: 10,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Icon(
//                 Icons.arrow_back_rounded,
//                 color: ZicColors.cyan,
//                 size: 26.w,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               title,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: ZicColors.cyan,
//                 fontSize: 24.sp,
//                 fontWeight: FontWeight.w900,
//                 letterSpacing: 0.8,
//                 shadows: [
//                   Shadow(
//                     color: ZicColors.cyan.withValues(alpha: 0.35),
//                     blurRadius: 10,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(width: 44.w),
//         ],
//       ),
//     );
//   }
// }

// class _OverviewCard extends StatelessWidget {
//   final HomeController controller;

//   const _OverviewCard({required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(12.w),
//       decoration: _steelDecoration(radius: 20.r, glow: 0.2),
//       child: Obx(
//         () => Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   height: 70.w,
//                   width: 70.w,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: const LinearGradient(
//                       colors: [
//                         Color(0xFFAE8D4B),
//                         Color(0xFFE8D59B),
//                         Color(0xFF816A31),
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                   ),
//                   padding: EdgeInsets.all(2.2.w),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFF1D2E40), Color(0xFF102233)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       border: Border.all(
//                         color: ZicColors.cyan.withValues(alpha: 0.5),
//                         width: 1.1,
//                       ),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(10.w),
//                       child: AutoFlipImage(),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10.w),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'CURRENT ZIC',
//                         style: TextStyle(
//                           color: kWhiteColor.withValues(alpha: 0.76),
//                           fontSize: 12.sp,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(height: 2.h),
//                       Text(
//                         '${controller.balanceLabel} Z',
//                         style: TextStyle(
//                           color: ZicColors.cyan,
//                           fontSize: 42.sp,
//                           fontWeight: FontWeight.w900,
//                           height: 1,
//                           shadows: [
//                             Shadow(
//                               color: ZicColors.cyan.withValues(alpha: 0.32),
//                               blurRadius: 10,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10.h),
//             // _DetailRow(
//             //   label: 'ZIC SESSION ENDS',
//             //   value: controller.sessionTimeLabel,
//             //   valueColor: controller.hasActiveSession
//             //       ? ZicColors.cyan
//             //       : kWhiteColor.withValues(alpha: 0.66),
//             // ),
//             SizedBox(height: 4.h),
//             _DetailRow(
//               label: 'TOTAL ZIC RATE',
//               value: '${controller.miningRateLabel} Z /sec',
//               valueColor: ZicColors.cyan.withValues(alpha: 0.92),
//             ),
//             SizedBox(height: 4.h),
//             // _DetailRow(
//             //   label: 'CURRENT SESSION',
//             //   value:
//             //       '${controller.earnedSoFarLabel} / ${controller.maxRewardLabel} Z',
//             //   valueColor: kWhiteColor.withValues(alpha: 0.82),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _DetailRow extends StatelessWidget {
//   final String label;
//   final String value;
//   final Color valueColor;

//   const _DetailRow({
//     required this.label,
//     required this.value,
//     required this.valueColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Text(
//             '$label:',
//             style: TextStyle(
//               color: kWhiteColor.withValues(alpha: 0.72),
//               fontSize: 12.sp,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//         SizedBox(width: 8.w),
//         Text(
//           value,
//           style: TextStyle(
//             color: valueColor,
//             fontSize: 12.sp,
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _FactorCard extends StatelessWidget {
//   final String title;
//   final String value;

//   const _FactorCard({required this.title, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 9.h),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(14.r),
//         gradient: const LinearGradient(
//           colors: [Color(0xFF2A3A46), Color(0xFF18232D)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.35)),
//       ),
//       child: Column(
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               color: kWhiteColor.withValues(alpha: 0.75),
//               fontSize: 10.sp,
//               fontWeight: FontWeight.w700,
//               letterSpacing: 0.4,
//             ),
//           ),
//           SizedBox(height: 2.h),
//           Text(
//             value,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               color: ZicColors.cyan,
//               fontSize: 12.sp,
//               fontWeight: FontWeight.w800,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ActionButton extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final VoidCallback onTap;
//   final bool isLoading;

//   const _ActionButton({
//     required this.label,
//     required this.icon,
//     required this.onTap,
//     required this.isLoading,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: isLoading ? null : onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 11.h),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16.r),
//           gradient: const LinearGradient(
//             colors: [Color(0xFF223744), Color(0xFF0E1721)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//           border: Border.all(
//             color: ZicColors.cyan.withValues(alpha: 0.72),
//             width: 1.4,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: ZicColors.cyan.withValues(alpha: 0.26),
//               blurRadius: 14,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: isLoading
//             ? Center(
//                 child: SizedBox(
//                   width: 18.w,
//                   height: 18.w,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2.2,
//                     color: ZicColors.cyan,
//                   ),
//                 ),
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(icon, color: ZicColors.cyan, size: 18.w),
//                   SizedBox(width: 6.w),
//                   Flexible(
//                     child: Text(
//                       label,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: ZicColors.cyan,
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.w900,
//                         letterSpacing: 0.35,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }

// class _SocialButton extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final VoidCallback onTap;

//   const _SocialButton({
//     required this.label,
//     required this.icon,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(14.r),
//           gradient: const LinearGradient(
//             colors: [Color(0xFF2A3A46), Color(0xFF17222D)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.32)),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: ZicColors.cyan, size: 16.w),
//             SizedBox(width: 5.w),
//             Flexible(
//               child: Text(
//                 label,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   color: kWhiteColor.withValues(alpha: 0.85),
//                   fontSize: 11.sp,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// BoxDecoration _steelDecoration({required double radius, double glow = 0.2}) {
//   return BoxDecoration(
//     borderRadius: BorderRadius.circular(radius),
//     gradient: const LinearGradient(
//       colors: [Color(0xFF44515E), Color(0xFF2A3541), Color(0xFF3D4853)],
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//     ),
//     border: Border.all(color: const Color(0xFF85909C).withValues(alpha: 0.75)),
//     boxShadow: [
//       BoxShadow(
//         color: Colors.black.withValues(alpha: 0.3),
//         blurRadius: 10,
//         offset: const Offset(0, 6),
//       ),
//       BoxShadow(
//         color: ZicColors.cyan.withValues(alpha: glow),
//         blurRadius: 12,
//         spreadRadius: 0.6,
//       ),
//     ],
//   );
// }
