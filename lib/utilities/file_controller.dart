import 'dart:convert';

import 'package:current_location/utilities/file_manager.dart';
import 'package:flutter/foundation.dart';

import 'dataObject/car.dart';

class FileController extends ChangeNotifier {

  late Car _car;
  String _text = 'data';

  Car get car => _car;

  readCar()async{
    _text = await FileManager().readFromFileCar();
    if(_text != 'data'){
      _car = Car.fromJson(jsonDecode(_text));
    }
  }
  writeCar(Car car) async {
    _car = car;
    await FileManager().writeCarToFile(car);
    notifyListeners();
  }

  write() async {
    await FileManager().writeCarToFile(_car);
    notifyListeners();
  }
}