class VirusTotalResult {
  final bool isSafe;
  final bool isError;
  final String? errorMessage;
  final int? maliciousCount;
  final int? suspiciousCount;
  final int? totalEngines;
  final List<String>? maliciousEngines;

  const VirusTotalResult({
    required this.isSafe,
    this.isError = false,
    this.errorMessage,
    this.maliciousCount,
    this.suspiciousCount,
    this.totalEngines,
    this.maliciousEngines,
  });

  const VirusTotalResult.safe({this.totalEngines})
      : isSafe = true,
        isError = false,
        errorMessage = null,
        maliciousCount = 0,
        suspiciousCount = 0,
        maliciousEngines = null;

  const VirusTotalResult.error(this.errorMessage)
      : isSafe = false,
        isError = true,
        maliciousCount = null,
        suspiciousCount = null,
        totalEngines = null,
        maliciousEngines = null;

  VirusTotalResult.threat({
    required this.maliciousCount,
    this.suspiciousCount,
    this.totalEngines,
    this.maliciousEngines,
  })  : isSafe = false,
        isError = false,
        errorMessage = null;

  /// Human-readable summary for the result card.
  String get threatLabel {
    if (isError) return errorMessage ?? 'Unknown error';
    if (isSafe) return 'No threats detected';
    final engines = maliciousEngines ?? [];
    final preview = engines.take(3).join(', ');
    final extra = engines.length > 3 ? ' +${engines.length - 3} more' : '';
    return '$maliciousCount/$totalEngines engines flagged this URL'
        '${preview.isNotEmpty ? '\nFlagged by: $preview$extra' : ''}';
  }
}
