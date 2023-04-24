import 'package:flutter/material.dart';

import 'date_picker.dart';

class SpaceDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Space Detail'),
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DatePicker()),
            );
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                // ClipRRect(
                //   //width: double.infinity,
                //   borderRadius: const BorderRadius.all(
                //       Radius.circular(10)),
                //   child: Image.network(
                //     'https://picsum.photos/500',
                //     width: double.infinity,
                //     fit: BoxFit.cover,
                //   ),
                // ),
                Expanded(
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
                          'Sede-Ubicacion-Sala',
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
        ),
      ),
    );
  }
}
