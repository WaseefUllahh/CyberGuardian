import 'package:http/http.dart' as http;

void main() async {
  final url = 'google.com';
  final submitUri = Uri.parse('https://www.virustotal.com/api/v3/urls');
  final submitResponse = await http.post(
    submitUri,
    headers: {
      'x-apikey': '669e34cea93aefaa722370ef8378bd4a4602ab71494723275f2d736019b57496',
    },
    body: {'url': url},
  );
  print('Status: ${submitResponse.statusCode}');
  print('Body: ${submitResponse.body}');
}
