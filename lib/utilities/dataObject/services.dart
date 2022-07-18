class Services{
  final String time;
  final String serviceName;
  final double periodicMileage;
  double realMileage;
  bool hasBeenDone;

  Services({required this.serviceName, required this.periodicMileage, this.hasBeenDone =false, this.time = '', this.realMileage = 0, });

  factory Services.fromJson( Map<String, dynamic> json){
    return Services(
      time: json['time'],
      serviceName: json['serviceName'],
      periodicMileage: json['periodicMileage'],
      hasBeenDone: json['hasBeenDone'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'time': time,
      'serviceName': serviceName,
      'periodicMileage': periodicMileage,
      'hasBeenDone': hasBeenDone,
    };
  }
}