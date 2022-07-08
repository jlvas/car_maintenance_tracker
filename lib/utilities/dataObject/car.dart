import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:current_location/utilities/dataObject/trips_info.dart';
//

//
@JsonSerializable(explicitToJson: true)
class Car{

  late String bluetoothAddress;
  late String carName;
  late String carYear;
  late String carCompany;
  late String carMileage;
  List<TripsInfo> tripsInfo =[];


  Car(
      {required this.bluetoothAddress,
      required this.carName,
      required this.carYear,
      required this.carCompany,
      required this.carMileage,
      required this.tripsInfo});



  factory Car.fromJson(Map<String,dynamic> json) => Car(
    bluetoothAddress: json['bluetoothAddress'],
    carName: json['carName'] ,
    carYear: json['carYear'],
    carCompany: json['carCompany'],
    carMileage: json['carMileage'],
    tripsInfo: (json['tripsInfo'] as List<dynamic>)
        .map((e) => TripsInfo.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String,dynamic> toJson()=>
      {
        'bluetoothAddress': bluetoothAddress,
        'carName':carName,
        'carYear':carYear,
        'carCompany': carCompany,
        'carMileage': carMileage,
        'tripsInfo': tripsInfo.map((e) => e.toJson()).toList(),
      };
}