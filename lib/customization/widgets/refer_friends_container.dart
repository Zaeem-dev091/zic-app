import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zic/customization/app_colors.dart';

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
    this.isLocked = true,
    this.isClaimed = false,
    this.isLoading = false,
    this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if button should be tappable
    final bool isTappable =
        !isLocked && !isClaimed && !isLoading && onClaim != null;

    print('🔧 Building ReferFriendsContainer:');
    print('   - isLocked: $isLocked');
    print('   - isClaimed: $isClaimed');
    print('   - isLoading: $isLoading');
    print('   - onClaim != null: ${onClaim != null}');
    print('   - isTappable: $isTappable');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 100.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: kLightGrey,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left side content
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25.r,
                      backgroundImage: const AssetImage(
                        'assets/images/profile.png',
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            friends,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: kBlackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Text(
                                coins,
                                style: TextStyle(
                                  color: kSecondaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Image.asset(
                                'assets/images/coins.png',
                                width: 20.w,
                                height: 20.h,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Right side button
              SizedBox(
                width: isClaimed ? 45.w : (isLocked ? 75.w : 105.w),
                child: GestureDetector(
                  onTap: () {
                    print('👆 Button tapped!');
                    print('   - isTappable: $isTappable');
                    print('   - onClaim exists: ${onClaim != null}');

                    if (isTappable) {
                      print('   ✅ Calling onClaim!');
                      onClaim!();
                    } else {
                      print('   ❌ Button not tappable');
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 35.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: isClaimed
                          ? kSuccessGreen
                          : (isLocked ? kPrimaryColor : kSecondaryColor),
                    ),
                    child: Center(
                      child: isLoading
                          ? SizedBox(
                              height: 16.w,
                              width: 16.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  kWhiteColor,
                                ),
                              ),
                            )
                          : isClaimed
                          ? Icon(Icons.check, color: kWhiteColor, size: 18.w)
                          : Text(
                              isLocked ? 'Locked' : 'Claim Reward',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: kWhiteColor,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
