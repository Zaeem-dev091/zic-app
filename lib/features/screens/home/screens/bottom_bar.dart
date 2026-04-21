import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/screens/home/home.dart';
import 'package:zic/features/screens/home/screens/settings/settings_screen.dart';
import 'package:zic/features/screens/home/screens/wallet/wallet_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    WalletScreen(),
    SettingsScreen(),
  ];

  void _onTap(int index) {
    if (index < _pages.length) {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTransparentColor,
      resizeToAvoidBottomInset: false, // Keep this true
      body: Stack(
        children: [
          // Background - stays behind everything
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF030915),
                    Color(0xFF071226),
                    Color(0xFF050913),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Opacity(
                opacity: 0.55,
                child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
              ),
            ),
          ),

          // Main content - use Column with Expanded and fixed bottom bar
          Column(
            children: [
              // Scrollable content area
              Expanded(
                child: IndexedStack(index: _selectedIndex, children: _pages),
              ),

              // Fixed bottom bar that won't move with keyboard
              BottomNavBar(selectedIndex: _selectedIndex, onTap: _onTap),
            ],
          ),
        ],
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h + bottomInset),
      child: Container(
        height: 72.h,
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF7D8791), Color(0xFF424B56), Color(0xFF66707A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 18,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: ZicColors.cyan.withValues(alpha: 0.18),
              blurRadius: 14,
              spreadRadius: 0.2,
            ),
          ],
        ),
        child: Container(
          height: 52.h,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
            borderRadius: BorderRadius.circular(25.r),
            gradient: const LinearGradient(
              colors: [Color(0xFF424B56), Color(0xFF7D8791), Color(0xFF424B56)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 10.h,
                left: 10.w,
                right: 10.w,
                child: Container(
                  height: 3.h,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        ZicColors.cyan.withValues(alpha: 0.9),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: _NavItem(
                      icon: Icons.home_sharp,
                      index: 0,
                      selectedIndex: selectedIndex,
                      onTap: onTap,
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      icon: Icons.wallet,
                      index: 1,
                      selectedIndex: selectedIndex,
                      onTap: onTap,
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      icon: Icons.settings,
                      index: 2,
                      selectedIndex: selectedIndex,
                      onTap: onTap,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  bool get selected => index == selectedIndex;

  @override
  Widget build(BuildContext context) {
    final accent = selected ? ZicColors.cyan : const Color(0xFF97A2AE);

    return SizedBox(
      height: double.infinity,
      child: Center(
        child: InkWell(
          splashColor: accent,
          borderRadius: BorderRadius.circular(100),
          onTap: () => onTap(index),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Icon(icon, color: accent, size: 30.w),
          ),
        ),
      ),
    );
  }
}
