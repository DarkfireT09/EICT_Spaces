import 'package:flutter/material.dart';
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
  final List<Meeting> meetings = <Meeting>[
    // add meeting at 2023 april 24 9:00 to 11:00
    Meeting('Meeting', DateTime(2023, 4, 25, 9), DateTime(2023, 4, 25, 11),
        Colors.green, false, true),
    Meeting('Meeting', DateTime(2023, 4, 25, 15), DateTime(2023, 4, 25, 17),
        Colors.green, false, true),
    Meeting("Non Availeable", DateTime(2023, 4, 25, 0),
        DateTime(2023, 4, 25, 7), Colors.black, false, true),
    Meeting("Non Availeable", DateTime(2023, 4, 25, 18),
        DateTime(2023, 4, 25, 24), Colors.black, false, true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SfCalendar(
      view: CalendarView.day,
      dataSource: MeetingDataSource(_getDataSource()),

      onTap: (CalendarTapDetails details) async {
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

        if (details.targetElement == CalendarElement.calendarCell || changeCheck) {


          // print("start: ${interval[0].to.hour} end: ${interval[1].from.hour}");
          // print("start: ${interval[0].to} end: ${interval[1].from}");

          TimeRange result = await showTimeRangePicker(
            context: context,
            start: TimeOfDay(hour: changeCheck ? currentMeeting!.from.hour : details.date!.hour, minute: 0),
            end: TimeOfDay(hour: details.date!.hour + 1, minute: 0),
            interval: const Duration(minutes: 30),
            disabledTime: TimeRange(
              startTime: TimeOfDay(
                  hour: interval[1].from.hour, minute: interval[1].from.minute),
              endTime: TimeOfDay(
                  hour: interval[0].to.hour, minute: interval[0].to.minute),

              // startTime:  TimeOfDay(hour: 15, minute: 0),
              // endTime: TimeOfDay(hour: 11, minute: 0),
            ),
            use24HourFormat: false,
            padding: 10,
            strokeWidth: 4,
            handlerRadius: 14,
            snap: true,
            ticks: 48,
          );
          if (result == null) return;
          print(result);
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
            // _getDataSource().add(Meeting(
            //     'Meeting',
            //     details.date!,
            //     details.date!.add(const Duration(hours: 1)),
            //     Colors.blue,
            //     false));
            _getDataSource().add(Meeting(
                'Test $count', start, end, Colors.yellow, false, false));
          });
        }
      },

      // by default the month appointment display mode set as Indicator, we can
      // change the display mode as appointment using the appointment display
      // mode property
      monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
    ));
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
    // final DateTime today = DateTime.now();
    // final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    // final DateTime endTime = startTime.add(const Duration(hours: 2));
    // meetings.add(Meeting(
    //     'Conference', startTime, endTime, const Color(0xFF0F8644), false));
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
