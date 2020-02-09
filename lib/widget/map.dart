import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:monitoring_corona/bloc/monitoring_bloc.dart';
import 'package:monitoring_corona/model/country.dart';
import 'package:rxdart/rxdart.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  MonitoringBloc _monitoringBloc;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  String mapStyle;
  Set<Marker> markers;
  BitmapDescriptor _markerIcon;
  List<Country> _countryPoint = List<Country>();

  PublishSubject<String> position = PublishSubject();

  @override
  void dispose() {
    position.close();
    _monitoringBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initMarkerIcon();
    _monitoringBloc = MonitoringBloc();
    _getQuery();
    _setListener();
    loadMapStyleFile();
  }

  void initMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/icons/destination_map_marker.png');
  }

  void _getQuery() async {
    final query = await DefaultAssetBundle.of(context)
        .loadString("assets/monitoring_world.json");
    _monitoringBloc.monitoringWordData(query);
  }

  void _setListener() {
    _monitoringBloc.countries.listen((data) {
      if (data == null) {
        return;
      }
      setState(() {
        _countryPoint = data;
        markers = data
            .map((item) => Marker(
                markerId: MarkerId("${item.lat}:${item.long}"),
                position:
                    LatLng(double.parse(item.lat), double.parse(item.long)),
                icon: _markerIcon))
            .toSet();
      });
    });
  }

  static final CameraPosition _kGooglePlex =
      CameraPosition(bearing: 0, target: LatLng(19, 111), tilt: 0, zoom: 3);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: markers,
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
              final info =
                  "Bearing: ${cameraPosition.bearing.toInt()}; tilt: ${cameraPosition.tilt.toInt()}; target: ${cameraPosition.target.longitude.toInt()}:${cameraPosition.target.latitude.toInt()}; zoom: ${cameraPosition.zoom.toInt()};";
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
