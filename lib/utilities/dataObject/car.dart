import 'dart:developer';

import 'package:current_location/utilities/dataObject/trips_info.dart';
import 'services.dart';

class Car{

  final String bluetoothAddress;
  final String carName;
  final String carYear;
  final String carCompany;
  double currentMileage;
  final List<TripsInfo> tripsInfo;
  final List<Services> serviceList;


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

  Map<String,dynamic> toJson()=>
      {
        'bluetoothAddress': bluetoothAddress,
        'carName':carName,
        'carYear':carYear,
        'carCompany': carCompany,
        'currentMileage': currentMileage,
        'tripsInfo': tripsInfo.map((e) => e.toJson()).toList(),
        'serviceList':serviceList.map((e) => e.toJson()).toList(),
      };
}