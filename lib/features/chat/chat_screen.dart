import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/chat_provider.dart';
import '../../core/theme/app_theme.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  bool isSending = false;

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    final message = messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      isSending = true;
    });

    try {
      await ref.read(chatProvider.notifier).sendMessage(message);
      messageController.clear();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isSending = false;
        });
      }
    }
  }

  Widget _buildRecommendations(List<dynamic> recommendations) {
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Wellness Guide"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppTheme.pink),
              ),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    error.toString(),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      "Start a supportive conversation",
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 6,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final message = items[index];
                    final isUser = message.role == "user";

                    return Column(
                      crossAxisAlignment: isUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: ConstrainedBox(
                            // Caps bubble width so long messages wrap
                            // instead of stretching edge to edge — same
                            // ~78% max-width used in the mockup.
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.78,
                            ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                // User bubbles: bold gradient (the "this
                                // is you speaking" accent).
                                // Assistant bubbles: soft glass fill,
                                // matching every other panel in the app.
                                gradient: isUser
                                    ? AppTheme.accentGradient
                                    : null,
                                color: isUser ? null : AppTheme.glassFill,
                                border: isUser
                                    ? null
                                    : Border.all(color: AppTheme.glassBorder),
                                // Asymmetric corner radius gives each
                                // bubble a subtle "tail" pointing toward
                                // its sender, a common chat-UI convention.
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                                  bottomRight: Radius.circular(
                                    isUser ? 4 : 16,
                                  ),
                                ),
                                boxShadow: isUser
                                    ? [
                                        BoxShadow(
                                          color: AppTheme.violet.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 14,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                message.content,
                                style: TextStyle(
                                  color: isUser
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.9),
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (!isUser && message.recommendations.isNotEmpty)
                          _buildRecommendations(message.recommendations),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          // ── Input row: pill-shaped glass field + circular gradient send button ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.glassFill,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppTheme.glassBorder),
                    ),
                    child: TextField(
                      controller: messageController,
                      enabled: !isSending,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: const TextStyle(color: Colors.white38),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: isSending ? null : sendMessage,
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: AppTheme.accentGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.violet.withValues(alpha: 0.4),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: isSending
                        ? const Padding(
                            padding: EdgeInsets.all(13),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}