import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class GoogleMaps extends StatefulWidget {

  static const routeName='/screens/google_maps';

  const GoogleMaps({Key? key}) : super(key: key);

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {

  GoogleMapController? _googleMapController;
  Set<Marker> markers = Set();

  LatLng showLocation = const LatLng(27.7089427, 85.3086209);
  LatLng startLocation = const LatLng(27.6683619, 85.3101895);
  LatLng endLocation = const LatLng(27.6688312, 85.3077329);
  Map<PolylineId, Polyline> polylines = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
        ),
      body: Column(
        children: [
          GoogleMap( //Map widget from google_maps_flutter package
            zoomGesturesEnabled: true, //enable Zoom in, out on map
            initialCameraPosition: CameraPosition( //innital position in map
              target: showLocation, //initial position
              zoom: 10.0, //initial zoom level
            ),
            markers: markers, //markers to show on map
            mapType: MapType.normal, //map type
            onMapCreated: (controller) { //method called when map is created
              setState(() {
                _googleMapController = controller;
              });
            },
          ),
          const Divider(height: 20,),
          // Row(
          //   children: [
          //     ElevatedButton(onPressed: _setMarkers, child: const Text('Set Markers')),
          //
          //   ],
          // )
        ],
      ),
    );
  }
}
