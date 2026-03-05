import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/ai_chat_model.dart';
import '../services/ai_chat_service.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({Key? key}) : super(key: key);

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AiChatService _chatService = AiChatService();

  final List<AiChatMessage> _messages = [
    AiChatMessage(
      role: "system",
      content: "You are a helpful assistant.",
    ),
  ];

  StreamSubscription? _streamSubscription;
  bool _isLoading = false;

  /* ===============================
     SEND MESSAGE (STREAMING)
  =============================== */
  void _sendMessage({bool regenerate = false}) {
    final text = regenerate
        ? _messages.lastWhere((m) => m.role == "user").content
        : _controller.text.trim();

    if (text.isEmpty || _isLoading) return;

    if (!regenerate) {
      _controller.clear();
      _messages.add(AiChatMessage(role: "user", content: text));
    }

    final aiMessage =
    AiChatMessage(role: "assistant", content: "");

    setState(() {
      _messages.add(aiMessage);
      _isLoading = true;
    });

    _scrollToBottom();

    _streamSubscription = _chatService
        .sendMessageStream(_messages)
        .listen((chunk) {
      setState(() {
        aiMessage.content += chunk;
      });
      _scrollToBottom();
    }, onDone: () {
      setState(() => _isLoading = false);
    }, onError: (_) {
      setState(() {
        aiMessage.content = "⚠️ Something went wrong.";
        _isLoading = false;
      });
    });
  }

  void _stopGeneration() {
    _streamSubscription?.cancel();
    setState(() => _isLoading = false);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /* ===============================
     UI
  =============================== */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF343541),
      appBar: AppBar(
        backgroundColor: const Color(0xFF202123),
        title: const Text("ChatGPT"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (_, index) {
                final msg = _messages[index];
                if (msg.role == "system") return const SizedBox();

                final isUser = msg.role == "user";

                return Container(
                  color: isUser
                      ? const Color(0xFF343541)
                      : const Color(0xFF444654),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: isUser
                            ? Colors.blue
                            : Colors.green,
                        child: Text(
                          isUser ? "U" : "AI",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            MarkdownBody(
                              data: msg.content,
                              selectable: true,
                              styleSheet: MarkdownStyleSheet(
                                p: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                                code: const TextStyle(
                                  backgroundColor: Colors.black54,
                                  color: Colors.greenAccent,
                                ),
                              ),
                            ),
                            if (!isUser)
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.copy,
                                        size: 18,
                                        color: Colors.white70),
                                    onPressed: () {
                                      Clipboard.setData(
                                          ClipboardData(
                                              text: msg.content));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                            Text("Copied")),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.refresh,
                                        size: 18,
                                        color: Colors.white70),
                                    onPressed: () =>
                                        _sendMessage(
                                            regenerate: true),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextButton(
                onPressed: _stopGeneration,
                child: const Text("Stop generating"),
              ),
            ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: const Color(0xFF202123),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Send a message...",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF40414F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}