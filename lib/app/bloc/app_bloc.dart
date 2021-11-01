import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<AppStart>((event, emit) async {
      Location location = Location();
      try {
        bool _serviceEnabled = await location.serviceEnabled();
        PermissionStatus _permissionStatus = await location.hasPermission();

        emit(AppLoaded(
          location: location,
          locationServiceEnabled: _serviceEnabled,
          locationPermissionStatus: _permissionStatus,
        ));
      } catch (e) {
        // ignore: avoid_print
        print(e);
        emit(AppLoaded(
          location: location,
          locationServiceEnabled: false,
          locationPermissionStatus: PermissionStatus.denied,
        ));
      }
    });

    on<AppRequestLocationService>((event, emit) async {
      Location location = Location();
      bool _serviceEnabled = await checkLocationService(location);
      PermissionStatus _permissionStatus = await getPermissionStatus(location);

      emit(AppLoaded(
        location: location,
        locationServiceEnabled: _serviceEnabled,
        locationPermissionStatus: _permissionStatus,
      ));
    });
  }

  Future<bool> checkLocationService(Location location) async {
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }
    return _serviceEnabled;
  }

  Future<PermissionStatus> getPermissionStatus(Location location) async {
    PermissionStatus _permissionStatus = await location.hasPermission();

    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await location.requestPermission();
    }
    return _permissionStatus;
  }
}
