class LocationInfo {
  final String longitude;
  final String latitude;
  LocationInfo({required this.latitude, required this.longitude});

  Map<String, dynamic> toJson(){
    return{
      'longitude':longitude,
      'latitude': latitude,
    };
  }
}