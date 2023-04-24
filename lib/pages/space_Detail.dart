import 'package:flutter/material.dart';
import 'package:eict_scheduling_test1/pages/date_picker.dart';

class SpaceDetail extends StatelessWidget {
  const SpaceDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Space Detail'),
      ),
      /*body: Center(
        //put a detepicker here
        child: CalendarDatePicker(
          initialDate: DateTime.now(),
          firstDate: DateTime(2021),
          lastDate: DateTime(2025),
          onDateChanged: (DateTime date) {
            // Do something
          },
        ),

      ),*/
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DatePicker()),
            );
          },
          child: const Text('Go to date picker'),
        ),
      )
    );
  }
}