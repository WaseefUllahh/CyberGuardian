import 'package:shared_preferences/shared_preferences.dart';

/// Persists the first-launch onboarding flag using [SharedPreferences].
///
/// Used by [SplashScreen] to decide whether to show the onboarding flow,
/// and by [OnboardingScreen] to mark it complete after the user finishes.
class OnboardingService {
  static const String _key = 'hasSeenOnboarding';

  /// Returns `true` if the user has already completed the onboarding flow.
  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  /// Persists the flag so the onboarding is never shown again.
  Future<void> markOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }
}
