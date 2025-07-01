import 'package:chat_app/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = Provider<AuthService>((ref) => AuthService());
