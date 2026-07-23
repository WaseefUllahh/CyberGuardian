import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../screens/dashboard_screen.dart';
import '../../scanner/screens/scanner_screen.dart';
import '../../learning/screens/learning_screen.dart';
import '../../reports/screens/reports_screen.dart';
import '../../profile/screens/profile_screen.dart';

/// Bottom navigation shell that hosts the 5 main app tabs:
/// Home, Scanner, Learning, Reports, Profile.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = const [
    DashboardScreen(),
    ScannerScreen(),
    LearningScreen(),
    ReportsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final unselectedColor =
        isDark ? const Color(0xFFAAAAAA) : AppColors.grey;

    return Scaffold(
      body: PopScope(
        canPop: _currentIndex == 0,
        onPopInvokedWithResult: (didPop, dynamic result) {
          if (!didPop) {
            setState(() => _currentIndex = 0);
          }
        },
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.brandGreen,
        unselectedItemColor: unselectedColor,
        backgroundColor: navBgColor,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.house()),
            activeIcon: Icon(PhosphorIcons.house(PhosphorIconsStyle.fill)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.scan()),
            activeIcon: Icon(PhosphorIcons.scan(PhosphorIconsStyle.fill)),
            label: 'Scanner',
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.bookOpen()),
            activeIcon:
                Icon(PhosphorIcons.bookOpen(PhosphorIconsStyle.fill)),
            label: 'Learning',
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.fileText()),
            activeIcon:
                Icon(PhosphorIcons.fileText(PhosphorIconsStyle.fill)),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.user()),
            activeIcon: Icon(PhosphorIcons.user(PhosphorIconsStyle.fill)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}


