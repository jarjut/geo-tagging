import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../consts.dart';
import 'bloc/message_bloc.dart';

class MainMap extends StatefulWidget {
  const MainMap({Key? key}) : super(key: key);

  @override
  MainMapState createState() => MainMapState();
}

class MainMapState extends State<MainMap> {
  MapboxMapController? _mapController;

  void _onMapCreated(MapboxMapController controller) {
    _mapController = controller;
  }

  void _onStyleLoaded() async {
    final ByteData bytes = await rootBundle.load('assets/marker.png');
    final Uint8List list = bytes.buffer.asUint8List();
    return _mapController!.addImage('AppMarker', list);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessageBloc, MessageState>(
      listener: (context, state) async {
        if (state is MessageLoaded) {
          final symbols = state.messages
              .map((m) => SymbolOptions(
                    geometry: LatLng(m.latitude, m.longitude),
                    iconImage: 'AppMarker',
                  ))
              .toList();

          await _mapController?.clearSymbols();
          await _mapController?.addSymbols(symbols);
        }
      },
      child: MapboxMap(
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
        onStyleLoadedCallback: _onStyleLoaded,
        myLocationRenderMode: MyLocationRenderMode.NORMAL,
      ),
    );
  }
}
