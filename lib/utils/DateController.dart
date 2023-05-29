import 'package:get/get.dart';

class DateController extends GetxController {
  var user = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;

  var currentEventName = ''.obs;
  var currentDescription = ''.obs;

  var space_id = "".obs; // TODO: obtain from space selection

  // getters and setters
  void setUser(String value) => user.value = value;
  void setEmail(String value) => email.value = value;
  void setPhone(String value) => phone.value = value;

  void setCurrentEventName(String value) => currentEventName.value = value;
  void setCurrentDescription(String value) => currentDescription.value = value;

  void setSpaceId(String value) => space_id.value = value;

  String getUser() => user.value;
  String getEmail() => email.value;
  String getPhone() => phone.value;

  String getCurrentEventName() => currentEventName.value;
  String getCurrentDescription() => currentDescription.value;

  String getSpaceId() => space_id.value;

  Map getCurrentBy(){
    return {
      'name': user.value,
      'email': email.value,
      'phone': phone.value,
    };
  }
}
