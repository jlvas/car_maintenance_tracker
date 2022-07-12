import 'package:current_location/screens/bluetooth_devices_list.dart';
import 'package:current_location/screens/edit_car_info.dart';
import 'package:current_location/screens/main_screen.dart';
import 'package:current_location/screens/trip_list.dart';
import 'package:current_location/utilities/file_controller.dart';
import 'package:current_location/utilities/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/bluetooth_devices_list.dart';
import 'screens/location.dart';

import 'dart:developer';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>FileController(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainScreen(),
        routes: {
          BluetoothDevicesList.routeName: (ctx) => BluetoothDevicesList(),
          EditCarInfo.routeName: (ctx) => EditCarInfo(),
          CarTracking.routeName: (ctx) => CarTracking(),
          MainScreen.routeName:(ctx) => MainScreen(),
          TripList.routeName:(ctx) => TripList(),
        },
      ),
    );
  }
}
