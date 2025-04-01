import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<String> predictSpam(String emailText) async {
    final url = Uri.parse('http://127.0.0.1:5000/predict/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email_text': emailText}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['prediction'];
    } else {
      return 'Error: ${response.body}';
    }
  }
}
