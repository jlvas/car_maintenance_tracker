import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:developer';

import 'car_info.dart';
import 'dataObject/car.dart';
import 'location_info.dart';

class FileManager {
  static final FileManager _fileManager = FileManager._internal();

  factory FileManager() {
    return _fileManager;
  }

  FileManager._internal();

  Future<String> get directoryPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _file async{
    final path = await directoryPath;
    return File('$path/carInfoStorage.txt');
  }
  Future<File> get _fileCar async{
    final path = await directoryPath;
    return File('$path/tripCar.txt');
  }

  // Future<void> writeToFileLocationInfo (LocationInfo locationInfo) async{
  //   try{
  //     final file = await _file;
  //     await file.writeAsString(
  //       json.encode(locationInfo.toJson())+'\n',
  //       mode: FileMode.append,
  //       encoding: utf8,
  //       flush: false,
  //     );
  //   }
  //   catch (e){
  //     print('Error $e');
  //     throw e;
  //   }
  // }

  Future<String> readFromFile() async {
    File file = await _file;
    String contents = 'data';
    // log('\nFileManager\nreadFromFile()\n $contents');
    if(await file.exists()){
      log('File Exist: ${await file.exists()}');
      try{
        contents = await file.readAsString();
        // log('Inside Try: \n$contents');
        final Map<String, dynamic> valueMap = json.decode(contents);
      }
      catch(e){
        throw e;
      }
    }else{
      log('\nFileManager\n readFromFileCarInfo()\n Error file does not exist');
    }
    return contents;
  }

  Future<String> readFromFileCar() async {
    String contents = 'data';
    File file = await _fileCar;
    if(await file.exists()){
      log('File Exist: ${await file.exists()}');
      try{
        contents = await file.readAsString();
        log('contents: $contents');
      }
      catch(e){
        throw e;
      }
    }else{
      log('FileManager.readFromFileCarInfo.Error file does not exist');
    }
    return contents;
  }

  Future<void> writeToFile (CarInfo carInfo) async{
    try{
      carInfo.coordinates.map((e) => print('writeToFile: $e'));
      final file = await _file;
      // log('\nFileManager\n writeToFileCarInfo()\n ${json.encode(carInfo.toJson())}');
      await file.writeAsString(
        json.encode(carInfo.toJson())+'\n',
        mode: FileMode.write,
        encoding: utf8,
        flush: true,
      );
    }
    catch (e){
      log('FileManager.writeToFile (CarInfo carInfo)\n $e');
      throw e;
    }
  }

  Future<void> writeCarToFile (Car car) async{
    try{
      final file = await _fileCar;
      log('FileManager.writeToFileCarInfo\n ${json.encode(car.toJson())}');
      await file.writeAsString(json.encode(car.toJson()));
      // await file.writeAsString(
      //   json.encode(car.toJson()),
      //   mode: FileMode.write,
      //   encoding: utf8,
      //   flush: false,
      // );
    }
    catch (e){
      log('FileManager.writeToFileCarInfo.error\n $e');
      throw e;
    }
  }

  Future<bool> fileExist() async{
    File file = await _file;
    return await file.exists();
  }
}