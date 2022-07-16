class Services{
  final String time;
  final String serviceName;
  final String mileage;
  bool hasBeenDone;
  Services({required this.serviceName, required this.mileage, this.hasBeenDone =false, this.time = '', });

  factory Services.fromJson( Map<String, dynamic> json){
    return Services(
      time: json['time'],
      serviceName: json['serviceName'],
      mileage: json['mileage'],
      hasBeenDone: json['hasBeenDone'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'time': time,
      'serviceName': serviceName,
      'mileage': mileage,
      'hasBeenDone': hasBeenDone,
    };
  }
}