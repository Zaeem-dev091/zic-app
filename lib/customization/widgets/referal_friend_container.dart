import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReferFriendsContainer extends StatelessWidget {
  final String num;
  final String friends;
  final String coins;
  final bool isLocked;
  final bool isClaimed;
  final bool isLoading;
  final VoidCallback? onClaim;

  const ReferFriendsContainer({
    super.key,
    required this.num,
    required this.friends,
    required this.coins,
    this.isLocked = false,
    this.isClaimed = false,
    this.isLoading = false,
    this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(num, style: TextStyle(fontSize: 16.sp)),
                SizedBox(height: 4.h),
                Text(friends, style: TextStyle(fontSize: 14.sp)),
              ],
            ),
            Row(
              children: [
                Text('$coins ZIC', style: TextStyle(fontSize: 14.sp)),
                SizedBox(width: 12.w),
                buildActionButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildActionButton() {
    if (isLoading) {
      return SizedBox(
        width: 80.w,
        height: 32.h,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (isClaimed) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check, color: Colors.white, size: 18),
            SizedBox(width: 6.w),
            const Text("Completed", style: TextStyle(color: Colors.white)),
          ],
        ),
      );
    }

    if (isLocked) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: const Text("Locked", style: TextStyle(color: Colors.white)),
      );
    }

    return ElevatedButton(
      onPressed: onClaim,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      ),
      child: const Text("Claim"),
    );
  }
}
