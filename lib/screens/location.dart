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

  // @override
  // void initState() {
  //   Location().enableBackgroundMode(enable: true);
  // }

  @override
  Widget build(BuildContext context) {
    fileController = Provider.of<FileController>(context,listen: false);
    _getGPSstreamLocation();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Location'),
      ),
      body: _interfaceWidget(),
    );
  }

   ///_gerGPSstream: a function get gps coordinates when device is connected with chosen specific bluetooth.
  ///Contains: two streams; one to listen for bluetooth connection and second one is to write down the GPS coordinates.
  ///Data is stored on CarInfo and then will be written on json file.
  void _getGPSstreamLocation() {

    developer.log('CarTracking._getGPSstreamLocation()');

    StreamSubscription? streamLocation;
    BluetoothDevice? bDevice;

    ///TripInfo properties
    List<LatLng> trip= [];
    String time = DateTime.now().toString();
    String totalDistance;

    streamLocation = Location().onLocationChanged.listen((lnglat) {
      LatLng coordinate = LatLng(lnglat.latitude!.toDouble(), lnglat.longitude!.toDouble());
      // carInfo.coordinates.add(coordinate);
      trip.add(coordinate);
      developer.log('\ncoordinates added: $coordinate');
    });

    Timer.periodic(const Duration(seconds: 1), (timer) async {
      FlutterBluetoothSerial.instance.getBondedDevices().then((value){
            return bDevice = value.where((element){
              return element.address == fileController.car.bluetoothAddress;
            }).first;
          });
      if(!bDevice!.isConnected){
        streamLocation?.cancel();
        timer.cancel();
        totalDistance = _getDistance(trip).toString();
        fileController.car.tripsInfo.add(TripsInfo(trip: trip, time: time, totalDistance: totalDistance));
        fileController.write();
        developer.log('Details:\n${jsonEncode(fileController.car.toJson())}');
        // FileManager().writeCarToFile(car);
        // Navigator.pushNamedAndRemoveUntil(context, TripList.routeName, (route) => false);
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const TripList(),
        //   ),
        //       (route) => false,
        // );
      }
    });
  }

  /// _getCurrentLocation: will provide the current location for the device.
  /// Contains: Location object that retrieve the current location.
  Future<LocationData> _getCurrentLocation() async {
    LocationData currentLocation = await Location().getLocation();
    return currentLocation;
  }


  void _setMarkersCurrentLocation(LatLng currentLocation) {
    setState(() {
      markers.add(Marker(
        markerId: MarkerId(currentLocation.toString()),
        position: currentLocation,
        infoWindow: const InfoWindow(
          title: 'Title',
          snippet: 'Title marker',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _setStartMarker() {
    setState(() {
      startLocation = _coordinates.first;
      markers.add(Marker(
        markerId: MarkerId(startLocation.toString()),
        position: startLocation, //position of marker
        infoWindow: const InfoWindow(
          //popup info
          title: 'Starting Point ',
          snippet: 'Start Marker',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
    });
  }

  void _setEndMarker() {
    endLocation = _coordinates.last;
    setState(() {
      markers.add(Marker(
        //add distination location marker
        markerId: MarkerId(endLocation.toString()),
        position: endLocation, //position of marker
        infoWindow: const InfoWindow(
          //popup info
          title: 'Destination Point ',
          snippet: 'Destination Marker',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
    });
  }

  void _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  double _getDistance(List<LatLng> coordinates){
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
            Row(
              children: [
                ElevatedButton(
                  child: const Text('w'),
                  onPressed: ()async{
                   String s =await  FileManager().readFromFileCar();
                   developer.log(s);
                  },
                ),
                ElevatedButton(
                  child: const Text('r'),
                  onPressed: ()async{
                    await fileController.writeCar(fileController.car);
                  },
                ),
                //Stream
                ElevatedButton(
                  child: const Text('Stream'),
                  onPressed: _getGPSstreamLocation,
                ),
                //draw polylines
                ElevatedButton(
                  onPressed: () {
                    _addPolyLine(_coordinates);
                  },
                  child: const Text('Polylines'),
                ),
                //Calculate Distance
                ElevatedButton(
                  onPressed: () {
                    double distance = 0;
                    int length = _coordinates.length;
                    for (int i = 0; i < length; i++) {
                      print('distance $length');
                      if (i + 1 == length) {
                        break;
                      }
                      distance += _calculateDistance(
                          _coordinates[i].latitude,
                          _coordinates[i].longitude,
                          _coordinates[i + 1].latitude,
                          _coordinates[i + 1].longitude);
                    }
                    DisplayMessage()
                        .showMessage(null, context, 'Distance = $distance km');
                  },
                  child: const Icon(Icons.calculate_outlined),
                ),
              ],
            ),
            const Divider(
              height: 15,
            ),
            Row(
              children: [
                //get current location
                ElevatedButton(
                  onPressed: () async {
                    LocationData l = await _getCurrentLocation();
                    showLocation =
                        LatLng(l.latitude!.toDouble(), l.longitude!.toDouble());
                    // CameraPosition cameraPosition = CameraPosition(target: showLocation, zoom: 40);
                    CameraUpdate cameraUpdate =
                        CameraUpdate.newLatLng(showLocation);
                    developer.log('current location ${showLocation.toString()}');
                    _googleMapController!.animateCamera(cameraUpdate);
                  },
                  child: const Icon(Icons.my_location),
                ),
                //Set Start Marker
                ElevatedButton(
                    onPressed: _setStartMarker,
                    child: Row(children: const [
                      Text('Start '),
                      Icon(Icons.location_on_outlined)
                    ])),
                ElevatedButton(
                    onPressed: _setEndMarker,
                    child: Row(children: const [
                      Text('End'),
                      Icon(Icons.location_on_outlined)
                    ])),
                ElevatedButton(
                  onPressed: () {
                    FileManager().readFromFile();
                  },
                  child: const Text(
                    'RD',
                  ),
                ),
                //add marker to current location
                ElevatedButton(
                  onPressed: () => _setMarkersCurrentLocation(showLocation),
                  child: const Text('MarkCurrent'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Future<String> _getCarInfo() async {
//   String contentCar = await FileManager().readFromFileCar();
//   developer.log('CarTraking._getCarInfo()\n$contentCar');
//   return contentCar;
// }
