
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../utils/DateController.dart';

class CurrentApointments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Calendar Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: const DayCalendar());
  }
}

class DayCalendar extends StatefulWidget {
  const DayCalendar({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DayCalendarState createState() => _DayCalendarState();
}

class _DayCalendarState extends State<DayCalendar> {
  final DateController controller = Get.put(DateController());
  final List colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.brown,
    Colors.cyan,
    Colors.indigo,
    Colors.lime,
    Colors.amber,
    Colors.black,
    Colors.grey,
    Colors.blueGrey,
  ];
  var spaces_colors = {};

  var db = FirebaseFirestore.instance;
  final CalendarController _calendarController = CalendarController();
  MeetingDataSource? events;
  @override
  void initState() {
    // _initializeEventColor();
    initColors();
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });

    super.initState();
  }

  void initColors() async {
    var spaces = await db.collection("spaces").get();
    var count = 0;
    for (var element in spaces.docs) {
      spaces_colors[element.data()["name"].toString()] = colors[count % colors.length];
      count++;
    }
  }

  Future<void> getDataFromFireStore() async {
    var spaces = await db.collection("spaces").get();
    // Map<String, Color> spaces_colors = {};
    // for (var element in spaces.docs) {
    //   element.data()["name"] = colors[spaces.docs.indexOf(element)];
    // }
    var snapShotsValue =
    await db.collection("bookings").get();
    var filteredAppointments = snapShotsValue.docs.where((element) => element.data()['by']["email"] == controller.getEmail());

    List<Meeting> list = filteredAppointments
        .map((e) => Meeting(
      "${spaces.docs.where((element) => element.id == e.data()["space_id"]).first["name"].toString()} - ${e.data()['name']}",
      e.data()['from'].toDate(),
      e.data()['to'].toDate(),
      spaces_colors[spaces.docs.where((element) => element.id == e.data()["space_id"]).first["name"].toString()],
      false,
      false,
      e.data()['reason'],
      e.data()['by'],
      e.data()['space_id'],
    ))
        .toList();

    setState(() {
      events = MeetingDataSource(list);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccione el día'),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: SfCalendar(
          view: CalendarView.month,
          controller: _calendarController,
          allowedViews: const [CalendarView.day, CalendarView.month],
          dataSource: events,
          onTap: (CalendarTapDetails details) {
            if (_calendarController.view == CalendarView.month) {
              if (details.targetElement == CalendarElement.calendarCell) {
                final DateTime date = details.date!;
                final DateTime currentDate = DateTime.now();
                if (date.month == currentDate.month &&
                    date.day >= currentDate.day) {
                  _calendarController.view = CalendarView.day;
                  _calendarController.displayDate = date;
                }
              }
            } else if (_calendarController.view == CalendarView.day){
              if (details.targetElement == CalendarElement.appointment) {
                final Meeting appointmentDetails = details.appointments!.first;
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(appointmentDetails.eventName),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                'Desde: ${appointmentDetails.from.toString()}'),
                            Text(
                                'Hasta: ${appointmentDetails.to.toString()}'),
                            Text(
                                'Descripción: ${appointmentDetails.reason}'),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          )
                        ],
                      );
                    });
              }
            }
          },
        ),
      ),
    );
  }

}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay,
      this.isConfirmed, this.reason, this.by, this.space_id);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;

  bool isConfirmed = false;

  String reason;

  Map by;

  String space_id;
}
