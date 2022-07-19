import 'dart:convert';
import 'package:current_location/utilities/services/file_manager.dart';
import '../dataObject/car.dart';

class FileController{


  Future<String> readFile()async{
    final text;
    text = await FileManager().readFromFileCar();
    return text;
  }
  Future<String> writeFile(Car car) async {
    await FileManager().writeCarToFile(car);
    return json.encode(car.toString());

  }

  Future<String> writFileNotifier(Car car) async {
    await FileManager().writeCarToFile(car);
    return  json.encode(car.toJson());
  }
}