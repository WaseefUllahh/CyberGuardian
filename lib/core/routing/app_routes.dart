import 'package:flutter/material.dart';

// Feature imports — each features/ sub-folder contains its own screens.
// Update this file when adding new screens/routes.

// Auth
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';

// Onboarding
import '../../features/onboarding/screens/onboarding_screen.dart';

// Dashboard / Navigation shell
import '../../features/dashboard/screens/main_navigation_screen.dart';

// Scanner
import '../../features/scanner/screens/scanner_screen.dart';

// Reports
import '../../features/reports/screens/reports_screen.dart';
import '../../features/reports/screens/submit_report_screen.dart';

// Profile & Settings
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/change_password_screen.dart';
import '../../features/profile/screens/two_factor_screen.dart';
import '../../features/profile/screens/notification_settings_screen.dart';
import '../../features/profile/screens/language_settings_screen.dart';
import '../../features/profile/screens/help_center_screen.dart';
import '../../features/profile/screens/about_screen.dart';
import '../../features/profile/screens/privacy_policy_screen.dart';

// Admin
import '../../features/admin/screens/admin_panel_screen.dart';

/// Named route map for [MaterialApp.routes].
///
/// Add new routes here — screens are imported at the top of this file,
/// grouped by feature.
class AppRoutes {
  // Route name constants
  static const String splash          = '/';
  static const String onboarding      = '/onboarding';
  static const String login           = '/login';
  static const String signup          = '/signup';
  static const String home            = '/home';
  static const String scanner         = '/scanner';
  static const String reports         = '/reports';
  static const String profile         = '/profile';
  static const String admin           = '/admin';
  static const String submitReport    = '/submit-report';
  static const String editProfile     = '/edit-profile';
  static const String changePassword  = '/change-password';
  static const String twoFactor       = '/two-factor';
  static const String notifications   = '/notifications';
  static const String language        = '/language';
  static const String helpCenter      = '/help-center';
  static const String about           = '/about';
  static const String privacy         = '/privacy';

  // Route map
  static Map<String, WidgetBuilder> get routes => {
    splash:         (_) => const SplashScreen(),
    onboarding:     (_) => const OnboardingScreen(),
    login:          (_) => const LoginScreen(),
    signup:         (_) => const SignUpScreen(),
    home:           (_) => const MainNavigationScreen(),
    scanner:        (_) => const ScannerScreen(),
    reports:        (_) => const ReportsScreen(),
    profile:        (_) => const ProfileScreen(),
    admin:          (_) => const AdminPanelScreen(),
    submitReport:   (_) => const SubmitReportScreen(),
    editProfile:    (_) => const EditProfileScreen(),
    changePassword: (_) => const ChangePasswordScreen(),
    twoFactor:      (_) => const TwoFactorScreen(),
    notifications:  (_) => const NotificationSettingsScreen(),
    language:       (_) => const LanguageSettingsScreen(),
    helpCenter:     (_) => const HelpCenterScreen(),
    about:          (_) => const AboutScreen(),
    privacy:        (_) => const PrivacyPolicyScreen(),
  };
}


