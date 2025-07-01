import 'dart:io';
import 'package:chat_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthView extends ConsumerStatefulWidget {
  const AuthView({super.key});

  @override
  ConsumerState<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView> {
  final _formKey = GlobalKey<FormState>();

  String _enteredUsername = '';
  String _enteredEmail = '';
  String _enteredPassword = '';

  bool _isLogin = true;
  bool _isLoading = false;
  File? _selectedImage;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      final imageBytes = _selectedImage != null
          ? await _selectedImage!.readAsBytes()
          : null;

      await ref
          .read(authProvider)
          .authenticateUser(
            username: _enteredUsername,
            email: _enteredEmail,
            password: _enteredPassword,
            isLogin: _isLogin,
            imageBytes: imageBytes,
          );
    } on FirebaseAuthException catch (e) {
      _showSnackBar(e.message ?? 'Auth error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String error) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(error)));
  }

  void _switchView() {
    setState(() {
      _isLogin = !_isLogin;
      _formKey.currentState!.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            color: theme.colorScheme.onPrimary,
            margin: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 40,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 30,
                  right: 30,
                  bottom: 30,
                ),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 30,
                              child: Image.asset(
                                'assets/images/chat.png',
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              'Chat App',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        SizedBox(height: 32),
                        if (!_isLogin)
                          UserImagePicker(
                            onPickedImage: (image) {
                              _selectedImage = image;
                            },
                          ),
                        if (!_isLogin)
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Username',
                            ),
                            enableSuggestions: false,
                            autocorrect: false,
                            onSaved: (value) {
                              _enteredUsername = value!;
                            },
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return 'Empty field';
                              }
                              if (value.length < 4) {
                                return 'Short username';
                              }
                              return null;
                            },
                          ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Empty field';
                            }
                            if (!value.contains('@')) {
                              return 'Invalid value';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                          ),
                          obscureText: true,
                          textCapitalization: TextCapitalization.none,
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Empty field';
                            }
                            if (value.length <= 6) {
                              return 'Short password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 32),
                        _isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _submit,
                                child: Text(
                                  _isLogin ? 'Login' : 'Sign up',
                                ),
                              ),
                        TextButton(
                          onPressed: _isLoading ? null : _switchView,
                          child: Text(
                            _isLogin
                                ? 'Don\'t have an account? Sign up'
                                : 'Already have an account? Sign in',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
