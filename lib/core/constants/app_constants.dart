/// App-wide string and numeric constants for CyberGuardian.
///
/// Use these instead of hard-coded literals to make changes in one place.
class AppConstants {
  // App Identity
  static const String appName = 'CyberGuardian';
  static const String appVersion = '1.0.0';

  // Asset Paths
  static const String logoPath = 'assets/images/cyberguardian_logo.png';

  // Firestore Collections
  static const String usersCollection      = 'users';
  static const String scansCollection      = 'scans';
  static const String reportsCollection    = 'reports';
  static const String activitiesCollection = 'activities';

  // Security Score
  static const int secureScoreThreshold = 80;

  // Scan Snippet Length
  static const int scanSnippetMaxLength = 50;
}


