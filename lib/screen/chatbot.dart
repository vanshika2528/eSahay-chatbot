import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  _ChatbotState createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final TextEditingController _controller = TextEditingController();
  String? _chatbotResponse;

  // Function to send message to the chatbot
  Future<void> sendMessageToChatbot(String message) async {
    final url = Uri.parse('http://127.0.0.1:7860/flow/...'); // replace with your actual endpoint
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "input_value": message, // Send the user message as input
      }),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      setState(() {
        _chatbotResponse = responseData.toString(); // Save the chatbot's response to display
      });
    } else {
      setState(() {
        _chatbotResponse = 'Failed to connect to the chatbot API: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TextField for user input
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Ask the chatbot something...',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final userMessage = _controller.text;
                if (userMessage.isNotEmpty) {
                  sendMessageToChatbot(userMessage); // Send user's question to chatbot
                }
              },
              child: const Text('Send'),
            ),
            const SizedBox(height: 20),
            // Display chatbot's response
            if (_chatbotResponse != null) 
              Text(
                'Chatbot Response: $_chatbotResponse',
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
