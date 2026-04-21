import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zic/customization/app_colors.dart';

class CustomStreakContainer extends StatelessWidget {
  final String active;
  final String coins;
  final bool isLocked;
  final bool isClaimed;
  final bool isLoading;
  final VoidCallback? onClaim;

  const CustomStreakContainer({
    super.key,
    required this.active,
    required this.coins,
    this.isLocked = true,
    this.isClaimed = false,
    this.isLoading = false,
    this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/trophy.png',
                      width: 40.w,
                      height: 40.h,
                      color: isClaimed ? kSuccessGreen : null,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            textAlign: TextAlign.start,
                            active,
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
                                textAlign: TextAlign.start,
                                coins,
                                style: TextStyle(
                                  color: kSecondaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.sp,
                                ),
                              ),
                              SizedBox(width: 5.w),
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
              SizedBox(width: 10.w),
              InkWell(
                onTap: (!isLocked && !isClaimed && !isLoading) ? onClaim : null,
                child: Container(
                  height: 35.h,
                  constraints: BoxConstraints(
                    minWidth: isClaimed ? 40.w : 78.w,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
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
                            isLocked ? 'Locked' : 'Claim',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: kWhiteColor,
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
