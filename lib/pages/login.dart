import 'dart:ffi';

import 'package:eict_scheduling_test1/ui/widgets/inputs/linked_label_checkbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../utils/utils.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Image.network('https://urosario.edu.co/sites/default/files/2023-03/escudo-urosario.jpeg'),
          const SizedBox(height: 64.0),
          const Text(
              'Bienvenido a EICT Spaces',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
          ),
          const Text(
              'Por favor inicie sesión para continuar',
              style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
              LinkedLabelCheckbox(
                label: 'Acepta la política de tratamento de datos',
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                value: isSelected,
                onChanged: (bool newValue) {
                  setState(() {
                    isSelected = newValue;
                  });
                },
              ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color(0xFFB2372E),
              surfaceTintColor: const Color(0xFFB2372E),
            ),
            onPressed: isSelected ? () async {
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
            } : null,
            child: const Text('Iniciar sesión con cuenta de URosario'),
          ),
        ])
      ),
    );
  }
}
