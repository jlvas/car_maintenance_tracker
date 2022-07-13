import 'package:current_location/utilities/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

import '../utilities/file_manager.dart';
import 'bluetooth_devices_list.dart';
import 'location.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/screens/main_screen';
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FileManager().readFromFileCar(),
      builder: (ctx, dataSnap) {
        if(dataSnap.connectionState == ConnectionState.done){
          if(dataSnap.data.toString() == 'data'){
            log('MainScreenConnectionState.done \nData:${dataSnap.data}\nhas error:${dataSnap.hasError}\n${dataSnap.error}');
            return const BluetoothDevicesList();
          }else{
            log('MainScrenn.CarTracking()\nData:${dataSnap.data}\nhad data: dataSnap.hasData\nhas error:${dataSnap.hasError}\n${dataSnap.error}');
            Provider.of<FileController>(context, listen: false).readCar();
            return const CarTracking();
          }
        } else {
          log('MainScreen.CircularProgressIndicator()');
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
