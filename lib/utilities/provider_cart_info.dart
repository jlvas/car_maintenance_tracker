import 'package:flutter/material.dart';

import 'car_info.dart';

class ProviderCarInfo with ChangeNotifier{
  late CarInfo _carInfo;

  CarInfo get carInfo => _carInfo;

  void setCarInfoDevice(){

  }
}