import 'package:flutter/material.dart';

import 'day_Selection.dart';

class DatePicker extends StatefulWidget {
  DatePicker({Key? key}) : super(key: key);



  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime _selectedDate = DateTime.now();

  TextEditingController controller_name = TextEditingController();
  TextEditingController controller_email = TextEditingController();
  TextEditingController controller_phone = TextEditingController();
  TextEditingController controller_description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rellena tus datos'),
      ),
      body: Center(
        //put a detepicker here
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                margin: const EdgeInsets.only(bottom: 20),
                child: const Text(
                  'Porfavor diligencie los siguientes datos:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )
                )
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              margin: const EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: controller_name,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre completo',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              margin: const EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: controller_email,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Correo electrónico',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              margin: const EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: controller_phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Número de teléfono',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              margin: const EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: controller_description,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Descripción del uso que le piensa dar al espacio',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DayCalendar()),
                    );

                  },
                  child: const Text('Continuar')
              ),
            ),
          ],
        ),

      ),
    );
  }
}