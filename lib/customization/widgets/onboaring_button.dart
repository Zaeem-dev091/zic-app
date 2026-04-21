//  import 'package:flutter/material.dart';

// Widget _buildDynamicButton() {
//     String buttonText;
//     IconData buttonIcon;

//     switch (controller.currentPage.value) {
//       case 0:
//         buttonText = 'Next';
//         buttonIcon = Icons.arrow_forward;
//         break;
//       case 1:
//         buttonText = 'Next Step';
//         buttonIcon = Icons.arrow_forward;
//         break;
//       case 2:
//         buttonText = 'Completed';
//         buttonIcon = Icons.check_circle;
//         break;
//       default:
//         buttonText = 'Next';
//         buttonIcon = Icons.arrow_forward;
//     }

//     return GestureDetector(
//       onTap: controller.nextPage,
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: 24.w,
//           vertical: 12.h,
//         ),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(colors: kPrimaryGradient),
//           borderRadius: BorderRadius.circular(30.r),
//           boxShadow: [
//             BoxShadow(
//               color: kPrimaryColor.withOpacity(0.3),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Text(
//               buttonText,
//               style: TextStyle(
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//             SizedBox(width: 8.w),
//             Icon(
//               buttonIcon,
//               color: Colors.white,
//               size: 20.sp,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
