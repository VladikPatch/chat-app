import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authentificatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No messages yet'));
        }

        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong!'));
        }

        final loadedMessages = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          padding: EdgeInsets.only(left: 13, right: 40, bottom: 40),
          itemCount: loadedMessages.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> messageData =
                loadedMessages[index].data();
            final Map<String, dynamic>? nextMessageData =
                index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;
            final String currentMessageUserUid =
                messageData['user_uid'];
            final dynamic nextMessageUserUid = nextMessageData != null
                ? nextMessageData['user_uid']
                : null;
            final nextUserIsSame =
                nextMessageUserUid == currentMessageUserUid;

            if (nextUserIsSame) {
              return MessageBubble.next(
                message: messageData['message'],
                isMe:
                    authentificatedUser.uid == currentMessageUserUid,
              );
            } else {
              return MessageBubble.first(
                userImage: messageData['image_url'],
                username: messageData['username'],
                message: messageData['message'],
                isMe:
                    authentificatedUser.uid == currentMessageUserUid,
              );
            }
          },
        );
      },
    );
  }
}
