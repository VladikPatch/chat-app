import 'dart:developer' show log;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sendMessageProvider = Provider((ref) {
  return (String message) async {
    if (message.trim().isEmpty) return;

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      await FirebaseFirestore.instance.collection('chat').add({
        'user_uid': user.uid,
        'username': userData.data()!['username'],
        'image_url': userData.data()!['image_url'],
        'createdAt': Timestamp.now(),
        'message': message,
      });
    } catch (e) {
      log(e.toString());
    }
  };
});
