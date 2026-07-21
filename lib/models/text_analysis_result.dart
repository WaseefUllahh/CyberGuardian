import 'virus_total_result.dart';

class TextAnalysisResult {
  final bool isSafe;
  final String threatLevel;
  final int riskScore; // 0 to 100
  final List<String> keywordMatches;
  final Map<String, VirusTotalResult> urlResults;
  
  const TextAnalysisResult({
    required this.isSafe,
    required this.threatLevel,
    required this.riskScore,
    required this.keywordMatches,
    required this.urlResults,
  });

  bool get hasUrls => urlResults.isNotEmpty;
  bool get hasKeywords => keywordMatches.isNotEmpty;

  /// Generate a summary for the UI
  String get summary {
    if (isSafe) {
      return 'No phishing keywords or malicious links detected.';
    }
    
    final List<String> parts = [];
    if (keywordMatches.isNotEmpty) {
      parts.add('Suspicious keywords: ${keywordMatches.join(', ')}');
    }
    
    int maliciousUrls = 0;
    for (var result in urlResults.values) {
      if (!result.isSafe) maliciousUrls++;
    }
    
    if (maliciousUrls > 0) {
      parts.add('$maliciousUrls malicious link(s) found.');
    }
    
    return parts.join('\n');
  }
}
