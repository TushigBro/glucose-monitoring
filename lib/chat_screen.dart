import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyChatScreen extends StatefulWidget {
  const MyChatScreen({super.key});

  @override
  State<MyChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<MyChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];

  final String apiKey =
      "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";

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'text': message});
      _controller.clear();
    });

    try {
      final uri = Uri.parse('https://openrouter.ai/api/v1/chat/completions');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization':
            "Bearer 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",
        'HTTP-Referer': 'https://undergraduate-project-ry8h.onrender.com/',
        'X-Title': 'gGauge Chatbot',
      };

      final body = jsonEncode({
        'model': "anthropic/claude-3-haiku",
        'messages': [
          {'role': 'system', 'content': 'You are a helpful health assistant.'},
          {'role': 'user', 'content': message},
        ],
      });

      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'];
        setState(() {
          messages.add({'role': 'bot', 'text': reply});
        });
      } else {
        print('❌ Response ${response.statusCode}: ${response.body}');
        setState(() {
          messages.add({
            'role': 'bot',
            'text': 'Error: ${response.statusCode} — ${response.body}'
          });
        });
      }
    } catch (e) {
      print('❌ Exception: $e');
      setState(() {
        messages.add({'role': 'bot', 'text': 'Network error: $e'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 90),
            const Image(
              image: AssetImage('assets/images/logo.png'),
              height: 30,
              width: 41,
            ),
            const SizedBox(height: 20),
            const Text(
              'Hello User!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 36.0),
              child: Text(
                "I’m gGauge chatbot. I’m here to help you 24/7 to answer your most of the health considerations.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w400, height: 1.5),
              ),
            ),
            const SizedBox(height: 20),

            // Chat messages
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isUser = msg['role'] == 'user';
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7),
                      decoration: BoxDecoration(
                        color:
                            isUser ? const Color(0xff10D0BF) : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(msg['text'] ?? ''),
                    ),
                  );
                },
              ),
            ),

            // Input box
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Ask me anything...",
                          border: InputBorder.none,
                        ),
                        onSubmitted: sendMessage,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Color(0xff086A61)),
                      onPressed: () => sendMessage(_controller.text),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
