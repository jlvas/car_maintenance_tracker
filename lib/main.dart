import 'dart:convert';

import 'package:current_location/utilities/dataObject/car.dart';

import 'screens/bluetooth_devices_list.dart';
import 'screens/edit_car_info.dart';
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

  MaterialApp mainWidget(Widget screen){
    return   MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: screen,
      routes: {
        BluetoothDevicesList.routeName: (ctx) => const BluetoothDevicesList(),
        EditCarInfo.routeName: (ctx) =>  EditCarInfo(),
        CarTracking.routeName: (ctx) =>  CarTracking(),
        TripList.routeName:(ctx) => TripList(),
        AddAlert.routeName: (ctx) => AddAlert(),
        CarHistory.routeName: (ctx) =>  CarHistory(),
      },
    );
  }
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: FileController().readFile(),
      builder: (context, snapshot) {
        if(snapshot.data == 'data'){
          return mainWidget(BluetoothDevicesList());
        }else if(snapshot.connectionState == ConnectionState.done){
          return ChangeNotifierProvider<Car>(
              create: (_)=> Car.fromJson(json.decode(snapshot.data!)),
            child: MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home:  Center(child: CarTracking()),
              routes: {
                BluetoothDevicesList.routeName: (ctx) => const BluetoothDevicesList(),
                EditCarInfo.routeName: (ctx) =>  EditCarInfo(),
                CarTracking.routeName: (ctx) =>  CarTracking(),
                TripList.routeName:(ctx) =>  TripList(),
                AddAlert.routeName: (ctx) =>  AddAlert(),
                CarHistory.routeName: (ctx) => CarHistory(),
              },
            ),
          );
        }
        else{
          return mainWidget(Center(child:CircularProgressIndicator()));
        }

      }
    );
  }
}
// MaterialApp(
// title: 'Flutter Demo',
// theme: ThemeData(
// primarySwatch: Colors.blue,
// ),
// home: const MainScreen(),
// routes: {
// BluetoothDevicesList.routeName: (ctx) => const BluetoothDevicesList(),
// EditCarInfo.routeName: (ctx) => const EditCarInfo(),
// CarTracking.routeName: (ctx) => const CarTracking(),
// MainScreen.routeName:(ctx) => const MainScreen(),
// TripList.routeName:(ctx) => const TripList(),
// AddAlert.routeName: (ctx) => const AddAlert(),
// CarHistory.routeName: (ctx) => const CarHistory(),
// TestingScreen.routeName: (ctx) =>const TestingScreen(),
// TestingScreen2.routeName: (ctx) =>const TestingScreen2(),
// },
// );