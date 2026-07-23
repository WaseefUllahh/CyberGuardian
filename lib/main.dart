import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Core
import 'core/theme/app_theme.dart';
import 'core/routing/app_routes.dart';

// App-level providers & config
import 'providers/theme_provider.dart';
import 'firebase_options.dart';
import 'services/virus_total_service.dart';

/// Entry point for CyberGuardian.
///
/// Theme definitions → [AppTheme]
/// Route map         → [AppRoutes]
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

/// Root widget — wires [ThemeProvider], [AppTheme], and [AppRoutes].
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
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          initialRoute: AppRoutes.splash,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}

