import 'dart:convert';

import 'package:current_location/utilities/services/file_manager.dart';
import 'package:flutter/foundation.dart';

import '../dataObject/car.dart';

class FileController extends ChangeNotifier {

  static late Car _car;
  static String _text = 'data';

  FileController(){
    readCar();
  }
  Car get car => _car;
  String get text => _text;

  Future<String> readCar()async{
    _text = await FileManager().readFromFileCar();
    if(_text != 'data'){
      _car = Car.fromJson(jsonDecode(_text));
    }
    return'test';
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