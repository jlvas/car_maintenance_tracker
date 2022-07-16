import 'package:current_location/utilities/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utilities/dataObject/services.dart';
class AddAlert extends StatefulWidget {

  static const routeName = '/screens/add_alert';
  const AddAlert({Key? key}) : super(key: key);

  @override
  State<AddAlert> createState() => _AddAlertState();
}

class _AddAlertState extends State<AddAlert> {

  final _key = GlobalKey<FormState>();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _serviceName = TextEditingController();
  final TextEditingController _mileage = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final fileController = Provider.of<FileController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Alert'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                validator: (val){
                  if(val!.isEmpty) return 'must enter';
                },
                controller: _serviceName,
                decoration: const InputDecoration(
                  label: Text('Service Name')
                ),
              ),
              const Divider(),
              TextFormField(
                validator: (val){
                  if(val!.isEmpty) return 'must enter';
                },
                controller: _mileage,
                decoration: const InputDecoration(
                  label: Text('Mileage'),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: (){
                  if(_key.currentState!.validate()){
                    fileController.car.serviceList.add(Services(serviceName: _serviceName.text, time: '', mileage: _mileage.text,));
                    fileController.write();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
