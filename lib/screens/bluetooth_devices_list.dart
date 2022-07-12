import 'dart:async';
import 'package:current_location/screens/edit_car_info.dart';
import 'package:current_location/utilities/display_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'dart:developer';

class BluetoothDevicesList extends StatefulWidget {
  static const routeName = '/screens/bluetooth_devices_list';
  const BluetoothDevicesList({Key? key}) : super(key: key);
  @override
  State<BluetoothDevicesList> createState() => _BluetoothDevicesListState();
}

class _BluetoothDevicesListState extends State<BluetoothDevicesList> {
  Timer? timer;
  StreamSubscription? _subscription;
  List<BluetoothDevice> deviceList = [];

  ///To list the bluetooth devices
  ///within the deviceList
  void showDeviceList() async {
    deviceList = await FlutterBluetoothSerial.instance.getBondedDevices();
    setState(() {});
  }

  ///Start checking the connection of bluetooth devices bonded to your phone
  ///It checks every one second
  @override
  void initState() {
    log('BluetoothDeviceList initState()');
    super.initState();
    timer = Timer.periodic(
        const Duration(seconds: 1), (Timer t) => showDeviceList());
  }

  /// Stop the timer which is checking the bluetooth devices connection
  /// preventing phone from craching
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    log('BluetoothDeviceList build()');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //Device List
              deviceList.isEmpty
                  ? const Text(
                      'Device List is Empty',
                      textAlign: TextAlign.center,
                    )
                  : SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: deviceList.length,
                        itemBuilder: ((_, index) {
                          return ListTile(
                            title: Text(deviceList[index].name.toString()),
                            trailing: deviceList[index].isConnected
                                ? const Icon(
                                    Icons.bluetooth_connected,
                                    color: Colors.greenAccent,
                                  )
                                : const Icon(Icons.bluetooth_disabled_rounded),
                            onTap: () async {
                              if (deviceList[index].isConnected) {
                                timer?.cancel();
                                await Navigator.pushNamed(
                                  context,
                                  EditCarInfo.routeName,
                                  arguments: deviceList[index].address,
                                );
                              } else {
                                DisplayMessage().showMessage(
                                    'Pair the device first',
                                    context,
                                    'Connection issue');
                              }
                            },
                          );
                        }),
                      ),
                    ),
              const Divider(height: 15),
              //get bonded devices
            ],
          ),
        ),
      ),
    );
  }
}

// ElevatedButton(
//   onPressed: () {
//     Navigator.pushNamed(
//       context,
//       EditCarInfo.routeName,
//       arguments: deviceList[0].address,
//     );
//   },
//   child: const Text('on State Changed'),
// ),

//change name
// ElevatedButton(
//   onPressed: () async{
//     print(
//         'Name change: ${await FlutterBluetoothSerial.instance.changeName('New name')}'
//     );
//   },
//   child: const Text('change name'),
// ),
//on state changed

// print('pressed');
// print('${deviceList[index]}');
// print(
//     'Name change: ${await FlutterBluetoothSerial.instance.changeName('New name')}'
// );// name of the user device
// print('Bluetooth device type: ${deviceList[index].type.stringValue}');
// print('Bluetooth device name: ${deviceList[index].name}');
// print('Bluetooth device address: ${deviceList[index].address}');
// print('Bluetooth device bond state: ${deviceList[index].bondState.stringValue}');
// print('Bluetooth device is Bonded: ${deviceList[index].isBonded}');
// print('Bluetooth device is connected: ${deviceList[index].isConnected}');
// BluetoothConnection bluetoothConnect =  await BluetoothConnection.toAddress(deviceList[index].address);
// print('Bluetooth device connection${bluetoothConnect.isConnected}');
// print('Bluetooth device ${await FlutterBluetoothSerial.instance.name}');
