import 'package:flutter/material.dart';

import 'package:current_location/utilities/dataObject/trips_info.dart';
import 'package:current_location/utilities/services/file_manager.dart';
import 'services.dart';

class Car with ChangeNotifier{

  String bluetoothAddress;
  String carName;
  int carYear;
  String carCompany;
  double currentMileage;
  List<TripsInfo> tripsInfo;
  List<Services> serviceList;


  Car({required this.bluetoothAddress,
      required this.carName,
      required this.carYear,
      required this.carCompany,
      required this.currentMileage,
      required this.tripsInfo,
      required this.serviceList});

  factory Car.fromJson(Map<String,dynamic> json) => Car(
    bluetoothAddress: json['bluetoothAddress'],
    carName: json['carName'] ,
    carYear: json['carYear'],
    carCompany: json['carCompany'],
    currentMileage: json['currentMileage'],
    tripsInfo: (json['tripsInfo'] as List<dynamic>)
        .map((e) => TripsInfo.fromJson(e as Map<String, dynamic>))
        .toList(),
    serviceList: (json['serviceList'] as List<dynamic>)
        .map((e) => Services.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String,dynamic> toJson() {
    return {
        'bluetoothAddress': bluetoothAddress,
        'carName':carName,
        'carYear':carYear,
        'carCompany': carCompany,
        'currentMileage': currentMileage,
        'tripsInfo': tripsInfo.map((e) => e.toJson()).toList(),
        'serviceList':serviceList.map((e) => e.toJson()).toList(),
      };
  }


  writeFile(Car car){
    FileManager().writeCarToFile(car);
    notifyListeners();
  }
}