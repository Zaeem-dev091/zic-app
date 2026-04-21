import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/customization/widgets/feedback_style_snackbar.dart';

class ReferFriendData {
  final String inviteCode;
  final List<QuickInviteContact> contacts;

  const ReferFriendData({
    this.inviteCode = '',
    this.contacts = const [
      QuickInviteContact(
        name: '',
        status: '',
        avatarAsset: 'assets/images/logo.png',
      ),
      QuickInviteContact(name: 'J.C.', avatarText: 'JC'),
      QuickInviteContact(name: 'M. ORG', avatarText: 'MO'),
    ],
  });
}

@immutable
class QuickInviteContact {
  final String name;
  final String status;
  final String avatarText;
  final String? avatarAsset;
  final String? avatarUrl;

  const QuickInviteContact({
    required this.name,
    this.status = '',
    this.avatarText = '',
    this.avatarAsset,
    this.avatarUrl,
  });
}

// ─────────────────────────────────────────────────────────────
//  Entry point – call this to show the bottom sheet
// ─────────────────────────────────────────────────────────────

void showReferFriendBottomSheet(
  BuildContext context, {
  ReferFriendData data = const ReferFriendData(),
  VoidCallback? onInviteAll,
  void Function(QuickInviteContact contact)? onInviteContact,
  void Function(String platform)? onSharePlatform,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.65),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
    ),
    builder: (_) => ReferFriendSheet(
      data: data,
      onInviteAll: onInviteAll,
      onInviteContact: onInviteContact,
      onSharePlatform: onSharePlatform,
    ),
  );
}

class ReferFriendSheet extends StatelessWidget {
  final ReferFriendData data;
  final VoidCallback? onInviteAll;
  final void Function(QuickInviteContact)? onInviteContact;
  final void Function(String)? onSharePlatform;

  const ReferFriendSheet({
    required this.data,
    this.onInviteAll,
    this.onInviteContact,
    this.onSharePlatform,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        gradient: const LinearGradient(
          colors: [Color(0xFF182430), Color(0xFF0D1622), Color(0xFF08111B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(
          color: ZicColors.cyan.withValues(alpha: 0.45),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: ZicColors.cyan.withValues(alpha: 0.18),
            blurRadius: 24,
            spreadRadius: 1,
            offset: const Offset(0, -4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle circuit decoration in background
          Positioned(
            right: -10,
            top: 20,
            child: CustomPaint(
              size: Size(120.w, 200.h),
              painter: _CircuitAccentPainter(),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                _DragHandle(),
                SizedBox(height: 14.h),

                // Title
                _SheetTitle(),
                SizedBox(height: 18.h),

                // Invite code card
                _InviteCodeCard(code: data.inviteCode),
                SizedBox(height: 18.h),

                // Share platform icons
                _SharePlatformRow(onSharePlatform: onSharePlatform),
                SizedBox(height: 20.h),

                // Divider with label
                _SectionDivider(label: 'QUICK INVITE'),
                SizedBox(height: 14.h),

                // Quick invite contacts list
                _QuickInviteList(
                  contacts: data.contacts,
                  onInviteContact: onInviteContact,
                ),
                SizedBox(height: 20.h),

                // Invite All button
                _InviteAllButton(onTap: onInviteAll),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Drag handle
// ─────────────────────────────────────────────────────────────

class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.w,
      height: 4.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        gradient: LinearGradient(
          colors: [
            ZicColors.cyan.withValues(alpha: 0.25),
            ZicColors.cyan.withValues(alpha: 0.7),
            ZicColors.cyan.withValues(alpha: 0.25),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Sheet title
// ─────────────────────────────────────────────────────────────

class _SheetTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'INVITE YOUR FRIENDS & EARN Z',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: ZicColors.cyan,
        fontSize: 18.sp,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.8,
        shadows: [
          Shadow(color: ZicColors.cyan.withValues(alpha: 0.45), blurRadius: 12),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Invite code card
// ─────────────────────────────────────────────────────────────

class _InviteCodeCard extends StatelessWidget {
  final String code;
  const _InviteCodeCard({required this.code});

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: code));
    showFeedbackStyleSnackbar(
      message: 'Invite code copied!',

      success: true,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A4A), Color(0xFF0F2030)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFFB89246).withValues(alpha: 0.72),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB89246).withValues(alpha: 0.18),
            blurRadius: 14,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Circuit pattern strip at top of code
          _CodeCircuitStrip(),
          SizedBox(height: 6.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  code,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ZicColors.cyan,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                    shadows: [
                      Shadow(
                        color: ZicColors.cyan.withValues(alpha: 0.5),
                        blurRadius: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          _CodeCircuitStrip(),
          SizedBox(height: 10.h),
          // Copy button
          GestureDetector(
            onTap: _copyToClipboard,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.copy_rounded,
                  color: kWhiteColor.withValues(alpha: 0.75),
                  size: 16.w,
                ),
                SizedBox(width: 6.w),
                Text(
                  'COPY',
                  style: TextStyle(
                    color: kWhiteColor.withValues(alpha: 0.75),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
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

class _CodeCircuitStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        20,
        (i) => Expanded(
          child: Container(
            height: 3.h,
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.r),
              color: i % 3 == 0
                  ? ZicColors.cyan.withValues(alpha: 0.55)
                  : const Color(0xFF1A3547).withValues(alpha: 0.8),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Share platform row
// ─────────────────────────────────────────────────────────────

class _SharePlatformRow extends StatelessWidget {
  final void Function(String)? onSharePlatform;

  const _SharePlatformRow({this.onSharePlatform});

  @override
  Widget build(BuildContext context) {
    final platforms = [
      _PlatformIcon(
        icon: Icons.chat_rounded, // WhatsApp placeholder
        color: const Color(0xFF25D366),
        label: 'whatsapp',
        onTap: onSharePlatform,
      ),
      _PlatformIcon(
        icon: Icons.facebook_rounded,
        color: const Color(0xFF1877F2),
        label: 'facebook',
        onTap: onSharePlatform,
      ),
      _PlatformIcon(
        icon: Icons.close_rounded, // X / Twitter placeholder
        color: kWhiteColor,
        label: 'twitter',
        onTap: onSharePlatform,
      ),
      _PlatformIcon(
        icon: Icons.email_rounded,
        color: const Color(0xFFEA4335),
        label: 'email',
        onTap: onSharePlatform,
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: platforms
          .map(
            (p) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: p,
            ),
          )
          .toList(),
    );
  }
}

class _PlatformIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final void Function(String)? onTap;

  const _PlatformIcon({
    required this.icon,
    required this.color,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(label),
      child: Container(
        height: 54.w,
        width: 54.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF44515E), Color(0xFF2A3541), Color(0xFF3D4853)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: const Color(0xFF85909C).withValues(alpha: 0.75),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: color.withValues(alpha: 0.22),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 24.w),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Section divider with label
// ─────────────────────────────────────────────────────────────

class _SectionDivider extends StatelessWidget {
  final String label;
  const _SectionDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  ZicColors.cyan.withValues(alpha: 0.35),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            label,
            style: TextStyle(
              color: kWhiteColor.withValues(alpha: 0.65),
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ZicColors.cyan.withValues(alpha: 0.35),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Quick invite contacts list
// ─────────────────────────────────────────────────────────────

class _QuickInviteList extends StatelessWidget {
  final List<QuickInviteContact> contacts;
  final void Function(QuickInviteContact)? onInviteContact;

  const _QuickInviteList({required this.contacts, this.onInviteContact});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: contacts
          .map(
            (c) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: _QuickInviteRow(contact: c, onInvite: onInviteContact),
            ),
          )
          .toList(),
    );
  }
}

class _QuickInviteRow extends StatelessWidget {
  final QuickInviteContact contact;
  final void Function(QuickInviteContact)? onInvite;

  const _QuickInviteRow({required this.contact, this.onInvite});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF44515E), Color(0xFF2A3541), Color(0xFF3D4853)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFF85909C).withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: ZicColors.cyan.withValues(alpha: 0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          _ContactAvatar(contact: contact),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.status.isNotEmpty
                      ? '${contact.name} (${contact.status})'
                      : contact.name,
                  style: TextStyle(
                    color: kWhiteColor.withValues(alpha: 0.9),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onInvite?.call(contact),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2A4A5A), Color(0xFF162435)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: ZicColors.cyan.withValues(alpha: 0.6),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ZicColors.cyan.withValues(alpha: 0.22),
                    blurRadius: 10,
                    spreadRadius: 0.5,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.send_rounded, color: ZicColors.cyan, size: 14.w),
                  SizedBox(width: 4.w),
                  Text(
                    'INVITE',
                    style: TextStyle(
                      color: ZicColors.cyan,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactAvatar extends StatelessWidget {
  final QuickInviteContact contact;
  const _ContactAvatar({required this.contact});

  String get _initials {
    final parts = contact.name
        .split(' ')
        .where((p) => p.isNotEmpty)
        .map((p) => p.replaceAll('.', ''))
        .toList();
    if (parts.isEmpty) return 'NA';
    if (parts.length == 1) {
      return parts.first
          .substring(0, parts.first.length > 2 ? 2 : parts.first.length)
          .toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasImage =
        (contact.avatarAsset?.isNotEmpty ?? false) ||
        (contact.avatarUrl?.isNotEmpty ?? false);

    return Container(
      height: 44.w,
      width: 44.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFFC9B074), Color(0xFF726242)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(1.8.w),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF38414D), Color(0xFF1F2730)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ClipOval(
          child: hasImage
              ? (contact.avatarAsset != null
                    ? Image.asset(contact.avatarAsset!, fit: BoxFit.cover)
                    : Image.network(
                        contact.avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Center(
                          child: Text(
                            contact.avatarText.isEmpty
                                ? _initials
                                : contact.avatarText,
                            style: TextStyle(
                              color: kWhiteColor.withValues(alpha: 0.85),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ))
              : Center(
                  child: Text(
                    contact.avatarText.isEmpty ? _initials : contact.avatarText,
                    style: TextStyle(
                      color: kWhiteColor.withValues(alpha: 0.85),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Invite All button
// ─────────────────────────────────────────────────────────────

class _InviteAllButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _InviteAllButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF1E3A4A), Color(0xFF0F2030)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: const Color(0xFFB89246).withValues(alpha: 0.85),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFB89246).withValues(alpha: 0.25),
              blurRadius: 18,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_add_rounded,
              color: const Color(0xFFE8D59B),
              size: 20.w,
            ),
            SizedBox(width: 8.w),
            Text(
              'INVITE ALL',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFFE8D59B),
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    color: const Color(0xFFB89246).withValues(alpha: 0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Background circuit accent painter
// ─────────────────────────────────────────────────────────────

class _CircuitAccentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = ZicColors.cyan.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final dotPaint = Paint()
      ..color = ZicColors.cyan.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.5, size.height * 0.1)
      ..lineTo(size.width * 0.8, size.height * 0.1)
      ..lineTo(size.width * 0.8, size.height * 0.35)
      ..lineTo(size.width * 0.95, size.height * 0.5)
      ..lineTo(size.width * 0.7, size.height * 0.65)
      ..lineTo(size.width * 0.9, size.height * 0.85);

    canvas.drawPath(path, linePaint);

    for (final pt in [
      Offset(size.width * 0.5, size.height * 0.1),
      Offset(size.width * 0.8, size.height * 0.35),
      Offset(size.width * 0.95, size.height * 0.5),
      Offset(size.width * 0.7, size.height * 0.65),
    ]) {
      canvas.drawCircle(pt, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
