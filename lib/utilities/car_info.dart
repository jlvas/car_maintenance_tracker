import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CarInfo with ChangeNotifier{

  late String bluetoothAddress;
  String? carName;
  String? carYear;
  String? carCompany;
  String? carMileage;
  List<LatLng> coordinates = [];
  List<List<LatLng>> tripList = [];

  CarInfo(
      {required this.bluetoothAddress,
      this.carName,
      this.carYear,
      this.carCompany,
      this.carMileage});


  Future<bool> isBluetoothConnected()async{
    return (
        await FlutterBluetoothSerial
        .instance.getBondedDevices()
    ).where((element) => element.address == bluetoothAddress).single.isConnected;
  }

  Map<String, dynamic> toJson() {

    return {
      'bluetoothAddress': bluetoothAddress,
      'carName': carName,
      'carYear': carYear,
      'carCompany': carCompany,
      'carMileage': carMileage,
      'coordinates': coordinates.isEmpty ? []: jsonEncode(coordinates)
    };
  }

  CarInfo.fromJson(Map<String, dynamic> json) {
    bluetoothAddress = json['bluetoothAddress'];
    carName = json['carName'];
    carYear = json['carYear'];
    carCompany = json['carCompany'];
    carMileage = json['carMileage'];
    ///List retreived as dynamic list, needed to be covert to List<LatLng>
    if(json['coordinates'].toString() == '[]') {
      coordinates = [];
    }
    else
    {
      List<dynamic> coord = jsonDecode(json['coordinates']);
      coord.forEach((e) {
        /// convert e to string then take of '[' and ']' and then split using ',' and return List<String>
        List<String> list = e.toString()
            .replaceAll(RegExp('[^0-9.,]'), '')
            .split(',');

        /// convert List<String> into latLng and add it to coordinates
        coordinates.add(LatLng(double.parse(list[0]), double.parse(list[1])));
      });
    };
    for(int i = 0; i<5; i++){
      tripList.add(coordinates);
    }
  }
}
