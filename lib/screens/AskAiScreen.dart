import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AskAiScreen extends StatefulWidget {
  const AskAiScreen({super.key});

  @override
  State<AskAiScreen> createState() => _AskAiScreenState();
}

class _AskAiScreenState extends State<AskAiScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _loading = false;

  final String apiKey = 'for security purpose'; //

  Future<void> _sendMessage(String prompt) async {
    if (prompt.trim().isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': prompt});
      _loading = true;
    });

    final url = Uri.parse('https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent?key=$apiKey');


    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('🔍 Raw Gemini Response: ${response.body}');
      final data = json.decode(response.body);

      final reply = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? 'No response received.';

      setState(() {
        _messages.add({'role': 'bot', 'content': reply});
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'bot', 'content': '❌ Error: $e'});
      });
    } finally {
      setState(() {
        _loading = false;
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ask AI (Gemini REST API)')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return Container(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.brown[200] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(msg['content'] ?? ''),
                );
              },
            ),
          ),
          if (_loading) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Ask something...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
