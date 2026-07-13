import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final url = 'https://secure-bank-login.example';
  final urlId = base64Url.encode(utf8.encode(url)).replaceAll('=', '');
  
  final uri = Uri.parse('https://www.virustotal.com/api/v3/urls/$urlId');
  final response = await http.get(
    uri,
    headers: {
      'x-apikey': '669e34cea93aefaa722370ef8378bd4a4602ab71494723275f2d736019b57496',
    },
  );
  
  print('Status: ${response.statusCode}');
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print('Stats: ${data['data']['attributes']['last_analysis_stats']}');
  } else {
    print('Body: ${response.body}');
  }
}
