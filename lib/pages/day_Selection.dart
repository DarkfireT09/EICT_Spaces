import 'package:flutter/material.dart';
//import "package:flutter_speed_dial/flutter_speed_dial.dart";
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:time_range_picker/time_range_picker.dart';

/// The app which hosts the home page which contains the calendar on it.
class CalendarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Calendar Demo',
        theme: ThemeData(useMaterial3: true),
        home: DayCalendar());
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
  var count = 0;
  final CalendarController _calendarController = CalendarController();
  final List<Meeting> meetings = <Meeting>[
    // add meeting at 2023 april 24 9:00 to 11:00
    Meeting('Meeting', DateTime(2023, 4, 25, 9), DateTime(2023, 4, 25, 11),
        Colors.green, false, true),
    Meeting('Meeting', DateTime(2023, 4, 25, 15), DateTime(2023, 4, 25, 17),
        Colors.green, false, true),
    Meeting("Not available", DateTime(2023, 4, 25, 0), DateTime(2023, 4, 25, 7),
        const Color(0x00000000), false, true),
    Meeting("Not available", DateTime(2023, 4, 25, 18),
        DateTime(2023, 4, 25, 24), const Color(0x00000000), false, true),
  ];

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
          dataSource: MeetingDataSource(_getDataSource()),
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
                        !details.appointments![0].isConfirmed
                            ? TextButton(
                          child: const Text('Delete'),
                          onPressed: () {
                            setState(() {
                              meetings.remove(details.appointments![0]);
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
          // remove all not confirmed meetings
          count = 0;
          setState(() {
            meetings.removeWhere((element) => !element.isConfirmed);
          });
        },
        child: const Icon(Icons.delete),
      ),

    );
  }


  void _dayTapUserHandler(details) async {
    List<Meeting> interval = getNearestMeetings(details.date!);
    bool changeCheck = false;
    Meeting? currentMeeting;
    if (details.targetElement == CalendarElement.appointment) {
      currentMeeting = details.appointments![0];
      print(currentMeeting!.from);
      if (!details.appointments![0].isConfirmed) {
        // interval = [currentMeeting, currentMeeting];
        changeCheck = true;
      }
    }

    if (details.targetElement == CalendarElement.calendarCell ||
        changeCheck) {
      // print("start: ${interval[0].to.hour} end: ${interval[1].from.hour}");
      // print("start: ${interval[0].to} end: ${interval[1].from}");

      TimeRange result = await showTimeRangePicker(
        context: context,
        minDuration: const Duration(hours: 1),
        start: TimeOfDay(
            hour: changeCheck
                ? currentMeeting!.from.hour
                : details.date!.hour,
            minute: changeCheck ? currentMeeting!.from.minute : 0),
        end: TimeOfDay(
            hour: changeCheck
                ? currentMeeting!.to.hour
                : details.date!.hour + 1,
            minute: changeCheck ? currentMeeting!.to.minute : 0),
        interval: const Duration(hours: 1),
        disabledTime: TimeRange(
          startTime: TimeOfDay(
              hour: interval[1].from.hour,
              minute: interval[1].from.minute),
          endTime: TimeOfDay(
              hour: interval[0].to.hour, minute: interval[0].to.minute),

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
          return ClockLabel.fromIndex(
              idx: e.key, length: 8, text: e.value);
        }).toList(),
      );
      if (result == null) return;
      print(result);
      if (changeCheck) {
        setState(() {
          currentMeeting?.from = DateTime(
              details.date!.year,
              details.date!.month,
              details.date!.day,
              result.startTime.hour,
              result.startTime.minute);
          currentMeeting?.to = DateTime(
              details.date!.year,
              details.date!.month,
              details.date!.day,
              result.endTime.hour,
              result.endTime.minute);
        });
        return;
      }
      DateTime start = DateTime(
          details.date!.year,
          details.date!.month,
          details.date!.day,
          result.startTime.hour,
          result.startTime.minute);
      DateTime end = DateTime(details.date!.year, details.date!.month,
          details.date!.day, result.endTime.hour, result.endTime.minute);
      count++;

      setState(() {

        _getDataSource().add(Meeting('Test $count', start, end,
            const Color(0xff01454f), false, false));
      });
    }
  }

  // function that gets the nearest meeting before and after to the given date and return both
  List<Meeting> getNearestMeetings(DateTime date) {
    // sort meetings by date
    meetings.sort((a, b) => a.from.compareTo(b.from));

    // meting right now
    var now = DateTime.now();

    // find the nearest meeting before the given date
    var before = meetings.lastWhere(
        (element) => element.to.isBefore(date.add(const Duration(minutes: 1))));
    // print(before.to);
    // find the nearest meeting after the given date
    var after = meetings.firstWhere((element) => element.from.isAfter(date));
    return [before, after];
  }

  bool isCollide(DateTime start, DateTime end) {
    for (var i = 0; i < meetings.length; i++) {
      if (start.isAfter(meetings[i].from) && start.isBefore(meetings[i].to)) {
        return true;
      }
      if (end.isAfter(meetings[i].from) && end.isBefore(meetings[i].to)) {
        return true;
      }
    }
    return false;
  }

  List<Meeting> _getDataSource() {
    return meetings;
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
      this.isConfirmed);

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
}
