import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Authentication screen replacement - redirects to home
/// This is a simple redirect screen in case any code still references the auth route
class AuthScreen extends StatefulWidget {
  /// Default constructor
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
    // Immediately redirect to home screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
