import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({Key? key}) : super(key: key);

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  String latitudeData = '';
  String longitudeData = '';

  getCurrentLocation() async {
    Position geolocator = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      latitudeData = geolocator.latitude.toString();
      longitudeData = geolocator.longitude.toString();
    });
  }

  void permissionLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      Geolocator.requestPermission();
    } else if (permission == LocationPermission.values) {
      print(permission);
    }
  }

  void _streamPosition() {
    LocationSettings locationOptions = new LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
    );
    Stream<Position> position = Geolocator.getPositionStream();
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationOptions).listen(
            (poistion) {
      print(poistion.latitude);
      print(poistion.longitude);
      setState(
        () {
          longitudeData = poistion.latitude.toString();
          latitudeData = poistion.longitude.toString();
          print(poistion.latitude);
          print(poistion.longitude);
        },
      );
    }, onDone: () {
      print('on Done');
    }, onError: (err) {
      print('Error: $err');
    });
  }

  @override
  void initState() {
    permissionLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Location'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(longitudeData),
          Text(latitudeData),
          ElevatedButton(
            onPressed: () async {
              bool isLocation = await Geolocator.isLocationServiceEnabled();
              if (isLocation) {
                print('working');
              }
            },
            child: const Text('isLocationServiceEnabled'),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              LocationPermission permission =
                  await Geolocator.checkPermission();
              print(permission);
            },
            child: const Text('checkPermission'),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: getCurrentLocation,
            child: const Text('getCurrentPosition'),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              LocationPermission permission =
                  await Geolocator.requestPermission();
              print(permission);
            },
            child: const Text('requestPermission'),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: _streamPosition,
            child: const Text('getPositionStream('),
          ),
          Divider(
            height: 15,
          ),
          // StreamBuilder<Position>(
          //   stream:
          // ),
        ],
      ),
    );
  }
}
