import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utilities/car_info.dart';
import '../utilities/dataObject/car.dart';
import '../utilities/file_manager.dart';

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
  // late CarInfo carInfo;
  late Car car;

  @override
  Widget build(BuildContext context){
    log('TripList');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip List'),
      ),
      body: FutureBuilder<String>(
        future: _initialize(),
        builder: (context, snapShat){
          if(snapShat.hasData){
            log('TripList hasData');
            if(snapShat.data == 'data'){
              log('data == data');
              return const Text('has data');
            }else{
              log('_tripList()\n${snapShat.data}');
              return _tripList();
            }
          }
          else if(snapShat.connectionState == ConnectionState.waiting){
            return const Text('Waiting');
          }
          else if(snapShat.hasError){
            log('hasError: ${snapShat.data.toString()}\n${snapShat.hasError}\n${snapShat.error}');
            return Text('Error: ${snapShat.hasError}\n${snapShat.error}');
          }
          else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
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
    // setState(() {});
  }

  Widget _tripList(){
    log('toJson\n${car.toJson()}');
    return ListView.builder(
      itemCount:car.tripsInfo.length,
      itemBuilder: ((_, index){
        _addPolyLine(car.tripsInfo[index].trip);
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
                  child: Text('Trip Time: ${car.tripsInfo[index].time}'),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Total Distance: ${car.tripsInfo[index].totalDistance}'),
                ),
                Divider(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _googleMap(),
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
    // String content = await FileManager().readFromFile();
    String contentCar = await FileManager().readFromFileCar();
    log(contentCar.toString());
    if( contentCar == 'data'){
      log('_initialize: $contentCar');
      return contentCar;
    }else{
      // final Map<String, dynamic> valueMap = json.decode(content);

      // carInfo = CarInfo.fromJson(valueMap);
      car = Car.fromJson(json.decode(contentCar));

      // log('_initialize: $content');
      log('_initialize\n$contentCar');

      return contentCar;
    }
  }

  Widget _googleMap(){
    // carInfo.coordinates.forEach((element) {log('Coordinates: $element');});
    // _addPolyLine(carInfo.coordinates);
    _addPolyLine(car.tripsInfo[0].trip);
    _setEndMarker();
    _setStartMarker();
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

  void _setStartMarker() {
    startLocation = car.tripsInfo[0].trip[0];
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

  void _setEndMarker() {
    endLocation = car.tripsInfo[0].trip.last;
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

// Widget _tripList(){
//   log('toJson\n${carInfo.toJson()}');
//   return ListView.builder(
//     itemCount:carInfo.tripList.length,
//     itemBuilder: ((_, index){
//       _addPolyLine(carInfo.tripList[index]);
//       return SizedBox(
//         height: 400,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(
//               width: 10,
//               color: Colors.black26,
//             ),
//           ),
//           margin: const EdgeInsets.all(15.0),
//           padding: const EdgeInsets.only(top: 8.0),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text('Trip Time: $index'),
//               ),
//               Divider(),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text('Total Distance: ######'),
//               ),
//               Divider(),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: _googleMap(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }),
//   );
// }