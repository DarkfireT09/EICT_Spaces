import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'date_picker.dart';
import 'package:get/get.dart';
import 'package:eict_scheduling_test1/utils/DateController.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:eict_scheduling_test1/utils/utils.dart';

class SpaceDetail extends StatefulWidget {
  @override
  State<SpaceDetail> createState() => _SpaceDetailState();
}

class _SpaceDetailState extends State<SpaceDetail> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final DateController controller = Get.put(DateController());

  String formatList(list) {
    var msg = '';
    if (list == null) return 'No data';
    if (list.length == 1) return list[0].toString();
    for (var item in list) {
      msg += item + ', ';
    }
    return msg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Space Detail'),
      ),
      body: FutureBuilder(
          future: getSpace_fromId(controller.getSpaceId()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                Map? space = snapshot.data;
                return Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: ListView(
                      children: [
                        Expanded(
                          // This is the image
                          flex: 1,
                          child: SizedBox(
                            width: double.infinity,
                            child: Image.network(
                              'https://picsum.photos/500',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  (space?['name'] ?? 'No name') +
                                      '-' +
                                      (space?['campus'] ?? 'No campus'),
                                  style: const TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  space?['dependency'].toString() ??
                                      'No dependency', // dependencia
                                  style: const TextStyle(fontSize: 20.0),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12.0),
                                Text(
                                  "Lugar: ${space?['location'].toString() ?? 'No location'}",
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                Text(
                                  "Servicios: ${formatList(space?['services'])}",
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                Text(
                                  "Categoria: ${space?['category'].toString() ?? 'No category'}",
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                Text(
                                  "Capacidad de estudiantes: ${space?['student_capacity'].toString() ?? 'No student capacity'}",
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                Text(
                                  "Cantidad de equipos: ${space?['equipment_quantity'].toString() ?? 'No equipment quantity'}",
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                Text(
                                  "Area: ${space?['area'] ?? 'No area'}",
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                Container(
                                  // big button
                                  width: double.infinity,
                                  height: 50,
                                  margin: const EdgeInsets.only(top: 20.0),
                                  child: ElevatedButton.icon(
                                    onPressed: () => showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => DatePicker(),
                                    ),
                                    icon: Icon(Icons.arrow_circle_right),
                                    label: const Text('Reservar', style: TextStyle(fontSize: 20.0)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: Text('No data'),
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),

    );
  }
}
