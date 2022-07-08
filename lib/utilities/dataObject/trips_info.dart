import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';


// @JsonSerializable(explicitToJson: true)
class TripsInfo{

  final List<LatLng> trip;
  final String time;
  final String totalDistance;
  TripsInfo({required this.trip, required this.time, required this.totalDistance});

  // factory TripsInfo.fromJson(Map<String,dynamic> data)=>_$TripsInfoFromJson(data);

  // Map<String,dynamic> toJson()=>_$TripsInfoToJson(this);

  factory TripsInfo.fromJson(Map<String,dynamic> json) => TripsInfo(
      trip: ((json['trip'] as List<dynamic>).map((e) => LatLng.fromJson(e) as LatLng).toList())as List<LatLng> ,
      time: json['time'],
      totalDistance: json['totalDistance'],
  );

  Map<String,dynamic> toJson()=>{
    'trip':trip.map((e) => e.toJson()).toList(),
    'time': time,
    'totalDistance': totalDistance,
  };
}
  // Map<String, dynamic> toJson() {
  //   log('TripsInfo.toJson');
  //   return {
  //     'totalDistance': totalDistance,
  //     'time': time,
  //     // 'trip': trip.isEmpty ? [] : jsonEncode(trip),
  //     'trip': !trip.isEmpty? trip.map((e) => e.toJson()).toList():[]
  //   };
  // }
  //
  // TripsInfo.fromJson(Map<String, dynamic> json){
  //   time = json['time'];
  //   totalDistance = json['totalDistance'];
  //   List<dynamic> list = json['trip'];
  //   for (var e in list) {
  //     trip.add(LatLng.fromJson(e)!);
  //   }
  // }
