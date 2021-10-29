part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

class AppInitial extends AppState {}

class AppLoaded extends AppState {
  const AppLoaded({
    required this.location,
    required this.locationServiceEnabled,
    required this.locationPermissionStatus,
  });

  final Location location;
  final bool locationServiceEnabled;
  final PermissionStatus locationPermissionStatus;

  @override
  List<Object> get props =>
      [location, locationServiceEnabled, locationPermissionStatus];
}
