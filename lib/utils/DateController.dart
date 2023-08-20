import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DateController extends GetxController {
  var user = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;

  var currentEventName = ''.obs;
  var currentDescription = ''.obs;

  var space_id = "".obs; // TODO: obtain from space selection

  var db = FirebaseFirestore.instance;

  var currentUserMeetings = [].obs;

  // filter
  Map filter = {
    'active': false,
    'list': {
      'categories': '',
      'services': '',
    },
    'numeric': {
      'student_capacity': -1,
      'equipment_amount': -1
    }
  };

  // getters and setters
  void setUser(String value) => user.value = value;

  void setEmail(String value) => email.value = value;

  void setPhone(String value) => phone.value = value;

  void setCurrentEventName(String value) => currentEventName.value = value;

  void setCurrentDescription(String value) => currentDescription.value = value;

  void setSpaceId(String value) => space_id.value = value;

  void setFilter(Map value) {
    print("setFilter: $value");
    filter = value;
  }

  void setCurrentUserMeetings(List value) => currentUserMeetings.value = value;

  String getUser() => user.value;

  String getEmail() => email.value;

  String getPhone() => phone.value;

  String getCurrentEventName() => currentEventName.value;

  String getCurrentDescription() => currentDescription.value;

  String getSpaceId() => space_id.value;

  Map getFilter() => filter;

  Map getCurrentBy() {
    return {
      'name': user.value,
      'email': email.value,
      'phone': phone.value,
    };
  }

  Future<String> getSpaceNameFromId(String id) async {
    var db = FirebaseFirestore.instance;
    var space = await db.collection('spaces').doc(id).get();
    return space['name'];
  }

  void deleteBooking(id) async {
    await db.collection('bookings').doc(id).delete();
  }

  void addMeetings() {
    var requestedMeetings = currentUserMeetings.value;
    for (var i = 0; i < requestedMeetings.length; i++) {
      var meeting = requestedMeetings[i];
      db.collection("bookings").add({
        "by": getCurrentBy(),
        "name": getCurrentEventName(),
        "from": meeting.from,
        "to": meeting.to,
        "status": "PENDING",
        "reason": getCurrentDescription(),
        "space_id": meeting.spaceId
      });
    }
  }
}
