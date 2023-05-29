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
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: ListView(
                    children: [
                      Expanded( // This is the image
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
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                (space?['name'] ?? 'No name') + " - "+ space?['category'] ?? 'No category',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Depencencia',
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              SizedBox(height: 12.0),
                              Text(
                                'Tipo de Espacio',
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                'Uso del espacio',
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                'Cantidad',
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                'Area',
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                'Capacidad: Estudiantes y Equipos',
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
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
      }
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) =>  DatePicker(),
        ),
        tooltip: 'Reservar',
        icon: const Icon(Icons.arrow_circle_right),
        label: Text('Reservar'),
      ),
    );

  }
}
