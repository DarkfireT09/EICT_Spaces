import 'package:flutter/material.dart';

import '../utils/utils.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          const Text('Login'),
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () {
              signInWithMicrosoft();
            },
            child: const Text('Sign in with Microsoft'),
          ),
        ])
      ),
    );
  }
}
