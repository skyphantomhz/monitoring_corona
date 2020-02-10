import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:monitoring_corona/bloc/monitoring_bloc.dart';
import 'package:monitoring_corona/model/country.dart';
import 'package:monitoring_corona/model/province.dart';
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
  List<Province> _provincePoint = List<Province>();
  bool _includeProvince = false;
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
    _monitoringBloc.data.listen((data) {
      if (data == null) {
        return;
      }
      setState(() {
        _countryPoint = data.countries;
        _provincePoint = data.provinces;
        _updateMarkerCountriesOnly();
      });
    });
  }

  void _updateMarkerCountriesOnly() {
    markers = _countryPoint
        .map((item) => Marker(
            markerId: MarkerId("${item.lat}:${item.long}"),
            onTap: () {
              _settingModalBottomSheet(context, item);
            },
            position: LatLng(double.parse(item.lat), double.parse(item.long)),
            icon: _markerIcon))
        .toSet();
  }

  void _updateMarkerProvincesInclude() {
    _updateMarkerCountriesOnly();
    markers.removeWhere((marker) => marker.markerId == MarkerId("16:108"));
    markers.addAll(_provincePoint
        .map((item) => Marker(
            markerId: MarkerId("${item.lat}:${item.long}"),
            onTap: () {
              _settingProvinceBottomSheet(context, item);
            },
            position: LatLng(double.parse(item.lat), double.parse(item.long)),
            icon: _markerIcon))
        .toSet());
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
              if (cameraPosition.zoom > 5) {
                if (!_includeProvince) {
                  setState(() {
                    _updateMarkerProvincesInclude();
                    _includeProvince = true;
                  });
                }
              } else {
                if (_includeProvince) {
                  setState(() {
                    _updateMarkerCountriesOnly();
                    _includeProvince = false;
                  });
                }
              }
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

  void _settingModalBottomSheet(BuildContext context, Country data) {
    _showDialog(context, data.countryRegion, data.confirmed, data.deaths,
        data.recovered);
  }

  void _settingProvinceBottomSheet(BuildContext context, Province data) {
    Crashlytics.instance.crash();
    _showDialog(context, data.provinceName, data.confirmed, data.deaths,
        data.recovered);
  }

  void _showDialog(BuildContext context, String placeName, String confirmed,
      String deaths, String recovered) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              decoration: BoxDecoration(color: Color(0xFF1b1b1b)),
              child: Wrap(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    alignment: Alignment.center,
                    child: Text(placeName,
                        style:
                            TextStyle(fontSize: 30, color: Color(0xFF757575))),
                  ),
                  ListTile(
                    title: Text("Confirmed: $confirmed",
                        style: TextStyle(color: Color(0xFF757575))),
                  ),
                  ListTile(
                      title: Text("Deaths: $deaths",
                          style: TextStyle(color: Color(0xFF757575)))),
                  ListTile(
                      title: Text("Recovered: $recovered",
                          style: TextStyle(color: Color(0xFF757575)))),
                ],
              ));
        });
  }
}
