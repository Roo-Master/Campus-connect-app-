import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({Key? key}) : super(key: key);

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  static const String backendUrl = "http://localhost:3000/chat"; // Replace with your backend URL
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  bool _isLoading = false;

  final List<ChatMessage> _messages = [
    ChatMessage(role: 'system', message: 'You are a helpful assistant.'),
  ];

  /* =========================
     SEND MESSAGE
  ========================= */
  Future<void> _sendMessage({String? retryText}) async {
    final text = retryText ?? _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    if (retryText == null) {
      setState(() {
        _messages.add(ChatMessage(role: 'user', message: text));
        _controller.clear();
      });
    }

    final aiMessage = ChatMessage(role: 'assistant', message: '');
    setState(() {
      _messages.add(aiMessage);
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "messages": _messages
              .map((m) => {"role": m.role, "content": m.message})
              .toList(),
        }),
      );

      if (response.statusCode != 200) throw Exception("Server error");

      final data = jsonDecode(response.body);
      final content = data["choices"][0]["message"]["content"] ?? "";

      // Typing effect
      for (int i = 0; i < content.length; i++) {
        await Future.delayed(const Duration(milliseconds: 20));
        setState(() {
          aiMessage.message += content[i];
        });
        _scrollToBottom();
      }
    } catch (e) {
      setState(() {
        aiMessage.message = '⚠️ Error occurred. Tap to retry.';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /* =========================
     UI
  ========================= */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Text('AI Chat'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final msg = _messages[i];
                if (msg.role == 'system') return const SizedBox();

                return GestureDetector(
                  onTap: msg.message.contains('retry')
                      ? () {
                    final lastUserMessage = _messages
                        .lastWhere((m) => m.role == 'user')
                        .message;
                    _sendMessage(retryText: lastUserMessage);
                  }
                      : null,
                  child: msg.role == 'user'
                      ? _UserMessage(message: msg.message)
                      : _AiMessage(message: msg.message),
                );
              },
            ),
          ),
          _InputBar(
            controller: _controller,
            isLoading: _isLoading,
            onSend: () => _sendMessage(),
          ),
        ],
      ),
    );
  }
}

/* =========================
   MODEL
========================= */
class ChatMessage {
  final String role; // system, user, assistant
  String message;

  ChatMessage({required this.role, required this.message});
}

/* =========================
   USER MESSAGE
========================= */
class _UserMessage extends StatelessWidget {
  final String message;

  const _UserMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF38BDF8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

/* =========================
   AI MESSAGE
========================= */
class _AiMessage extends StatelessWidget {
  final String message;

  const _AiMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

/* =========================
   INPUT BAR
========================= */
class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;

  const _InputBar({
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: const Color(0xFF020617),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            height: 40,
            child: isLoading
                ? const CircularProgressIndicator()
                : IconButton(
              icon: const Icon(Icons.send),
              color: Colors.white,
              onPressed: onSend,
            ),
          ),
        ],
      ),
    );
  }
}
