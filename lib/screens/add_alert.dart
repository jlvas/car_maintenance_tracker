import 'package:current_location/utilities/services/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utilities/dataObject/car.dart';
import '../utilities/dataObject/services.dart';
import '../utilities/services/local_notifications.dart';
class AddAlert extends StatelessWidget {

  static const routeName = '/screens/add_alert';
//   const AddAlert({Key? key}) : super(key: key);
//
//   @override
//   State<AddAlert> createState() => _AddAlertState();
// }
//
// class _AddAlertState extends State<AddAlert> {

  final _key = GlobalKey<FormState>();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _serviceName = TextEditingController();
  final TextEditingController _mileage = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final car = Provider.of<Car>(context);

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
                keyboardType: TextInputType.number,
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
                    final services =  Services(
                      serviceName: _serviceName.text,
                      time: '',
                      periodicMileage: double.parse(_mileage.text),
                      realMileage: double.parse(_mileage.text) + car.currentMileage,
                    );
                    car.serviceList.add(services);
                    car.writeFile(car);
                    LocalNotifications.showNotification(
                      id: car.serviceList.length+1,
                      title: _serviceName.text,
                      body: 'Maintenance after: ${services.realMileage}',
                      payload: 'payload'
                    );
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
