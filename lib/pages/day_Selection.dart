import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
//import "package:flutter_speed_dial/flutter_speed_dial.dart";
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:time_range_picker/time_range_picker.dart';

import '../utils/DateController.dart';

/// The app which hosts the home page which contains the calendar on it.
class CalendarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Calendar Demo',
        theme: ThemeData(useMaterial3: true),
        home: const DayCalendar());
  }
}

/// The hove page which hosts the calendar
class DayCalendar extends StatefulWidget {
  /// Creates the home page to display teh calendar widget.
  const DayCalendar({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DayCalendarState createState() => _DayCalendarState();
}

class _DayCalendarState extends State<DayCalendar> {
  final DateController controller = Get.put(DateController());

  var count = 0;
  // TODO: Controller variables
  // var id = getSpaceId();
  // var name = "New Request";
  // var reason = "lorem ipsum";
  // var by = {
  //   "email": "a@a.com",
  //   "name": "user",
  //   "phone": "1234567890",
  // };


  var db = FirebaseFirestore.instance;
  final CalendarController _calendarController = CalendarController();
  MeetingDataSource? events;
  var userMeetings = <Meeting>[];
  @override
  void initState() {
    // _initializeEventColor();
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
    super.initState();
  }

  Future<void> getDataFromFireStore() async {
    var id = controller.getSpaceId();
    var spaceBookings =
        await db.collection("bookings").where("space_id", isEqualTo: id).where(Filter.or(Filter("by.email", isEqualTo: controller.getEmail()), Filter("status", isEqualTo: "APPROVED"))).get();

    List<Meeting> list = spaceBookings.docs
        .map((e) => Meeting(
              e.data()['name'],
              e.data()['from'].toDate(),
              e.data()['to'].toDate(),
              Colors.blue,
              false,
              e.data()['status'],
              e.data()['reason'],
              e.data()['by'],
              e.data()['space_id'],
              e.id,
            ))
        .toList();

    var now = DateTime.now();

    list.addAll(
        // Meetings all days from 0 to 7 all year
        List.generate(365, (index) {
      var date = DateTime(now.year, now.month, now.day);
      date = date.add(Duration(days: index));
      return Meeting(
        "Not available",
        DateTime(date.year, date.month, date.day, 0),
        DateTime(date.year, date.month, date.day, 7),
        const Color(0x00000000),
        false,
        "APPROVED",
        "",
        {},
        "",
      );
    }));
    list.addAll(
      // Meetings all days from 7 to 24 all year
      List.generate(365, (index) {
        var date = DateTime(now.year, now.month, now.day);
        date = date.add(Duration(days: index));
        return Meeting(
          "Not available",
          DateTime(date.year, date.month, date.day, 18),
          DateTime(date.year, date.month, date.day, 24),
          const Color(0x00000000),
          false,
          "APPROVED",
          "",
          {},
          "",
        );
      }),
    );
    setState(() {
      events = MeetingDataSource(list+userMeetings);
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
          onLongPress: (CalendarLongPressDetails details) {
            if (details.targetElement == CalendarElement.appointment) {
              final Meeting appointmentDetails = details.appointments![0];
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
                              'From: ${appointmentDetails.from.toString().substring(0, 16)}'),
                          Text(
                              'To: ${appointmentDetails.to.toString().substring(0, 16)}'),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        details.appointments![0].status == "NON SUBMITTED" || details.appointments![0].status == "PENDING"
                            ? TextButton(
                                child: const Text('Eliminar'),
                                onPressed: () {
                                  setState(() {
                                    // print(userMeetings.length);
                                    if (details.appointments![0].status == "NON SUBMITTED"){
                                      userMeetings.remove(appointmentDetails);
                                    } else if (details.appointments![0].status == "PENDING") {
                                      controller.deleteBooking(details.appointments![0].bookingId!);
                                    }
                                    getDataFromFireStore();

                                    // print(userMeetings.length);
                                  });
                                  Navigator.pop(context);
                                },
                              )
                            : Container()
                      ],
                    );
                  });
            }
          },

          onTap: (CalendarTapDetails details) {
            if (_calendarController.view == CalendarView.month &&
                details.targetElement == CalendarElement.calendarCell) {
              // if selected day before today
              if (details.date!.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No puede seleccionar un día anterior'),
                  ),
                );
                return;
              }
              _calendarController.view = CalendarView.day;
              _calendarController.displayDate = details.date!;
            } else if (_calendarController.view == CalendarView.day) {
              _dayTapUserHandler(details);
            }
          },

          // by default the month appointment display mode set as Indicator, we can
          // change the display mode as appointment using the appointment display
          // mode property
          monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addMeetings(userMeetings);
          // return to home
          Navigator.pop(context); // close the drawer
          Navigator.pop(context); // close the calendar
          Navigator.pop(context); // close the space
        },
        child: const Icon(Icons.navigate_next_rounded),
      ),
    );
  }

  void _dayTapUserHandler(details) async {
    if (details.date!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No puede seleccionar una fecha pasada.'),
        ),
      );
      return;
    }
    var id = controller.getSpaceId();
    var name = controller.getCurrentEventName();
    var reason = controller.getCurrentDescription();
    var by = controller.getCurrentBy();
    // if (userMeetings.isNotEmpty){
    //   print("From: -${userMeetings[0].from}");
    //   print("To: -${userMeetings[0].to}");
    // }

    List<Meeting> interval = getNearestMeetings(details.date!);



    bool changeCheck = false;
    Meeting? currentMeeting;
    if (details.targetElement == CalendarElement.appointment) {
      currentMeeting = userMeetings.firstWhere(
          (element) => element.from == details.appointments![0].from);
      print(currentMeeting!.from);
      if (details.appointments![0].status == "NON SUBMITTED") {
        // interval = [currentMeeting, currentMeeting];
        changeCheck = true;
      }
    }

    if (details.targetElement == CalendarElement.calendarCell || changeCheck) {
      // print("start: ${interval[0].to.hour} end: ${interval[1].from.hour}");
      // print("start: ${interval[0].to} end: ${interval[1].from}");

      TimeRange result = await showTimeRangePicker(
        context: context,
        minDuration: const Duration(hours: 1),
        start: TimeOfDay(
            hour: changeCheck ? currentMeeting!.from.hour : details.date!.hour,
            minute: changeCheck ? currentMeeting!.from.minute : 0),
        end: TimeOfDay(
            hour:
                changeCheck ? currentMeeting!.to.hour : details.date!.hour + 1,
            minute: changeCheck ? currentMeeting!.to.minute : 0),
        interval: const Duration(hours: 1),
        disabledTime: TimeRange(
          startTime: TimeOfDay(
              hour: interval[1].from.hour, minute: interval[1].from.minute),
          endTime: TimeOfDay(
              hour: details.date!.day == DateTime.now().day ? DateTime.now().hour+1 : interval[0].to.hour, minute: interval[0].to.minute),

          // startTime:  TimeOfDay(hour: 15, minute: 0),
          // endTime: TimeOfDay(hour: 11, minute: 0),
        ),
        use24HourFormat: false,
        padding: 30,
        strokeWidth: 8,
        handlerRadius: 14,
        snap: true,
        ticks: 48,
        labels: [
          "12 am",
          "3 am",
          "6 am",
          "9 am",
          "12 pm",
          "3 pm",
          "6 pm",
          "9 pm"
        ].asMap().entries.map((e) {
          return ClockLabel.fromIndex(idx: e.key, length: 8, text: e.value);
        }).toList(),
      );
      if (result == null) return;
      // print(result);
      if (changeCheck) {
        setState(() {
          currentMeeting?.from = DateTime(
              details.date!.year,
              details.date!.month,
              details.date!.day,
              result.startTime.hour,
              result.startTime.minute);
          currentMeeting?.to = DateTime(details.date!.year, details.date!.month,
              details.date!.day, result.endTime.hour, result.endTime.minute);
          getDataFromFireStore();
        });
        return;
      }
      DateTime start = DateTime(details.date!.year, details.date!.month,
          details.date!.day, result.startTime.hour, result.startTime.minute);
      DateTime end = DateTime(details.date!.year, details.date!.month,
          details.date!.day, result.endTime.hour, result.endTime.minute);
      count++;

      var newMeeting = Meeting(name, start, end, Colors.blueGrey,
          false, "NON SUBMITTED", reason, by, id);
      // addMeeting(newMeeting);
      userMeetings.add(newMeeting);
      setState(() {
        getDataFromFireStore();
      });
    }
  }

  // function that gets the nearest meeting before and after to the given date and return both
  List<Meeting> getNearestMeetings(DateTime date) {
    // sort events.appointments by date
    events?.appointments?.sort((a, b) => a.from.compareTo(b.from));

    // meting right now
    var now = DateTime.now();

    // find the nearest meeting before the given date
    var before = events?.appointments?.lastWhere(
        (element) => element.to.isBefore(date.add(const Duration(minutes: 1))));
    // print(before.to);
    // find the nearest meeting after the given date
    var after = events?.appointments
        ?.firstWhere((element) => element.from.isAfter(date));
    return [before, after];
  }

  void addMeetings(requestedMeetings) {
    for (var i = 0; i < requestedMeetings.length; i++) {
      var meeting = requestedMeetings[i];
      db.collection("bookings").add({
        "by": meeting.by,
        "name": meeting.eventName,
        "from": meeting.from,
        "to": meeting.to,
        "status": "PENDING",
        "reason": meeting.reason,
        "space_id": meeting.spaceId
      });
    }
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
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
      this.status, this.reason, this.by, this.spaceId, [this.bookingId = ""]);

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

  String status;

  String reason;

  Map by;

  String spaceId;

  String bookingId;
}
