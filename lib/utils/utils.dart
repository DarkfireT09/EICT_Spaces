/*void getSpaces(db) async {
  await db.collection("users").get().then((event) {
    for (var doc in event.docs) {
      print("${doc.id} => ${doc.data()}");
    }
  });
}*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../utils/DateController.dart';

// DateController controller = DateController();
DateController controller = Get.find();
Map categoriesNames = {
  "computing_room":"Sala de cómputo",
  "laboratory":"Laboratorio",
  "coworking":"Trabajo Grupal",
};

Map categoriesTypes = {
  "teaching":"Docencia",
  "experimentation":"Experimentación",
  "investigation":"Investigación",
};

Future<Map> getSpace_fromId(String id) async {
  var db = FirebaseFirestore.instance;
  var space = await db.collection('spaces').doc(id).get();
  return {
    'id': space.id,
    'name': space['name'],
    'amount': space['amount'],
    'area': space['area'],
    'campus': space['campus'],
    'categories': space['categories'],
    'dependency': space['dependency'],
    'equipment_amount': space['equipment_amount'],
    'location': space['location'],
    'services': space['services'],
    'student_capacity': space['student_capacity'],
  };
}

Future<List> processFilter(collection) async {
  var filter = controller.getFilter();
  // print("FIlter from process: $filter");

  if (!filter['active']) {
    QuerySnapshot querySnapshot = await collection.get();
    List<QueryDocumentSnapshot> spaces = querySnapshot.docs;
    return spaces;
  }

  Map list = filter['list'];
  Map numeric = filter['numeric'];
  // list.removeWhere((key, value) => value == '');
  // numeric.removeWhere((key, value) => value == -1);
  QuerySnapshot querySnapshot = await collection.get();
  List<QueryDocumentSnapshot> spaces = querySnapshot.docs;

  if (numeric.isNotEmpty){
    // print("Numeric: ${numeric['capacity']}");
    // collection = collection.where('student_capacity', isGreaterThan: numeric['capacity']);
    numeric.forEach((key, value) {
      // collection = collection.where(key, isGreaterThan: value);
      spaces.removeWhere((space) => space[key] < value);
    });
  }

  
  if (list.isNotEmpty){
    // spaces.removeWhere((space) => !list.values.every((value) => space['categories'].contains(value)));
    // spaces.removeWhere((space) => !space['categories'].contains(list['categories']));
    list.forEach((key, value) {
      spaces.removeWhere((space) => !space[key].contains(value));
    });
  }

  return spaces;

}

Future<List> getSpaces() async {
  // print("Filter (getSpaces): ${controller.getFilter()}");
  var db = FirebaseFirestore.instance;
  List spaces = await processFilter(db.collection('spaces'));
  // spacesCollection = spacesCollection.
  // print(controller.getFilter());


  // spaces.removeWhere((space) => !space['categories'].contains('dio'));
  return spaces.map((e) => ({
    'id': e.id,
    'name': e['name'],
    'amount': e['amount'],
    'area': e['area'],
    'campus': e['campus'],
    'categories': e['categories'],
    'dependency': e['dependency'],
    'equipment_amount': e['equipment_amount'],
    'location': e['location'],
    'services': e['services'],
    'student_capacity': e['student_capacity'],
  })).toList();
}

Future<UserCredential?> signInWithMicrosoft() async {
  final microsoftProvider = MicrosoftAuthProvider().setCustomParameters({
    'tenant': 'ae525757-89ba-4d30-a2f7-49796ef8c604',
  });
  var user;
  if (kIsWeb) {
    user = await FirebaseAuth.instance.signInWithPopup(microsoftProvider);
  } else {
    user = await FirebaseAuth.instance.signInWithProvider(microsoftProvider);
  }

  print('LOGGED_USER: $user');
  //print(FirebaseAuth.instance.currentUser);
  return user;
}