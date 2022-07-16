import 'dart:convert';
import 'dart:developer';

import 'package:current_location/screens/car_history.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../utilities/dataObject/trips_info.dart';
import '../utilities/file_controller.dart';
import '../utilities/file_manager.dart';
import 'add_alert.dart';

class TripList extends StatefulWidget {
  static const routeName = '/screens/trip_list';
  const TripList({Key? key}) : super(key: key);

  @override
  State<TripList> createState() => _TripListState();
}

class _TripListState extends State<TripList> {

  GoogleMapController? _googleMapController;
  Set<Marker> markers = Set();

  LatLng showLocation = const LatLng(26.4568748, 50.0542238);
  LatLng startLocation = const LatLng(26.4568748, 50.0542238);
  LatLng endLocation = const LatLng(26.4568894, 50.0541741);
  Map<PolylineId, Polyline> polylines = {};
  // late Car car;
  late FileController fileController;

  @override
  Widget build(BuildContext context){
    fileController = Provider.of<FileController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip List'),
        actions: [
          PopupMenuButton<int>(
            onSelected: (item)=> _onSelectedMenu(context, item),
            itemBuilder: (context){
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text('Edit Car Info'),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text('Add Alert'),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: Text('Alert List'),
                )
              ];
            },
          )
        ],
      ),
      body: _tripList(),
    );
  }

  void _onSelectedMenu(BuildContext context, int item){
    switch(item) {
      case 0:
        print('pressed on value 0');
        break;
      case 1:
        Navigator.pushNamed(context, AddAlert.routeName);
        break;
      case 2:
        Navigator.pushNamed(context, CarHistory.routeName);
        break;
    }
  }
  FutureBuilder<String> buildFutureBuilder() {
    return FutureBuilder<String>(
      future: _initialize(),
      builder: (context, snapShat){
        if(snapShat.hasData){
          if(snapShat.data == 'data'){
            return const Text('has data');
          }else{
            return _tripList();
          }
        }
        else if(snapShat.connectionState == ConnectionState.waiting){
          return const Text('Waiting');
        }
        else if(snapShat.hasError){
          return Text('Error: ${snapShat.hasError}\n${snapShat.error}');
        }
        else{
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
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
  }

  Widget _tripList(){

    return ListView.builder(
      itemCount:fileController.car.tripsInfo.length,
      itemBuilder: ((_, index){
        _addPolyLine(fileController.car.tripsInfo[index].trip);
        return SizedBox(
          height: 400,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 10,
                color: Colors.black26,
              ),
            ),
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Trip Time: ${fileController.car.tripsInfo[index].time}'),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Total Distance: ${fileController.car.tripsInfo[index].totalDistance} km'),
                ),
                Divider(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _googleMap(fileController.car.tripsInfo[index].trip),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<String> _initialize() async{
    log('_initialize()');
    String contentCar = await FileManager().readFromFileCar();
    log(contentCar.toString());
    if( contentCar == 'data'){
      log('_initialize: $contentCar');
      return contentCar;
    }else{

      // car = Car.fromJson(json.decode(contentCar));

      log('_initialize\n$contentCar');

      return contentCar;
    }
  }

  Widget _googleMap(List<LatLng> trip){
    _addPolyLine(trip);
    _setEndMarker(trip);
    _setStartMarker(trip);
      return GoogleMap(
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: showLocation, //initial position
          zoom: 15.0,
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
      );
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

  void _setStartMarker(List<LatLng> list) {
    startLocation = list.first;
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
  }

  void _setEndMarker(List<LatLng> trip) {
    endLocation = trip.last;
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
  }
}