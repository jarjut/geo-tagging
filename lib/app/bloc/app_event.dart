part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppStart extends AppEvent {}

class AppRequestLocationService extends AppEvent {}
