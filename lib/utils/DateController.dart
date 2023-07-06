import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DateController extends GetxController {
  var user = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;

  var currentEventName = ''.obs;
  var currentDescription = ''.obs;

  var space_id = "".obs; // TODO: obtain from space selection
  var test = 1.obs;

  var db = FirebaseFirestore.instance;

  // filter
  Map filter = {
    'active': false,
    'list': {
      'categories':'',
      'services':'',
    },
    'numeric':{
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

  String getUser() => user.value;
  String getEmail() => email.value;
  String getPhone() => phone.value;

  String getCurrentEventName() => currentEventName.value;
  String getCurrentDescription() => currentDescription.value;

  String getSpaceId() => space_id.value;

  Map getFilter() => filter;

  Map getCurrentBy(){
    return {
      'name': user.value,
      'email': email.value,
      'phone': phone.value,
    };
  }

  void deleteBooking(id) async {
    await db.collection('bookings').doc(id).delete();
  }

}
