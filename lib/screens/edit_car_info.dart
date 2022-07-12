import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utilities/dataObject/car.dart';
import '../utilities/file_controller.dart';
import '../utilities/file_manager.dart';
import 'main_screen.dart';



class EditCarInfo extends StatefulWidget {
  static const routeName = '/screens/edit_car_info';
  const EditCarInfo({Key? key}) : super(key: key);

  @override
  _EditCarInfoState createState() => _EditCarInfoState();
}

class _EditCarInfoState extends State<EditCarInfo> {

  final _key = GlobalKey<FormState>();
  late String _bluetoothAddress;
  final TextEditingController _carName = TextEditingController();
  final TextEditingController _carCompany = TextEditingController();
  final TextEditingController _carYear = TextEditingController();
  final TextEditingController _carMileage = TextEditingController();

  late FileController fileController;

  Future<void> _submitCarInfo() async{

    final car = Car(
      bluetoothAddress: _bluetoothAddress,
      carCompany: _carCompany.text,
      carMileage: _carName.text,
      carName: _carName.text,
      carYear: _carYear.text, tripsInfo: [],
    );
    fileController.writeCar(car);// using change notifier provider
    await FileManager().writeCarToFile(car);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => MainScreen(),
      ),
          (route) => false,
    );
  }


  @override
  Widget build(BuildContext context) {

    _bluetoothAddress = ModalRoute.of(context)!.settings.arguments as String;
    fileController = Provider.of<FileController>(context);

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
                controller: _carYear,
                decoration: const InputDecoration(
                  label: Text('Year Of Made')
                ),
              ),
              TextFormField(
                controller: _carMileage,
                decoration: const InputDecoration(
                  label: Text('Car Mileage'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _submitCarInfo,
                child: const Text('Submit')
              ),
            ],
          ),
        ),
      ),
    );
  }
}
