import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24.0, 96.0, 24.0, 24.0),
        children: [
          Column(
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 24.0),
              SupaEmailAuth(
                redirectTo: "io.supabase.flutter://",
                onSignInComplete: (res) =>
                    Navigator.pushNamed(context, '/login'),
                onSignUpComplete: (res) =>
                    Navigator.pushNamed(context, '/login'),
                onError: (error) => SnackBar(content: Text(error.toString())),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
