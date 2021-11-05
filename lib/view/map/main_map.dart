import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geo_tagging/models/message.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../consts.dart';
import '../bloc/message_bloc.dart';
import '../home_page.dart';

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

  void _onStyleLoaded(List<Message> messages) async {
    final ByteData bytes = await rootBundle.load('assets/marker.png');
    final Uint8List list = bytes.buffer.asUint8List();
    _mapController?.addImage('AppMarker', list);
    _updateSymbols(messages);
  }

  Future<void> _updateSymbols(
    List<Message> messages,
  ) async {
    final symbols = messages
        .map((m) => SymbolOptions(
              geometry: LatLng(m.latitude, m.longitude),
              iconImage: 'AppMarker',
              iconOffset: const Offset(0, -5),
            ))
        .toList();

    await _mapController?.clearSymbols();
    await _mapController?.addSymbols(symbols);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MessageBloc, MessageState>(
      listener: (context, state) async {
        if (state is MessageLoaded) {
          if (_mapController != null) {
            _updateSymbols(state.messages);
          }
        }
      },
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is MessageLoaded) {
          return Consumer<HomeProvider>(builder: (context, homeState, _) {
            return MapboxMap(
              accessToken: kMapBoxToken,
              cameraTargetBounds: CameraTargetBounds(
                LatLngBounds(
                  southwest: const LatLng(-12, 93),
                  northeast: const LatLng(12, 143),
                ),
              ),
              // minMaxZoomPreference: const MinMaxZoomPreference(null, 6),
              initialCameraPosition: const CameraPosition(
                target: LatLng(0.7893, 113.9213),
              ),
              scrollGesturesEnabled: !homeState.showMessage,
              zoomGesturesEnabled: !homeState.showMessage,
              rotateGesturesEnabled: false,
              onMapCreated: _onMapCreated,
              onStyleLoadedCallback: () => _onStyleLoaded(state.messages),
              // styleString: 'mapbox://styles/jarjut/ckvhpi1av15i414oarkl73s2t',
            );
          });
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
