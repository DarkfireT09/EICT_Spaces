import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../utils/utils.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Image.network('https://picsum.photos/300/100'),
          const SizedBox(height: 64.0),
          const Text(
              'Bienvenido a EICT Spaces',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
          ),
          const Text(
              'Por favor inicie sesión para continuar',
          ),
          const SizedBox(height: 8.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color(0xFFB2372E),
              surfaceTintColor: const Color(0xFFB2372E),
            ),
            onPressed: () async {
              UserCredential? user = await signInWithMicrosoft();
              if (user != null) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(title: 'EICT Spaces'),
                  ),
                  (route) => false,
                );
              }
            },
            child: const Text('Iniciar sesión con cuenta de URosario'),
          ),
        ])
      ),
    );
  }
}
