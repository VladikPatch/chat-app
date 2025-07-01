import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat'), centerTitle: false),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
