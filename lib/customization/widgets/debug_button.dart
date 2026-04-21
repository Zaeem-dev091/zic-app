// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:zic/features/screens/home/controller/referral_controller.dart';
// import 'package:zic/utils/services/api_services.dart';

// class DebugReferralButton extends StatelessWidget {
//   const DebugReferralButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<ReferralController>();
//     final apiService = Get.find<ApiService>();

//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.amber.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.amber),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.bug_report, color: Colors.amber),
//               SizedBox(width: 8),
//               Text(
//                 'Debug Tools',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//             ],
//           ),
//           SizedBox(height: 12),
//           Obx(
//             () =>
//                 Text('Your Referral Code: ${controller.myReferralCode.value}'),
//           ),
//           Obx(
//             () => Text('Total Referrals: ${controller.totalReferrals.value}'),
//           ),
//           Obx(() => Text('Tiers Available: ${controller.tiers.length}')),
//           SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     Get.snackbar('Debug', 'Checking referral status...');
//                     await controller.fetchReferralStatus();
//                     Get.snackbar(
//                       'Debug',
//                       'Total referrals: ${controller.totalReferrals.value}',
//                       duration: Duration(seconds: 5),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.amber,
//                   ),
//                   child: Text('Check Referrals'),
//                 ),
//               ),
//               SizedBox(width: 8),
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: Text('Debug Info'),
//                         content: Obx(
//                           () => Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Token exists: ${apiService.token.value.isNotEmpty}',
//                               ),
//                               Text(
//                                 'Token length: ${apiService.token.value.length}',
//                               ),
//                               Text(
//                                 'User data: ${apiService.user.value.keys.join(', ')}',
//                               ),
//                               Text(
//                                 'Referral code: ${controller.myReferralCode.value}',
//                               ),
//                             ],
//                           ),
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: Text('Close'),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                   child: Text('View State'),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
