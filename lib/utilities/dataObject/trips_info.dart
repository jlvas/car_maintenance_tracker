import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripsInfo{

  final List<LatLng> trip;
  final String time;
  final String totalDistance;
  TripsInfo({required this.trip, required this.time, required this.totalDistance});

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

