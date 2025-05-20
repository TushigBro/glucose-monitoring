import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyChatScreen extends StatefulWidget {
  const MyChatScreen({super.key});

  @override
  State<MyChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<MyChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, String>> messages = [];

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'text': message});
      _controller.clear();
    });
    _scrollToBottom();

    const apiKey =
        "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"; // 🔑 Replace this with your actual API key

    try {
      final response = await http.post(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
          'HTTP-Referer':
              'https://undergraduate-project-ry8h.onrender.com/', // ⚠️ Replace with your app/site URL
          'X-Title': 'gGauge Chatbot',
        },
        body: jsonEncode({
          "model": "anthropic/claude-3-haiku",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are a helpful AI health assistant for the gGauge app."
            },
            ...messages.map((msg) => {
                  "role": msg['role'],
                  "content": msg['text'],
                }),
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'];
        setState(() {
          messages.add({'role': 'bot', 'text': reply.trim()});
        });
      } else {
        setState(() {
          messages.add({
            'role': 'bot',
            'text': 'Error ${response.statusCode}: ${response.body}',
          });
        });
      }
    } catch (e) {
      setState(() {
        messages.add({'role': 'bot', 'text': 'Connection error: $e'});
      });
    }

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Column(
              children: [
                SizedBox(height: 90),
                Image(
                  image: AssetImage('assets/images/logo.png'),
                  height: 30,
                  width: 41,
                ),
                SizedBox(height: 20),
                Text(
                  'Hello User!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 14),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 36.0),
                  child: Text(
                    "I’m gGauge chatbot. I’m here to help you 24/7 to answer most of your health considerations.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Chat messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
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
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
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

            // Chat input
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
                      icon: const Icon(
                        Icons.send,
                        color: Color(0xff086A61),
                      ),
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
