import 'dart:convert';

import 'package:current_location/main.dart';
import 'package:flutter/material.dart';
import '../utilities/dataObject/car.dart';
import '../utilities/services/file_controller.dart';

class EditCarInfo extends StatelessWidget {
  static const routeName = '/screens/edit_car_info';
//   const EditCarInfo({Key? key}) : super(key: key);
//
//   @override
//   _EditCarInfoState createState() => _EditCarInfoState();
// }
//
// class _EditCarInfoState extends State<EditCarInfo> {

  final _key = GlobalKey<FormState>();
  final TextEditingController _carName = TextEditingController();
  final TextEditingController _carCompany = TextEditingController();
  final TextEditingController _carYear = TextEditingController();
  final TextEditingController _carMileage = TextEditingController();

  Future<void> _submitCarInfo(String bluetoothAddress, BuildContext context) async{

    final car = Car(
      bluetoothAddress: bluetoothAddress,
      carCompany: _carCompany.text,
      currentMileage: double.parse(_carMileage.text),
      // currentMileage: double.parse(_carName.text),
      carName: _carName.text,
      carYear: int.parse(_carYear.text),
      tripsInfo: [],
      serviceList: [],
    );
    FileController().writeFile(car);// using change notifier provider
    // await FileManager().writeCarToFile(car);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => MyApp(),
      ),
          (route) => false,
    );
  }


  @override
  Widget build(BuildContext context) {

    final bluetoothAddress = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar:AppBar(
        title: const Text('Edit Car Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _carCompany,
                decoration: const InputDecoration(
                  label: Text('Company Name')
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _carName,
                decoration: const InputDecoration(
                  label: Text('Car Name')
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _carYear,
                decoration: const InputDecoration(
                  label: Text('Year Of Made')
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _carMileage,
                decoration: const InputDecoration(
                  label: Text('Car Mileage'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: ()=> _submitCarInfo(bluetoothAddress, context),
                child: const Text('Submit')
              ),
            ],
          ),
        ),
      ),
    );
  }
}
