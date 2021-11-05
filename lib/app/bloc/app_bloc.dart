import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<AppStart>((event, emit) async {
      try {
        Location location = Location();
        final locationData = await location.getLocation();

        emit(AppLoaded(
          locationData: locationData,
          hasPermission: true,
        ));
      } catch (e) {
        log('Error get Location Data', error: e);
        emit(const AppLoaded());
      }
    });

    on<AppCheckLocationPermission>((event, emit) async {
      try {
        Location location = Location();
        final serviceEnabled = await location.serviceEnabled();
        if (!serviceEnabled) {
          await location.requestService();
        }
        final locationData = await location.getLocation();

        emit(AppLoaded(
          locationData: locationData,
          hasPermission: true,
        ));
      } catch (e) {
        log('Error get Location Data', error: e);
        emit(const AppLoaded());
      }
    });

    on<AppBypassPermission>((event, emit) async {
      emit(const AppLoaded(hasPermission: true));
    });
  }
}
