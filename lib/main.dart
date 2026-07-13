import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/scanner_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/submit_report_screen.dart';
import 'screens/admin_panel_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/two_factor_screen.dart';
import 'screens/notification_settings_screen.dart';
import 'screens/language_settings_screen.dart';
import 'screens/help_center_screen.dart';
import 'screens/about_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'services/virus_total_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await VirusTotalService().init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const CyberGuardianApp(),
    ),
  );
}

class CyberGuardianApp extends StatelessWidget {
  const CyberGuardianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'CyberGuardian',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2E7D32),
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(0xFFF5F7FA),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            cardTheme: CardThemeData(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Color(0xFF333333)),
              bodyMedium: TextStyle(color: Color(0xFF333333)),
              titleLarge: TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.bold),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF4CAF50),
              brightness: Brightness.dark,
            ).copyWith(
              surface: const Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
            scaffoldBackgroundColor: const Color(0xFF121212),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E1E1E),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            cardTheme: CardThemeData(
              color: const Color(0xFF1E1E1E),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            drawerTheme: const DrawerThemeData(
              backgroundColor: Color(0xFF1A1A2E),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Color(0xFFE0E0E0)),
              titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              titleMedium: TextStyle(color: Colors.white),
              labelLarge: TextStyle(color: Colors.white),
            ),
            iconTheme: const IconThemeData(color: Color(0xFF4CAF50)),
            listTileTheme: const ListTileThemeData(
              textColor: Colors.white,
              iconColor: Color(0xFF4CAF50),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF2A2A2A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF4CAF50)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
              ),
              labelStyle: const TextStyle(color: Color(0xFFAAAAAA)),
              hintStyle: const TextStyle(color: Color(0xFF888888)),
            ),
            switchTheme: SwitchThemeData(
              thumbColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFF888888),
              ),
              trackColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? const Color(0xFF2E7D32).withValues(alpha: 0.5)
                    : const Color(0xFF444444),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
              ),
            ),
            dividerColor: const Color(0xFF333333),
          ),
      initialRoute: '/',
      routes: {
        '/':               (context) => const SplashScreen(),
        '/login':          (context) => const LoginScreen(),
        '/signup':         (context) => const SignUpScreen(),
        '/home':           (context) => const MainNavigationScreen(),
        '/scanner':        (context) => const ScannerScreen(),
        '/reports':        (context) => const ReportsScreen(),
        '/profile':        (context) => const ProfileScreen(),
        '/admin':          (context) => const AdminPanelScreen(),
        '/submit-report':  (context) => const SubmitReportScreen(),
        '/edit-profile':   (context) => const EditProfileScreen(),
        '/change-password':(context) => const ChangePasswordScreen(),
        '/two-factor':     (context) => const TwoFactorScreen(),
        '/notifications':  (context) => const NotificationSettingsScreen(),
        '/language':       (context) => const LanguageSettingsScreen(),
        '/help-center':    (context) => const HelpCenterScreen(),
        '/about':          (context) => const AboutScreen(),
        '/privacy':        (context) => const PrivacyPolicyScreen(),
      },
    );
      },
    );
  }
}