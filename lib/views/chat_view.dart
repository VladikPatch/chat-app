import 'dart:developer' show log;
import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/send_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  void initState() {
    super.initState();
    _toggleNotifications();
  }

  void _toggleNotifications() async {
    final firebase = FirebaseMessaging.instance;
    await firebase.requestPermission();
    final token = await firebase.getToken();

    firebase.subscribeToTopic('chat');
  }

  void _showCupertinoDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Confirm'),
          content: Text('Are you sure you want to sign out?'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            CupertinoDialogAction(
              onPressed: () => _signout(context),
              isDestructiveAction: true,
              child: Text('Sign out'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => _showCupertinoDialog(context),
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: ChatMessages()),
          SendMessage(),
        ],
      ),
    );
  }
}
