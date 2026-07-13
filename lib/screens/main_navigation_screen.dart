import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../utils/app_colors.dart';
import 'dashboard_screen.dart';
import 'scanner_screen.dart';
import 'learning_screen.dart';
import 'reports_screen.dart';
import 'profile_screen.dart';

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
    final unselectedColor = isDark ? const Color(0xFFAAAAAA) : grey;

    return Scaffold(
      body: PopScope(
        canPop: _currentIndex == 0,
        onPopInvokedWithResult: (didPop, dynamic result) {
          if (!didPop) {
            setState(() {
              _currentIndex = 0;
            });
          }
        },
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: green,
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
            activeIcon: Icon(PhosphorIcons.bookOpen(PhosphorIconsStyle.fill)),
            label: 'Learning',
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.fileText()),
            activeIcon: Icon(PhosphorIcons.fileText(PhosphorIconsStyle.fill)),
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

