import 'package:flutter/material.dart';

Widget getFilterDialog(context) {
  final _formKey = GlobalKey<FormState>();
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
                          DropdownMenuItem(value: 'computing_room', child: Text('Sala de cómputo')),
                          DropdownMenuItem(value: 'laboratory', child: Text('Laboratorio')),
                          DropdownMenuItem(value: 'coworking', child: Text('Trabajo Grupal')),
                        ],
                        onChanged: (value){}
                    ),
                    DropdownButtonFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Tipo del espacio'
                        ),
                        items: const [
                          DropdownMenuItem(value: 'teaching', child: Text('Docencia')),
                          DropdownMenuItem(value: 'experimentation', child: Text('Experimentación')),
                          DropdownMenuItem(value: 'investigation', child: Text('Investigación')),
                        ],
                        onChanged: (value){}
                    ),
                    TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Capacidad'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Requerido';
                          }

                          if (int.parse(value) < 0) {
                            return 'El valor debe ser positivo';
                          }
                        }),
                    TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Dispositivos Disponibles'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }

                        if (int.parse(value) < 0) {
                          return 'El valor debe ser positivo';
                        }
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _formKey.currentState!.validate();
                        },
                        child: const Text('Guardar Filtros'))
                  ],
                )),
          )));
}
