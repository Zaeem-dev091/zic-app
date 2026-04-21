// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:spinning_wheel/spinning_wheel.dart';
// import 'package:zic/features/screens/home/screens/home/spining_wheel/controller.dart';

// class SpinWheelDialog extends StatelessWidget {
//   const SpinWheelDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<SpinWheelControllerX>();
//     final screen = MediaQuery.of(context).size;
//     final double wheelSize = min(310.0, max(220.0, screen.width - 96.0));

//     return Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
//       child: ConstrainedBox(
//         constraints: BoxConstraints(
//           maxWidth: 390,
//           maxHeight: screen.height * 0.9,
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(28),
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF182430), Color(0xFF0D1622), Color(0xFF08111B)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               border: Border.all(
//                 color: const Color(0xFF95A0AA).withValues(alpha: 0.78),
//                 width: 1.1,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.5),
//                   blurRadius: 22,
//                   offset: const Offset(0, 14),
//                 ),
//                 BoxShadow(
//                   color: const Color(0xFF00E5FF).withValues(alpha: 0.14),
//                   blurRadius: 16,
//                 ),
//               ],
//             ),
//             child: SingleChildScrollView(
//               padding: EdgeInsets.zero,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const _DialogHeader(),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(
//                               child: _buildStatCard(
//                                 icon: Icons.paid_rounded,
//                                 label: 'Total Coins',
//                                 value: controller.totalCoins,
//                                 color: const Color(0xFFE8D59B),
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: _buildStatCard(
//                                 icon: Icons.casino_rounded,
//                                 label: 'Spins Left',
//                                 value: controller.spinsRemaining,
//                                 color: const Color(0xFF53F7FF),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         _buildWheelFrame(controller: controller, wheelSize: wheelSize),
//                         const SizedBox(height: 14),
//                         _buildResultPanel(controller),
//                         const SizedBox(height: 14),
//                         _buildSpinButton(controller),
//                         const SizedBox(height: 8),
//                         TextButton.icon(
//                           onPressed: () => Get.back(),
//                           icon: const Icon(
//                             Icons.close_rounded,
//                             color: Color(0xFF8F9AA6),
//                             size: 18,
//                           ),
//                           label: const Text(
//                             'Close',
//                             style: TextStyle(
//                               color: Color(0xFF8F9AA6),
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildWheelFrame({
//     required SpinWheelControllerX controller,
//     required double wheelSize,
//   }) {
//     return Container(
//       width: wheelSize + 14,
//       height: wheelSize + 14,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         gradient: RadialGradient(
//           colors: [
//             const Color(0xFF53F7FF).withValues(alpha: 0.2),
//             const Color(0xFF53F7FF).withValues(alpha: 0.08),
//             Colors.transparent,
//           ],
//           stops: const [0, 0.55, 1],
//         ),
//       ),
//       child: SizedBox(
//         width: wheelSize,
//         height: wheelSize,
//         child: SpinnerWheel(
//           shouldDrawBackground: false,
//           background: Image.asset(
//             'assets/images/spin.png',
//             fit: BoxFit.contain,
//           ),
//           controller: controller.wheelController,
//           segments: controller.segments,
//           onComplete: (result, index) => controller.onSpinComplete(result, index),
//           wheelColor: const Color(0xFF334F61),
//           indicatorColor: const Color(0xFF53F7FF),
//           centerChild: Container(
//             width: wheelSize * 0.17,
//             height: wheelSize * 0.17,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFAE8D4B), Color(0xFFE8D59B), Color(0xFF816A31)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF53F7FF).withValues(alpha: 0.25),
//                   blurRadius: 12,
//                 ),
//               ],
//             ),
//             child: const Icon(
//               Icons.bolt_rounded,
//               color: Color(0xFF132435),
//               size: 26,
//             ),
//           ),
//           indicator: const Icon(
//             Icons.arrow_drop_down_rounded,
//             size: 42,
//             color: Color(0xFF53F7FF),
//           ),
//           labelStyle: const WheelLabelStyle(
//             labelStyle: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w800,
//               fontSize: 12.5,
//               letterSpacing: 0.1,
//             ),
//             overflow: TextOverflow.ellipsis,
//             maxLines: 2,
//           ),
//           slicePadding: const EdgeInsets.only(top: 8),
//         ),
//       ),
//     );
//   }

//   Widget _buildResultPanel(SpinWheelControllerX controller) {
//     return Obx(() {
//       final rewardMessage = controller.selectedReward.value.trim();
//       final hasValue = rewardMessage.isNotEmpty;
//       final lower = rewardMessage.toLowerCase();
//       final isWin = lower.contains('won');
//       final isLose = lower.contains('lost');

//       final Color border = isWin
//           ? const Color(0xFFE8D59B)
//           : isLose
//               ? const Color(0xFFFF9E9E)
//               : const Color(0xFF53F7FF).withValues(alpha: 0.6);

//       final Color textColor = isWin
//           ? const Color(0xFFE8D59B)
//           : isLose
//               ? const Color(0xFFFFC7C7)
//               : const Color(0xFFE1EDF7);

//       return AnimatedContainer(
//         duration: const Duration(milliseconds: 240),
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(14),
//           gradient: const LinearGradient(
//             colors: [Color(0xFF273744), Color(0xFF162533)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           border: Border.all(color: border, width: 1.2),
//         ),
//         child: Text(
//           hasValue ? rewardMessage : 'Spin the wheel to claim your reward.',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: textColor,
//             fontSize: 15.5,
//             fontWeight: FontWeight.w700,
//             height: 1.25,
//           ),
//         ),
//       );
//     });
//   }

//   Widget _buildSpinButton(SpinWheelControllerX controller) {
//     return Obx(() {
//       final isSpinning = controller.isSpinning.value;
//       final spinsLeft = controller.spinsRemaining.value;
//       final canSpin = !isSpinning && spinsLeft > 0;

//       final label = isSpinning
//           ? 'SPINNING...'
//           : spinsLeft <= 0
//               ? 'NO SPINS LEFT'
//               : 'SPIN NOW';

//       return SizedBox(
//         height: 58,
//         width: double.infinity,
//         child: ElevatedButton.icon(
//           onPressed: canSpin ? controller.spin : null,
//           icon: Icon(
//             isSpinning ? Icons.sync_rounded : Icons.bolt_rounded,
//             color: Colors.white,
//             size: 22,
//           ),
//           label: Text(
//             label,
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w900,
//               fontSize: 16,
//               letterSpacing: 1.4,
//             ),
//           ),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF223744),
//             disabledBackgroundColor: const Color(0xFF27313B),
//             foregroundColor: Colors.white,
//             elevation: canSpin ? 8 : 1,
//             shadowColor: const Color(0xFF53F7FF).withValues(alpha: 0.32),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(18),
//               side: BorderSide(
//                 color: const Color(0xFF53F7FF).withValues(alpha: canSpin ? 0.9 : 0.3),
//                 width: 1.4,
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }

//   Widget _buildStatCard({
//     required IconData icon,
//     required String label,
//     required RxInt value,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         gradient: const LinearGradient(
//           colors: [Color(0xFF273744), Color(0xFF162533)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         border: Border.all(color: color.withValues(alpha: 0.85), width: 1.1),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: color, size: 19),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: const TextStyle(
//                     color: Color(0xFFA9B7C6),
//                     fontSize: 10.5,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Obx(
//                   () => Text(
//                     value.value.toString(),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 19,
//                       fontWeight: FontWeight.w900,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DialogHeader extends StatelessWidget {
//   const _DialogHeader();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 13),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF7D8791), Color(0xFF424B56), Color(0xFF66707A)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         border: Border(
//           bottom: BorderSide(
//             color: const Color(0xFF53F7FF).withValues(alpha: 0.4),
//           ),
//         ),
//       ),
//       child: const Text(
//         'SPIN THE WHEEL',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           color: Color(0xFF53F7FF),
//           fontSize: 21,
//           fontWeight: FontWeight.w900,
//           letterSpacing: 0.9,
//           shadows: [
//             Shadow(
//               color: Color(0x8040E0FF),
//               blurRadius: 10,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
