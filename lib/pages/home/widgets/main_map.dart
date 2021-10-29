import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../../consts.dart';

class MainMap extends StatefulWidget {
  const MainMap({Key? key}) : super(key: key);

  @override
  MainMapState createState() => MainMapState();
}

class MainMapState extends State<MainMap> {
  MapboxMapController? mapController;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MapboxMap(
      accessToken: kMapBoxToken,
      cameraTargetBounds: CameraTargetBounds(
        LatLngBounds(
          southwest: const LatLng(-12, 95),
          northeast: const LatLng(12, 140),
        ),
      ),
      initialCameraPosition: const CameraPosition(
        target: LatLng(0.7893, 113.9213),
      ),
      rotateGesturesEnabled: false,
      onMapCreated: _onMapCreated,
    );
  }
}
