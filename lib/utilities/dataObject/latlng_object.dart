import 'package:google_maps_flutter/google_maps_flutter.dart';

class LatlngObject {
  final List<LatLng> coordinates;

  LatlngObject({required this.coordinates});

  factory LatlngObject.fromJson(Map<String,dynamic> json)=> LatlngObject(
      coordinates: json['coordinates']
  );

}