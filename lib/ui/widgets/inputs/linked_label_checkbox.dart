import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LinkedLabelCheckbox extends StatelessWidget {
  LinkedLabelCheckbox({
    super.key,
    required this.label,
    required this.padding,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;
  final storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          RichText(
              text: TextSpan(
                text: label,
                style: const TextStyle(
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    final storageRef = storage.ref();
                    final String fileUrl = await storageRef.child("010823_Reserva_de_espacios.pdf").getDownloadURL();
                    final url = Uri.encodeFull(fileUrl);
                    try {
                      await launchUrlString(url, mode: LaunchMode.externalApplication);
                    } catch (e) {
                      print('Error launching url: ${e.toString()}');
                    }
                  },
              ),
            ),

          Checkbox(
            value: value,
            onChanged: (bool? newValue) {
              onChanged(newValue!);
            },
          ),
        ],
      ),
    );
  }
}