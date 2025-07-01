import 'package:flutter/material.dart';
import 'package:chat_app/themes/app_theme.dart';
import 'package:chat_app/views/auth_view.dart';
import 'package:chat_app/views/chat_view.dart';
import 'package:chat_app/views/loading_view.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: const App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatApp',
      theme: AppTheme.lightTheme,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingView();
          }
          if (snapshot.hasData) {
            return ChatView();
          }
          return AuthView();
        },
      ),
    );
  }
}
