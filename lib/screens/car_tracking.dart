import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:developer' as developer;

import 'package:current_location/utilities/dataObject/trips_info.dart';
import 'package:current_location/utilities/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../utilities/file_manager.dart';
import '../utilities/display_message.dart';
import 'trip_list.dart';

class CarTracking extends StatefulWidget {
  static const routeName = '/screens/car_tracking';

  const CarTracking({Key? key}) : super(key: key);

  @override
  State<CarTracking> createState() => _CarTrackingState();
}

class _CarTrackingState extends State<CarTracking> {
  String? longitude;
  String? latitude;
  List<LatLng> _coordinates = [];
  List<BluetoothDevice> deviceList = [];
  GoogleMapController? _googleMapController;
  Set<Marker> markers = Set();

  LatLng showLocation = const LatLng(26.4568748, 50.0542238);
  LatLng startLocation = const LatLng(26.4568748, 50.0542238);
  LatLng endLocation = const LatLng(26.4568894, 50.0541741);
  Map<PolylineId, Polyline> polylines = {};

  late FileController fileController;

  @override
  void initState() {
    Location().enableBackgroundMode(enable: true);
    _gpsStreamRecorder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fileController = Provider.of<FileController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Location'),
      ),
      body: _interfaceWidget(),
    );
  }

  ///_gpsStreamRecorder: a function get gps coordinates when device is connected with chosen specific bluetooth.
  ///Contains: two streams; one to listen for bluetooth connection and second one is to write down the GPS coordinates.
  ///Data is stored on CarInfo and then will be written on json file.
  void _gpsStreamRecorder() {

    StreamSubscription? streamLocation;
    BluetoothDevice? bDevice;
    bool isConnected = false;
    ///TripInfo properties
    List<LatLng> trip = [];
    String time = DateTime.now().toString();
    String totalDistance;

    /// check if the connection to bluetooth device each second
    /// if there is a connection then keep recording the coordinates
    /// else navigate to trip_list
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      FlutterBluetoothSerial.instance.getBondedDevices().then((value) {
        return bDevice = value.where((element) {
          return element.address == fileController.car.bluetoothAddress;
        }).first;
      });
      if (!bDevice!.isConnected) {
        isConnected = false;
        streamLocation?.cancel();
        timer.cancel();
        totalDistance = _getDistance(trip).toString();
        if(trip.isNotEmpty){
          fileController.car.tripsInfo.add(TripsInfo(trip: trip, time: time, totalDistance: totalDistance));
          fileController.write();
          Navigator.pushNamedAndRemoveUntil(context, TripList.routeName, (route) => false);
        }else{
          Navigator.pushNamedAndRemoveUntil(context, TripList.routeName, (route) => false);
        }
      }else{
        isConnected = true;
      }
    });

    streamLocation = Location().onLocationChanged.listen((lnglat) {
      LatLng coordinate =
      LatLng(lnglat.latitude!.toDouble(), lnglat.longitude!.toDouble());
      if(isConnected) trip.add(coordinate);
      developer.log('\ncoordinates added: $coordinate');
    });
  }


  /// _getCurrentLocation: will provide the current location for the device.
  /// Contains: Location object that retrieve the current location.
  Future<LocationData> _getCurrentLocation() async {
    LocationData currentLocation = await Location().getLocation();
    return currentLocation;
  }

  double _getDistance(List<LatLng> coordinates) {
    double distance = 0;
    int length = coordinates.length;
    for (int i = 0; i < length; i++) {
      print('distance $length');
      if (i + 1 == length) {
        break;
      }
      distance += _calculateDistance(
          coordinates[i].latitude,
          coordinates[i].longitude,
          coordinates[i + 1].latitude,
          coordinates[i + 1].longitude);
    }
    return distance;
  }

  double _calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Widget _interfaceWidget() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Divider(
              height: 20,
            ),
            //google maps
            SizedBox(
              height: 500,
              child: GoogleMap(
                zoomGesturesEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: showLocation, //initial position
                  zoom: 10.0,
                ),
                markers: markers,
                //markers to show on map
                mapType: MapType.normal,
                //map type
                polylines: Set<Polyline>.of(polylines.values),
                onMapCreated: (controller) {
                  setState(() {
                    _googleMapController = controller;
                  });
                },
              ),
            ),
            const Divider(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
