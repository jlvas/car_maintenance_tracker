import 'screens/bluetooth_devices_list.dart';
import 'screens/edit_car_info.dart';
import 'screens/main_screen.dart';
import 'screens/trip_list.dart';
import 'screens/add_alert.dart';
import 'screens/alert_list.dart';
import 'screens/car_tracking.dart';
import 'utilities/services/file_controller.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
          BluetoothDevicesList.routeName: (ctx) => const BluetoothDevicesList(),
          EditCarInfo.routeName: (ctx) => const EditCarInfo(),
          CarTracking.routeName: (ctx) => const CarTracking(),
          MainScreen.routeName:(ctx) => const MainScreen(),
          TripList.routeName:(ctx) => const TripList(),
          AddAlert.routeName: (ctx) => const AddAlert(),
          CarHistory.routeName: (ctx) => const CarHistory(),
        },
      ),
    );
  }
}
