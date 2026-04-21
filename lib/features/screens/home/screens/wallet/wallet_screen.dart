import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/customization/widgets/feedback_style_snackbar.dart';
import 'package:zic/features/screens/home/controller/wallet_controller.dart';
import 'package:zic/features/screens/home/screens/home/home.dart';
import 'package:zic/features/screens/home/screens/widgets/coin_animation.dart';
import 'package:zic/utils/models/wallet.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  late final WalletController _controller;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isSendMode = true;
  bool _isInstantTransfer = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(WalletController());
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _isSendMode = _tabController.index == 0;
      });
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _addressController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _handleConfirm() async {
    if (_isSendMode) {
      if (_amountController.text.isEmpty) {
        _showSnackbar('Please enter an amount', isError: true);
        return;
      }
      if (_addressController.text.isEmpty) {
        _showSnackbar('Please enter recipient address', isError: true);
        return;
      }

      final success = await _controller.transferCoins(
        _amountController.text.trim(),
        _addressController.text.trim(),
      );

      if (success) {
        _amountController.clear();
        _addressController.clear();
      }
    } else {
      // Handle receive mode
      final address = _controller.walletAddress;
      if (address.isNotEmpty) {
        await Clipboard.setData(ClipboardData(text: address));
        _controller.copyWalletAddress();
      }
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    showFeedbackStyleSnackbar(
      message: message,
      success: !isError,
      duration: const Duration(seconds: 3),
    );
  }

  void _setMaxAmount() {
    final lioBalance = _controller.zicPoolData.value?.lio ?? 0.0;
    _amountController.text = lioBalance.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Obx(() {
        if (_controller.isLoading.value &&
            _controller.walletData.value == null) {
          return _LoadingView();
        }

        return RefreshIndicator(
          onRefresh: _controller.onRefresh,
          color: ZicColors.cyan,
          backgroundColor: const Color(0xFF1A2D3D),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 30.h),
                  _HeaderBar(title: 'Zic Digital Wallet'),
                  SizedBox(height: 16.h),
                  _BalanceCard(controller: _controller),
                  SizedBox(height: 14.h),
                  _TabBarView(
                    tabController: _tabController,
                    isSendMode: _isSendMode,
                  ),
                  SizedBox(height: 14.h),
                  if (_isSendMode) ...[
                    _AddressInput(
                      controller: _addressController,
                      onScan: () {
                        _showSnackbar('QR Scanner coming soon');
                      },
                    ),
                    SizedBox(height: 14.h),
                    _TransferModeTabs(
                      isInstantTransfer: _isInstantTransfer,
                      onModeChanged: (value) {
                        setState(() => _isInstantTransfer = value);
                      },
                    ),
                    SizedBox(height: 14.h),
                    _AmountInput(
                      controller: _amountController,
                      onMaxTap: _setMaxAmount,
                      currency: 'ZIC',
                    ),
                  ] else ...[
                    SizedBox(height: 14.h),
                    _ReceiveAddressCard(controller: _controller),
                  ],
                  SizedBox(height: 14.h),
                  _ConfirmButton(
                    onTap: _handleConfirm,
                    isLoading: _controller.isTransferring.value,
                    isSendMode: _isSendMode,
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    height: 1.h,
                    color: ZicColors.cyan.withValues(alpha: 0.16),
                  ),
                  SizedBox(height: 12.h),
                  _TransactionHeader(),
                  SizedBox(height: 12.h),
                  _TransactionList(controller: _controller),
                  SizedBox(height: 4.h),
                  _BottomNote(controller: _controller),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// LOADING VIEW
// ─────────────────────────────────────────────────────────────
class _LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: ZicColors.cyan),
          SizedBox(height: 16.h),
          Text(
            'Loading Wallet...',
            style: TextStyle(
              color: kWhiteColor.withValues(alpha: 0.8),
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// HEADER BAR
// ─────────────────────────────────────────────────────────────
class _HeaderBar extends StatelessWidget {
  final String title;

  const _HeaderBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 20.h),
      decoration: _steelDecoration(radius: 16.r, glow: 0.18),
      child: Row(
        children: [
          SizedBox(width: 44.w),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ZicColors.cyan,
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
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
// BALANCE CARD
// ─────────────────────────────────────────────────────────────
class _BalanceCard extends StatelessWidget {
  final WalletController controller;

  const _BalanceCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF5C666E), Color(0xFF35414C), Color(0xFF505B65)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFFE8D59B).withValues(alpha: 0.82),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: ZicColors.cyan.withValues(alpha: 0.2),
            blurRadius: 14,
            spreadRadius: 0.6,
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF233744), Color(0xFF142533)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.6)),
        ),
        child: Row(
          children: [
            _WalletBadge(),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'AVAILABLE BALANCE:',
                        style: TextStyle(
                          color: kWhiteColor.withValues(alpha: 0.85),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Obx(
                    () => Text(
                      controller.formattedBalance,
                      style: TextStyle(
                        color: T.gold,
                        fontSize: 42.sp,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Obx(
                    () => Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'TODAY: ',
                            style: TextStyle(
                              color: kWhiteColor.withValues(alpha: 0.82),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: controller.todayEarnings,
                            style: TextStyle(
                              color: ZicColors.cyan,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
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
// WALLET BADGE
// ─────────────────────────────────────────────────────────────
class _WalletBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82.w,
      width: 82.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFFAE8D4B), Color(0xFFE8D59B), Color(0xFF816A31)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.all(3.w),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF1D2E40), Color(0xFF102233)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: ZicColors.cyan.withValues(alpha: 0.48),
            width: 1.1,
          ),
        ),
        child: Padding(padding: EdgeInsets.all(12.w), child: AutoFlipImage()),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TAB BAR VIEW
// ─────────────────────────────────────────────────────────────
class _TabBarView extends StatelessWidget {
  final TabController tabController;
  final bool isSendMode;

  const _TabBarView({required this.tabController, required this.isSendMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF44515E), Color(0xFF2A3541), Color(0xFF3D4853)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFF8A949F).withValues(alpha: 0.68),
        ),
      ),
      child: TabBar(
        controller: tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF7B856A), Color(0xFF8F7950)],
          ),
          border: Border.all(
            color: const Color(0xFFE8D59B).withValues(alpha: 0.86),
            width: 1.2,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: ZicColors.cyan,
        unselectedLabelColor: kWhiteColor.withValues(alpha: 0.72),
        labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
        unselectedLabelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          Tab(icon: Icon(Icons.arrow_upward_rounded, size: 20), text: 'SEND'),
          Tab(
            icon: Icon(Icons.arrow_downward_rounded, size: 20),
            text: 'RECEIVE',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ADDRESS INPUT
// ─────────────────────────────────────────────────────────────
class _AddressInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onScan;

  const _AddressInput({required this.controller, required this.onScan});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECIPIENT ADDRESS OR USERNAME',
          style: TextStyle(
            color: kWhiteColor.withValues(alpha: 0.82),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            gradient: const LinearGradient(
              colors: [Color(0xFF13202C), Color(0xFF0E1823)],
            ),
            border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.38)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: TextStyle(color: kWhiteColor, fontSize: 14.sp),
                  decoration: InputDecoration(
                    fillColor: T.steelBorder,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    hintText: 'Enter wallet address or username',
                    hintStyle: TextStyle(
                      color: kWhiteColor.withValues(alpha: 0.4),
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: onScan,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF44515E), Color(0xFF2A3541)],
                    ),
                    border: Border.all(
                      color: ZicColors.cyan.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    color: ZicColors.cyan,
                    size: 20.w,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TRANSFER MODE TABS
// ─────────────────────────────────────────────────────────────
class _TransferModeTabs extends StatelessWidget {
  final bool isInstantTransfer;
  final ValueChanged<bool> onModeChanged;

  const _TransferModeTabs({
    required this.isInstantTransfer,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TransferModeButton(
            title: 'INSTANT\nTRANSFER',
            subtitle: 'Fee: 5%',
            icon: Icons.bolt_rounded,
            isSelected: isInstantTransfer,
            onTap: () => onModeChanged(true),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _TransferModeButton(
            title: 'STANDARD\nTRANSFER',
            subtitle: 'Fee: 1%',
            icon: Icons.arrow_forward_rounded,
            isSelected: !isInstantTransfer,
            onTap: () => onModeChanged(false),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TRANSFER MODE BUTTON
// ─────────────────────────────────────────────────────────────
class _TransferModeButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TransferModeButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF44515E), Color(0xFF2A3541), Color(0xFF3D4853)],
          ),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFE8D59B).withValues(alpha: 0.86)
                : const Color(0xFF8A949F).withValues(alpha: 0.62),
            width: 1.3,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: ZicColors.cyan.withValues(alpha: 0.22),
                blurRadius: 11,
              ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 24.w,
                  color: isSelected
                      ? ZicColors.cyan
                      : kWhiteColor.withValues(alpha: 0.45),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isSelected
                          ? ZicColors.cyan
                          : kWhiteColor.withValues(alpha: 0.45),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w900,
                      height: 1.08,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(
                color: isSelected
                    ? ZicColors.cyan.withValues(alpha: 0.8)
                    : kWhiteColor.withValues(alpha: 0.35),
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// AMOUNT INPUT
// ─────────────────────────────────────────────────────────────
class _AmountInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onMaxTap;
  final String currency;

  const _AmountInput({
    required this.controller,
    required this.onMaxTap,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'AMOUNT',
              style: TextStyle(
                color: kWhiteColor.withValues(alpha: 0.82),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: onMaxTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF44515E), Color(0xFF2A3541)],
                  ),
                  border: Border.all(
                    color: ZicColors.cyan.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  'MAX',
                  style: TextStyle(
                    color: ZicColors.cyan,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Container(
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            gradient: const LinearGradient(
              colors: [Color(0xFF13202C), Color(0xFF0E1823)],
            ),
            border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.38)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                  ),
                  style: TextStyle(
                    color: kWhiteColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    fillColor: T.steelBorder,
                    border: InputBorder.none,
                    isCollapsed: true,
                    hintText: 'MIN-500      MAX-10000',
                    hintStyle: TextStyle(
                      color: kWhiteColor.withValues(alpha: 0.4),
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text(
                currency,
                style: TextStyle(
                  color: ZicColors.cyan,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// RECEIVE ADDRESS CARD
// ─────────────────────────────────────────────────────────────
class _ReceiveAddressCard extends StatelessWidget {
  final WalletController controller;

  const _ReceiveAddressCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'YOUR WALLET ADDRESS',
          style: TextStyle(
            color: kWhiteColor.withValues(alpha: 0.82),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            gradient: const LinearGradient(
              colors: [Color(0xFF182734), Color(0xFF0F1A24)],
            ),
            border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.38)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Obx(() {
                  final address = controller.walletAddress;
                  return Text(
                    address.isNotEmpty ? address : 'Loading address...',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: kWhiteColor.withValues(alpha: 0.86),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () async {
                  final address = controller.walletAddress;
                  if (address.isNotEmpty) {
                    await Clipboard.setData(ClipboardData(text: address));
                    controller.copyWalletAddress();
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF44515E), Color(0xFF2A3541)],
                    ),
                    border: Border.all(
                      color: ZicColors.cyan.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Icon(
                    Icons.copy_rounded,
                    color: ZicColors.cyan,
                    size: 18.w,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            gradient: const LinearGradient(
              colors: [Color(0xFF182734), Color(0xFF0F1A24)],
            ),
            border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.38)),
          ),
          child: Column(
            children: [
              Obx(() {
                final address = controller.walletAddress;
                if (address.isEmpty) {
                  return Container(
                    width: 150.w,
                    height: 150.w,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ZicColors.cyan,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                }

                return Container(
                  width: 150.w,
                  height: 150.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.qr_code_2_rounded,
                      size: 100.w,
                      color: Colors.black87,
                    ),
                  ),
                );
              }),
              SizedBox(height: 12.h),
              Text(
                'Scan QR code to receive ZIC',
                style: TextStyle(
                  color: kWhiteColor.withValues(alpha: 0.7),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CONFIRM BUTTON
// ─────────────────────────────────────────────────────────────
class _ConfirmButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;
  final bool isSendMode;

  const _ConfirmButton({
    required this.onTap,
    required this.isLoading,
    required this.isSendMode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          gradient: LinearGradient(
            colors: isLoading
                ? [Colors.grey.shade700, Colors.grey.shade800]
                : const [Color(0xFF7B856A), Color(0xFF8F7950)],
          ),
          border: Border.all(
            color: const Color(0xFFE8D59B).withValues(alpha: 0.86),
            width: 1.2,
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 13.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            gradient: const LinearGradient(
              colors: [Color(0xFF223744), Color(0xFF0E1721)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.82)),
            boxShadow: [
              BoxShadow(
                color: ZicColors.cyan.withValues(alpha: 0.22),
                blurRadius: 12,
              ),
            ],
          ),
          child: isLoading
              ? SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: const CircularProgressIndicator(
                    color: ZicColors.cyan,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  isSendMode ? 'CONFIRM TRANSFER' : 'COPY ADDRESS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ZicColors.cyan,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TRANSACTION HEADER
// ─────────────────────────────────────────────────────────────
class _TransactionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'RECENT TRANSACTIONS',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: kWhiteColor.withValues(alpha: 0.86),
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TRANSACTION LIST
// ─────────────────────────────────────────────────────────────
class _TransactionList extends StatelessWidget {
  final WalletController controller;

  const _TransactionList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final transactions = controller.allTransactions;

      if (transactions.isEmpty) {
        return _EmptyTransactions();
      }

      return Column(
        children: transactions.take(10).map((transaction) {
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _UnifiedTransactionCard(transaction: transaction),
          );
        }).toList(),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────
// UNIFIED TRANSACTION CARD
// ─────────────────────────────────────────────────────────────
class _UnifiedTransactionCard extends StatelessWidget {
  final UnifiedTransaction transaction;

  const _UnifiedTransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF44515E), Color(0xFF2A3541), Color(0xFF3D4853)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.55)),
        boxShadow: [
          BoxShadow(
            color: ZicColors.cyan.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 0.4,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 46.w,
            width: 46.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF223744), Color(0xFF0E1721)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.52)),
            ),
            child: Icon(
              transaction.type == 'mining'
                  ? Icons.paid_rounded
                  : Icons.send_rounded,
              color: transaction.isPositive
                  ? Colors.greenAccent
                  : Colors.orangeAccent,
              size: 28.w,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: kWhiteColor.withValues(alpha: 0.9),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  transaction.subtitle,
                  style: TextStyle(
                    color: kWhiteColor.withValues(alpha: 0.6),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Text(
            transaction.amount,
            style: TextStyle(
              color: transaction.isPositive
                  ? Colors.greenAccent
                  : Colors.orangeAccent,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// EMPTY TRANSACTIONS
// ─────────────────────────────────────────────────────────────
class _EmptyTransactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.h),
      child: Column(
        children: [
          Icon(
            Icons.history_rounded,
            size: 48.w,
            color: kWhiteColor.withValues(alpha: 0.3),
          ),
          SizedBox(height: 12.h),
          Text(
            'No transactions yet',
            style: TextStyle(
              color: kWhiteColor.withValues(alpha: 0.5),
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// BOTTOM NOTE
// ─────────────────────────────────────────────────────────────
class _BottomNote extends StatelessWidget {
  final WalletController controller;

  const _BottomNote({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF0E1923), Color(0xFF09131B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s Earnings',
                style: TextStyle(
                  color: kWhiteColor.withValues(alpha: 0.6),
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Obx(
                () => Text(
                  controller.todayEarnings,
                  style: TextStyle(
                    color: ZicColors.cyan,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'This Week',
                style: TextStyle(
                  color: kWhiteColor.withValues(alpha: 0.6),
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Obx(
                () => Text(
                  controller.weeklyEarnings,
                  style: TextStyle(
                    color: ZicColors.cyan,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// STEEL DECORATION HELPER
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
