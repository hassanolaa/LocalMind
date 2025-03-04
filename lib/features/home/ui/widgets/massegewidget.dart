

import 'package:flutter/material.dart';
import 'package:gpt/core/theming/colors.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
class MessageBubble extends StatelessWidget {
  final bool isUser;
  final IconData avatarIcon;
  final Color backgroundColor;
  final String content;
  final VoidCallback onCopy;

  const MessageBubble({
    required this.isUser,
    required this.avatarIcon,
    required this.backgroundColor,
    required this.content,
    required this.onCopy,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: backgroundColor,
          child: Icon(
            avatarIcon,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isUser)
                  Text(
                    content.split(': ')[0] + ':',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 61, 75, 229),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                MarkdownBody(
                  data: isUser ? content : content.split(': ')[1],
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.copy, color: Colors.white),
                    tooltip: isUser ? 'Copy Prompt' : 'Copy Response',
                    onPressed: onCopy,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
