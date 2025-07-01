import 'dart:developer' show log;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  final _firebase = FirebaseAuth.instance;

  Future<void> authenticateUser({
    required String username,
    required String email,
    required String password,
    required bool isLogin,
    required Uint8List? imageBytes,
  }) async {
    if (isLogin) {
      await _signIn(email, password);
    } else {
      await _signUp(username, email, password, imageBytes);
    }
  }

  Future<void> _signIn(String email, String password) async {
    await _firebase.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> _signUp(
    String username,
    String email,
    String password,
    Uint8List? imageBytes,
  ) async {
    if (imageBytes == null) return;

    final userCredentials = await _firebase
        .createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
    log(userCredentials.toString());

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child('${userCredentials.user!.uid}.jpg');

    final metadata = SettableMetadata(contentType: 'image/jpeg');

    await storageRef.putData(imageBytes, metadata);
    final imageUrl = await storageRef.getDownloadURL();

    FirebaseFirestore.instance
        .collection('users')
        .doc(userCredentials.user!.uid)
        .set({
          'username': username,
          'email': email,
          'image_url': imageUrl,
        });
  }
}
