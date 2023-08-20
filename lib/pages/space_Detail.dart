import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eict_scheduling_test1/pages/day_Selection.dart';
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
  DateController controller = Get.find();

  String formatList(list) {
    //print(list);
    var msg = '';
    if (list == null) return 'No data';
    if (list.length == 1) return list[0].toString();
    for (var item in list) {
      msg += item + ', ';
    }
    print(msg);
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
                  child: ListView(
                    children: [
                      Image.network(
                        'https://picsum.photos/500',
                        fit: BoxFit.cover,
                      ),
                      Padding(
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
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              space?['dependency'].toString() ??
                                  'No dependency', // dependencia
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              "Lugar: ${space?['location'].toString() ?? 'No location'}",
                              style: const TextStyle(
                                fontSize: 20.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              "Servicios: ${formatList(space?['services'])}",
                              style: const TextStyle(
                                fontSize: 20.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8.0),
                            formatList(space?['categories']) != ''? Column(
                              children: [
                                Text(
                                  //"Categoria: ${space?['category'].toString() ?? 'No category'}",
                                  "Categoria: ${formatList(space?['categories'])}",
                                  style: const TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12.0),
                                Text(
                                  space?['dependency'].toString() ??
                                      'No dependency', // dependencia
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  "Lugar: ${space?['location'].toString() ?? 'No location'}",
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  "Servicios: ${formatList(space?['services'])}",
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8.0),
                                formatList(space?['categories']) != ''
                                    ? Column(
                                        children: [
                                          Text(
                                            //"Categoria: ${space?['category'].toString() ?? 'No category'}",
                                            "Categoria: ${formatList(space?['categories'])}",
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 8.0),
                                        ],
                                      )
                                    : const SizedBox(height: 0.0),
                                Text(
                                  "Capacidad de estudiantes: ${space?['student_capacity'].toString() ?? 'No student capacity'}",

                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8.0),
                              ],
                            ) : const SizedBox(height: 0.0),
                            Text(
                              "Capacidad de estudiantes: ${space?['student_capacity'].toString() ?? 'No student capacity'}",
                              style: const TextStyle(
                                fontSize: 20.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              //"Cantidad de equipos: ${space?['equipment_quantity'].toString() ?? 'No equipment quantity'}",
                              "Cantidad de equipos: ${space?['equipment_amount'] ?? 'Sin equipos'}",
                              style: const TextStyle(
                                fontSize: 20.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8.0),
                            space?['area'] != '' ? Column(
                              children: [
                                Text(
                                  "Area(m²): ${space?['area'] ?? 'No area'}",
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8.0),
                                space?['area'] != ''
                                    ? Column(
                                        children: [
                                          Text(
                                            "Area(m²): ${space?['area'] ?? 'No area'}",
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 8.0),
                                        ],
                                      )
                                    : const SizedBox(height: 0.0),
                                Container(
                                  margin: const EdgeInsets.only(top: 10.0),
                                  child: const Text(
                                    "Reservar:",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        // big button
                                        width: (MediaQuery.of(context).size.width-72)/2,
                                        height: 40,
                                        margin: const EdgeInsets.only(
                                            top: 10.0, right: 10.0,  left: 10.0),
                                        child: ElevatedButton(
                                          onPressed: () => showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                DayCalendar(),
                                          ),
                                          child: const Text('Para evento',
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                      ),
                                      Container(
                                        // big button
                                        width: (MediaQuery.of(context).size.width-72)/2,
                                        height: 40,
                                        margin: const EdgeInsets.only(
                                            top: 10.0, right: 10.0, left: 10.0),
                                        child: ElevatedButton(
                                          onPressed: () => showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                DayCalendar(),
                                          ),
                                          child: const Text('Para mi',
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                      ),
                                    ])
                              ],
                            ): const SizedBox(height: 0.0),
                          ],
                        ),
                      ),
                    ],
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
