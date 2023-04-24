import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  DatePicker({Key? key}) : super(key: key);

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detallas del espacio'),
      ),
      body: Center(
        //put a detepicker here
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Dia de la reserva:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            Text(
              //DateTime.now().day.toString() + '/' + DateTime.now().month.toString() + '/' + DateTime.now().year.toString(),
              _selectedDate.day.toString() + '/' + _selectedDate.month.toString() + '/' + _selectedDate.year.toString(),
              style: TextStyle(fontSize: 20),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                  onPressed: ()async{
                    final dia = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30))
                    );

                    if(dia != null){
                      setState(() {
                        _selectedDate = dia;
                      });
                    }
                  },
                  child: const Text('Seleccionar fecha')
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                  onPressed: (){},
                  child: const Text('Reservar')
              ),
            ),
          ],
        ),

      ),
    );
  }
}