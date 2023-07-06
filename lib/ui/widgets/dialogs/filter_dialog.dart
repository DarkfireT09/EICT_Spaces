import 'package:eict_scheduling_test1/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../utils/DateController.dart';

Widget getFilterDialog(context) {
  final _formKey = GlobalKey<FormState>();
  // DateController controller = DateController();
  DateController controller = Get.find();
  var filter = controller.getFilter();
  return Dialog.fullscreen(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
              ),
            ),
            title: Text('Filtrar Espacios'),
          ),
          body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownButtonFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Uso del espacio'
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Sala de Cómputo', child: Text('Sala de cómputo')),
                          DropdownMenuItem(value: 'Laboratorio', child: Text('Laboratorio')),
                          DropdownMenuItem(value: 'Trabajo grupal-coworking', child: Text('Trabajo Grupal')),
                        ],
                        onChanged: (value){
                          filter['list']['categories'] = value;
                        }
                    ),
                    DropdownButtonFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Tipo del espacio'
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Docencia', child: Text('Docencia')),
                          DropdownMenuItem(value: 'Experimentación', child: Text('Experimentación')),
                          DropdownMenuItem(value: 'Investigación', child: Text('Investigación')),
                        ],
                        onChanged: (value){
                          print(value);
                          filter['list']['services'] = value;
                        }
                    ),
                    TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Capacidad'),
                        keyboardType: TextInputType.number,
                        onChanged: (value){
                          filter['numeric']['student_capacity'] = int.tryParse(value);
                          // print(filter['numeric']['capacity']);
                        },
                        validator: (value) {
                          // if (value == null || value.isEmpty) {
                          //   return 'Requerido';
                          // }

                          if (int.parse(value!) < 0) {
                            return 'El valor debe ser positivo';
                          }
                        },
                      ),
                    TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Dispositivos Disponibles'),
                      keyboardType: TextInputType.number,
                      onChanged: (value){
                        filter['numeric']['equipment_amount'] = int.tryParse(value);
                      },
                      validator: (value) {
                        // if (value == null || value.isEmpty) {
                        //   return 'Requerido';
                        // }

                        if (int.parse(value!) < 0) {
                          return 'El valor debe ser positivo';
                        }
                      },
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              // validate and save
                              if (_formKey.currentState!.validate()) {
                                filter['active'] = true;
                                // print("Seting filter from dialog: $filter");
                                controller.setFilter(filter);
                                // print("Filter from dialog: ${controller.getFilter()}");
                                // Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MyApp()),
                                );
                                controller.test.value = 2;
                              }
                            },
                            child: const Text('Guardar Filtros')),
                        ElevatedButton(
                          onPressed: () {
                            _formKey.currentState!.reset();
                          },
                          child: const Text('Limpiar Filtros')
                        )
                      ],
                    )
                  ],
                )),
          )));
}
