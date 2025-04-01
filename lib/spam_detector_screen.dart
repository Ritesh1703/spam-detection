import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SpamDetectorScreen extends StatefulWidget {
  const SpamDetectorScreen({Key? key}) : super(key: key);

  @override
  _SpamDetectorScreenState createState() => _SpamDetectorScreenState();
}

class _SpamDetectorScreenState extends State<SpamDetectorScreen> {
  final TextEditingController _emailController = TextEditingController();
  String? _result;

  Future<void> detectSpam() async {
    final String emailText = _emailController.text;
    if (emailText.isEmpty) {
      setState(() {
        _result = "Please enter an email.";
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': emailText}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          _result = "Prediction: ${responseData['prediction']}";
        });
      } else {
        setState(() {
          _result = "Error: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _result = "Failed to connect to the server.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Spam Email Detector')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter your email content',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: detectSpam,
              child: Text('Check Spam'),
            ),
            const SizedBox(height: 16),
            if (_result != null)
              Text(
                _result!,
                style: TextStyle(
                  fontSize: 16,
                  color: _result!.contains('Spam') ? Colors.red : Colors.green,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
