import 'package:chat_app/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SendMessage extends ConsumerStatefulWidget {
  const SendMessage({super.key});

  @override
  ConsumerState<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends ConsumerState<SendMessage> {
  final TextEditingController _textEditingController =
      TextEditingController();

  void _sendMessage() async {
    final text = _textEditingController.text.trim();

    if (text.isNotEmpty) {
      final sendMessage = ref.read(sendMessageProvider);
      await sendMessage(text);
      _textEditingController.clear();
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 32,
        top: 8,
        right: 16,
        bottom: 48,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                contentPadding: EdgeInsets.only(left: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(onPressed: _sendMessage, icon: Icon(Icons.send)),
        ],
      ),
    );
  }
}
