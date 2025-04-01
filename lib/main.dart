import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const SpamDetectorApp());
}

class SpamDetectorApp extends StatelessWidget {
  const SpamDetectorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SpamDetectorScreen(),
    );
  }
}

class SpamDetectorScreen extends StatefulWidget {
  @override
  _SpamDetectorScreenState createState() => _SpamDetectorScreenState();
}

class _SpamDetectorScreenState extends State<SpamDetectorScreen> {
  TextEditingController _controller = TextEditingController();
  String result = "";

  Future<void> checkSpam() async {
    final String emailText = _controller.text;

    if (emailText.isEmpty) {
      setState(() {
        result = "Please enter email content.";
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
        final data = json.decode(response.body);
        setState(() {
          result = "Prediction: ${data['prediction']}";
        });
      } else {
        setState(() {
          result = "Error: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        result = "Failed to connect to the server.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Spam Detector")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Enter your email content",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkSpam,
              child: const Text("Check Spam"),
            ),
            const SizedBox(height: 20),
            Text(
              result,
              style: TextStyle(
                fontSize: 16,
                color: result.contains("Spam") ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
