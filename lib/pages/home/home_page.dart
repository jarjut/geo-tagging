import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

import '../../app/bloc/app_bloc.dart';
import 'widgets/main_map.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          if (state is AppLoaded) {
            if (state.locationServiceEnabled &&
                state.locationPermissionStatus == PermissionStatus.granted) {
              // Location Permission Granted
              return Stack(
                children: [
                  const MainMap(),
                ],
              );
            } else {
              // Location Permission Denied
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Please allow location permission'),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AppBloc>(context)
                            .add(AppRequestLocationService());
                      },
                      child: const Text('Request Permission'),
                    ),
                  ],
                ),
              );
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
