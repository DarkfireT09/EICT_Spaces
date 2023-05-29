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

Future<List> getSpaces() async {
  var db = FirebaseFirestore.instance;
  var spacesCollection = db.collection('spaces');
  QuerySnapshot querySnapshot = await spacesCollection.get();
  List<QueryDocumentSnapshot> spaces = querySnapshot.docs;
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
  if (kIsWeb) {
    await FirebaseAuth.instance.signInWithPopup(microsoftProvider);
  } else {
    await FirebaseAuth.instance.signInWithProvider(microsoftProvider);
  }
}