import 'virus_total_service.dart';
import '../models/virus_total_result.dart';
import '../models/text_analysis_result.dart';

class TextAnalysisService {
  final VirusTotalService _vtService = VirusTotalService();

  // Common phishing keywords/phrases
  final List<String> _phishingKeywords = [
    'urgent',
    'suspended',
    'verify your account',
    'password reset',
    'login attempt',
    'unauthorized access',
    'click here',
    'update your billing',
    'account limited',
    'win',
    'claim your prize',
    'lottery',
    'congratulations',
    'free money'
  ];

  Future<TextAnalysisResult> analyzeText(String text) async {
    final lowerText = text.toLowerCase();
    
    // 1. Keyword Analysis
    List<String> matchedKeywords = [];
    for (String keyword in _phishingKeywords) {
      if (lowerText.contains(keyword)) {
        matchedKeywords.add(keyword);
      }
    }

    // 2. URL Extraction
    final urlRegex = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    final matches = urlRegex.allMatches(text);
    
    final Map<String, VirusTotalResult> urlResults = {};
    
    // 3. Scan all found URLs
    for (var match in matches) {
      final url = match.group(0);
      if (url != null && !urlResults.containsKey(url)) {
        final result = await _vtService.scanUrl(url);
        urlResults[url] = result;
      }
    }

    // 4. Calculate Risk Score and Overall Verdict
    int riskScore = 0;
    
    // Each keyword adds 15 points
    riskScore += (matchedKeywords.length * 15);
    
    // Analyze URL results
    bool anyMaliciousLink = false;
    int maliciousLinksCount = 0;
    
    for (var result in urlResults.values) {
      if (!result.isSafe) {
        anyMaliciousLink = true;
        maliciousLinksCount++;
        riskScore += 50; // Each malicious link adds 50 points
      }
    }
    
    if (riskScore > 100) riskScore = 100;
    
    final bool isSafe = riskScore < 40 && !anyMaliciousLink;
    
    String threatLevel = 'Safe';
    if (anyMaliciousLink) {
      threatLevel = 'Malicious Links Detected';
    } else if (riskScore >= 40) {
      threatLevel = 'Suspicious Patterns Found';
    } else {
      threatLevel = 'Safe';
    }
    
    return TextAnalysisResult(
      isSafe: isSafe,
      threatLevel: threatLevel,
      riskScore: riskScore,
      keywordMatches: matchedKeywords,
      urlResults: urlResults,
    );
  }
}
