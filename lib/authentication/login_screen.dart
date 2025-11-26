import 'dart:async';

import 'package:flutter/material.dart';
import 'package:privy_flutter/privy_flutter.dart';
import 'package:privyio/home/home_screen.dart';

import '../privy_manager.dart';
import 'email_authentication_screen.dart';
import 'sms_authentication_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool _isPrivyReady = false;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _initializePrivyAndAwaitReady();
  }

  Future<void> _initializePrivyAndAwaitReady() async {
    try {
      privyManager.initializePrivy();
      await privyManager.privy.awaitReady();

      if (mounted) {
        setState(() {
          _isPrivyReady = true;
        });
        _setupAuthListener();
      }
    } catch (e) {
      debugPrint("Error initializing Privy: $e");
    }
  }

  void _setupAuthListener() {
    _authSubscription?.cancel();

    _authSubscription = privyManager.privy.authStateStream.listen((state) {
      debugPrint('Auth state changed: $state');

      if (state is Authenticated && mounted) {
        debugPrint('User authenticated: ${state.user.id}');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen(user: state.user)),
        );
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            _isPrivyReady
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      "Privy",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const EmailAuthenticationScreen(),
                            ),
                          );
                        },
                        child: const Text('Login With Email'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => const SmsAuthenticationScreen(),
                            ),
                          );
                        },
                        child: const Text('Login With SMS'),
                      ),
                    ),
                  ],
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Initializing Privy...",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
      ),
    );
  }
}
