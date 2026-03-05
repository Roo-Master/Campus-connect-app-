import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/ai_chart_services.dart';
import 'backend/ai_model.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({Key? key}) : super(key: key);

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AiChatService _chatService = AiChatService();

  List<AiChatMessage> _messages = [
    AiChatMessage(role: "system", content: "You are a helpful assistant."),
  ];

  StreamSubscription<String>? _streamSubscription;
  bool _isLoading = false;

  /// Send a message (or regenerate)
  void _sendMessage({bool regenerate = false}) {
    final text = regenerate
        ? _messages.lastWhere((m) => m.role == "user").content
        : _controller.text.trim();

    if (text.isEmpty || _isLoading) return;

    if (!regenerate) {
      _controller.clear();
      _messages = List.from(_messages)
        ..add(AiChatMessage(role: "user", content: text));
    }

    final aiMessage = AiChatMessage(role: "assistant", content: "");

    setState(() {
      _messages = List.from(_messages)..add(aiMessage);
      _isLoading = true;
    });

    _scrollToBottom();

    // Cancel previous stream if still running
    _streamSubscription?.cancel();

    _streamSubscription =
        _chatService.sendMessageStream(_messages).listen((chunk) {
          // Immutable update
          setState(() {
            final index = _messages.indexOf(aiMessage);
            if (index != -1) {
              final updated = AiChatMessage(
                role: aiMessage.role,
                content: _messages[index].content + chunk,
              );
              _messages = List.from(_messages)
                ..removeAt(index)
                ..insert(index, updated);
            }
          });
          _scrollToBottom();
        }, onDone: () {
          setState(() => _isLoading = false);
        }, onError: (_) {
          setState(() {
            final index = _messages.indexOf(aiMessage);
            if (index != -1) {
              _messages = List.from(_messages)
                ..removeAt(index)
                ..insert(index, AiChatMessage(
                  role: aiMessage.role,
                  content: "⚠️ Something went wrong.",
                ));
            }
            _isLoading = false;
          });
        });
  }

  void _stopGeneration() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
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

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }

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
                        backgroundColor:
                        isUser ? Colors.blue : Colors.green,
                        child: Text(
                          isUser ? "U" : "AI",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                        size: 18, color: Colors.white70),
                                    onPressed: () {
                                      Clipboard.setData(
                                          ClipboardData(text: msg.content));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(content: Text("Copied")),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.refresh,
                                        size: 18, color: Colors.white70),
                                    onPressed: () =>
                                        _sendMessage(regenerate: true),
                                  ),
                                ],
                              ),
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