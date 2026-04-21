import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/customization/widgets/feedback_style_snackbar.dart';
import 'package:zic/features/screens/home/controller/feedback_controller.dart';

class FeedBackScreen extends StatelessWidget {
  const FeedBackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FeedbackController());

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20.h),
                    _HeaderBar(
                      title: 'FEEDBACK',
                      onBackTap: () => Navigator.maybePop(context),
                    ),
                    SizedBox(height: 14.h),
                    const _IntroCard(),
                    SizedBox(height: 14.h),
                    _SectionTitle(title: 'Rate Your Experience'),
                    SizedBox(height: 8.h),
                    Obx(
                      () => _RatingStars(
                        rating: controller.rating.value,
                        onTap: controller.setRating,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    _SectionTitle(title: 'Feedback Category'),
                    SizedBox(height: 8.h),
                    Obx(
                      () => _CategoryDropdown(
                        categories: controller.categories,
                        selectedValue: controller.selectedCategory.value,
                        onChanged: (value) {
                          if (value != null) controller.setCategory(value);
                        },
                      ),
                    ),
                    SizedBox(height: 14.h),
                    _SectionTitle(title: 'Your Feedback'),
                    SizedBox(height: 8.h),
                    _FeedbackInput(
                      controller: controller.feedbackTextController,
                    ),
                    SizedBox(height: 8.h),
                    _AttachmentTile(
                      onTap: () => _showSnack(
                        'Screenshot attachment will be available soon.',
                        success: true,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Obx(
                      () => _SubmitButton(
                        isLoading: controller.isSubmitting.value,
                        onTap: () => controller.submitFeedback(
                          onResult: (message, {required success}) =>
                              _showSnack(message, success: success),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    const _FooterHint(),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(String text, {required bool success}) {
    showFeedbackStyleSnackbar(message: text, success: success);
  }
}

// ─────────────────────────────────────────────────────────────
// HEADER BAR
// ─────────────────────────────────────────────────────────────

class _HeaderBar extends StatelessWidget {
  final String title;
  final VoidCallback onBackTap;

  const _HeaderBar({required this.title, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: _steelDecoration(radius: 22.r, glow: 0.18),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBackTap,
            child: Container(
              height: 44.w,
              width: 44.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4D5966), Color(0xFF273340)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: ZicColors.cyan.withValues(alpha: 0.45),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ZicColors.cyan.withValues(alpha: 0.24),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: ZicColors.cyan,
                size: 26.w,
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ZicColors.cyan,
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
                shadows: [
                  Shadow(
                    color: ZicColors.cyan.withValues(alpha: 0.35),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 44.w),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// INTRO CARD
// ─────────────────────────────────────────────────────────────

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: _steelDecoration(radius: 18.r, glow: 0.15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 44.w,
            width: 44.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: const LinearGradient(
                colors: [Color(0xFF223744), Color(0xFF0E1721)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.65)),
            ),
            child: Icon(
              Icons.feedback_outlined,
              color: ZicColors.cyan,
              size: 22.w,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WE VALUE YOUR FEEDBACK',
                  style: TextStyle(
                    color: ZicColors.cyan,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.35,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Your ideas help us improve the Zic experience for everyone.',
                  style: TextStyle(
                    color: kWhiteColor.withValues(alpha: 0.78),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SECTION TITLE
// ─────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: kWhiteColor.withValues(alpha: 0.82),
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.45,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// RATING STARS
// ─────────────────────────────────────────────────────────────

class _RatingStars extends StatelessWidget {
  final double rating;
  final ValueChanged<int> onTap;

  const _RatingStars({required this.rating, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF223744), Color(0xFF0E1721)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(5, (index) {
          final starNumber = index + 1;
          final isSelected = starNumber <= rating;

          return GestureDetector(
            onTap: () => onTap(starNumber),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: EdgeInsets.all(7.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: isSelected
                    ? ZicColors.cyan.withValues(alpha: 0.16)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? ZicColors.cyan.withValues(alpha: 0.72)
                      : kWhiteColor.withValues(alpha: 0.16),
                ),
              ),
              child: Icon(
                isSelected ? Icons.star_rounded : Icons.star_border_rounded,
                color: isSelected ? const Color(0xFFFFD67A) : kWhiteColor,
                size: 28.w,
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CATEGORY DROPDOWN
// ─────────────────────────────────────────────────────────────

class _CategoryDropdown extends StatelessWidget {
  final List<String> categories;
  final String selectedValue;
  final ValueChanged<String?> onChanged;

  const _CategoryDropdown({
    required this.categories,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF223744), Color(0xFF0E1721)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.45)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          isExpanded: true,
          dropdownColor: const Color(0xFF162635),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: ZicColors.cyan),
          borderRadius: BorderRadius.circular(14.r),
          style: TextStyle(
            color: kWhiteColor.withValues(alpha: 0.9),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          items: categories
              .map(
                (category) => DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// FEEDBACK INPUT
// ─────────────────────────────────────────────────────────────

class _FeedbackInput extends StatelessWidget {
  final TextEditingController controller;

  const _FeedbackInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF223744), Color(0xFF0E1721)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.45)),
      ),
      child: TextField(
        controller: controller,
        maxLines: 5,
        minLines: 4,
        maxLength: 500,
        style: TextStyle(
          color: kBlackColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Tell us what you think...',
          hintStyle: TextStyle(color: kBlackColor, fontSize: 13.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(12.w),
          counterStyle: TextStyle(
            color: kWhiteColor.withValues(alpha: 0.42),
            fontSize: 11.sp,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ATTACHMENT TILE
// ─────────────────────────────────────────────────────────────

class _AttachmentTile extends StatelessWidget {
  final VoidCallback onTap;

  const _AttachmentTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF2A3A46), Color(0xFF17222D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.32)),
        ),
        child: Row(
          children: [
            Icon(Icons.attach_file_rounded, color: ZicColors.cyan, size: 18.w),
            SizedBox(width: 8.w),
            Text(
              'Attach screenshot (optional)',
              style: TextStyle(
                color: kWhiteColor.withValues(alpha: 0.86),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SUBMIT BUTTON
// ─────────────────────────────────────────────────────────────

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _SubmitButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF223744), Color(0xFF0E1721)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(
            color: ZicColors.cyan.withValues(alpha: 0.76),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: ZicColors.cyan.withValues(alpha: 0.24),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: ZicColors.cyan,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_rounded, color: ZicColors.cyan, size: 18.w),
                  SizedBox(width: 7.w),
                  Text(
                    'SUBMIT FEEDBACK',
                    style: TextStyle(
                      color: ZicColors.cyan,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.35,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// FOOTER HINT
// ─────────────────────────────────────────────────────────────

class _FooterHint extends StatelessWidget {
  const _FooterHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF101C27), Color(0xFF0A1119)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.16)),
      ),
      child: Text(
        'We read every submission and use your input to improve Zic.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: kWhiteColor.withValues(alpha: 0.74),
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          height: 1.35,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// DECORATIONS
// ─────────────────────────────────────────────────────────────

BoxDecoration _steelDecoration({required double radius, double glow = 0.2}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    gradient: const LinearGradient(
      colors: [Color(0xFF44515E), Color(0xFF2A3541), Color(0xFF3D4853)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    border: Border.all(color: const Color(0xFF85909C).withValues(alpha: 0.75)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.3),
        blurRadius: 10,
        offset: const Offset(0, 6),
      ),
      BoxShadow(
        color: ZicColors.cyan.withValues(alpha: glow),
        blurRadius: 12,
        spreadRadius: 0.6,
      ),
    ],
  );
}
