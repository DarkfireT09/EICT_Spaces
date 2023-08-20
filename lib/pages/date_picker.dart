import 'package:eict_scheduling_test1/utils/DateController.dart';
import 'package:eict_scheduling_test1/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'day_Selection.dart';

class DatePicker extends StatefulWidget {
  DatePicker({Key? key}) : super(key: key);



  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime _selectedDate = DateTime.now();

  final DateController controller = Get.put(DateController());
  TextEditingController controller_eventName = TextEditingController();
  bool validateEventName = false;
  TextEditingController controller_name = TextEditingController();
  bool validateName = false;
  TextEditingController controller_email = TextEditingController();
  bool validateEmail = false;
  TextEditingController controller_phone = TextEditingController();
  bool validatePhone = false;
  TextEditingController controller_description = TextEditingController();
  bool validateDescription = false;

  @override
  void initState() {
    super.initState();
    controller_name.text = controller.getUser();
    controller_email.text = controller.getEmail();
    controller_phone.text = controller.getPhone();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rellena tus datos'),
      ),
      body: Center(
        //put a detepicker here
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                margin: const EdgeInsets.only(bottom: 20),
                child: const Text(
                  'Por favor, diligencie los siguientes datos:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )
                )
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              margin: const EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: controller_eventName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre del evento',
                  errorText: validateEventName ? 'El nombre del evento no puede estar vacío' : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              margin: const EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: controller_name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre completo',
                  errorText: validateName ? 'El nombre no puede estar vacío' : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              margin: const EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: controller_email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Correo electrónico',
                  errorText: validateEmail ? 'El correo electrónico no es valido' : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              margin: const EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: controller_phone,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Número de teléfono',
                  errorText: validatePhone ? 'El número de teléfono no es valido' : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              margin: const EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: controller_description,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Descripción del uso que le piensa dar al espacio',
                  errorText: validateDescription ? 'La descripción no puede estar vacía' : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              margin: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                  onPressed: () async {
                    setState(()  {
                      controller_eventName.text.isEmpty ? validateEventName = true : validateEventName = false;
                      controller_name.text.isEmpty ? validateName = true : validateName = false;
                      //controller_email.text.isEmpty ? validateEmail = true : validateEmail = false;
                      //controller_phone.text.isEmpty ? validatePhone = true : validatePhone = false;
                      controller_description.text.isEmpty ? validateDescription = true : validateDescription = false;
                    });

                    if(!controller_email.text.contains('@') || !controller_email.text.contains('.')){
                      setState(() {
                        validateEmail = true;
                      });
                    } else {
                      setState(() {
                        validateEmail = false;
                      });
                    }


                    if(!controller_phone.text.isNumericOnly){
                      setState(() {
                        validatePhone = true;
                      });
                    } else {
                      setState(() {
                        validatePhone = false;
                      });
                    }

                    if(validateEventName || validateName || validateEmail || validatePhone || validateDescription){
                      return;
                    }
                    controller.setUser(controller_name.text);
                    controller.setEmail(controller_email.text);
                    controller.setPhone(controller_phone.text);
                    controller.setCurrentEventName(controller_eventName.text);
                    controller.setCurrentDescription(controller_description.text);
                    
                    // controller.addMeetings();
                    var spaceName = await controller.getSpaceNameFromId(controller.getSpaceId());
                    showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(
                        title: const Text('Confirmación'),
                        content: Text('Espacio: $spaceName'),
                        actions: [
                          TextButton(
                            onPressed: (){
                              print('Cancel');
                            },
                            child: const Text('Aceptar'),
                          )
                        ],
                      );
                    });

                  },
                  child: const Text('Continuar')
              ),
            ),
          ],
        ),

      ),
    );
  }
}