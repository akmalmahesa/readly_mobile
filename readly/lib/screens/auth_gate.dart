import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../navigator.dart';
import '../services/auth_service.dart';
import '../services/book_repository.dart';
import 'auth_screen.dart';
import 'splash_screen.dart';

/// Shows a short branded splash, then routes to [AuthScreen] or
/// [AppNavigator] depending on Firebase auth state.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  String? _initializedUid;

  void _initializeFor(String uid) {
    if (_initializedUid == uid) return;
    _initializedUid = uid;
    BookRepository.seedIfEmpty().then((_) {
      AppData.instance.startListening(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: Future.delayed(const Duration(seconds: 2)),
      builder: (context, splashSnapshot) {
        if (splashSnapshot.connectionState != ConnectionState.done) {
          return const SplashScreen();
        }

        return StreamBuilder<User?>(
          stream: AuthService.instance.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }

            final user = snapshot.data;
            if (user == null) {
              _initializedUid = null;
              return const AuthScreen();
            }

            _initializeFor(user.uid);
            return const AppNavigator();
          },
        );
      },
    );
  }
}
