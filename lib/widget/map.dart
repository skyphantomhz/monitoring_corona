import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  String mapStyle;

  PublishSubject<String> position = PublishSubject();

  @override
  void initState() {
    super.initState();
    loadMapStyleFile();
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
      bearing: 0,
      target: LatLng(19, 111),
      tilt: 59.440717697143555,
      zoom: 3);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              if (mapStyle != null) {
                mapController.setMapStyle(mapStyle);
              }
              _controller.complete(controller);
            },
            onCameraMove: (cameraPosition) {
              final info = "Bearing: ${cameraPosition.bearing.toInt()}; tilt: ${cameraPosition.tilt.toInt()}; target: ${cameraPosition.target.longitude.toInt()}:${cameraPosition.target.latitude.toInt()}; zoom: ${cameraPosition.zoom.toInt()};";
              position.sink.add(info);
            },
          ),
          Align(
            alignment: Alignment(0, 1),
            child: Container(
              padding: EdgeInsets.all(10),
              child: StreamBuilder<Object>(
                stream: position.stream,
                builder: (context, snapshot) {
                  final info = snapshot?.data ?? "Null";
                  return Text(
                    info,
                    style: TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void loadMapStyleFile() async {
    mapStyle = await DefaultAssetBundle.of(context)
        .loadString("assets/map_style.json");
    mapController?.setMapStyle(mapStyle);
  }
}
