part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

class AppInitial extends AppState {}

class AppLoaded extends AppState {
  const AppLoaded({
    this.locationData,
    this.hasPermission = false,
  });

  final LocationData? locationData;
  final bool hasPermission;

  @override
  List<Object?> get props => [locationData, hasPermission];
}
