part of 'app_bloc.dart';

@immutable
abstract class AppEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FirstLaunchEvent extends AppEvent {}

class SwitchToDarkEvent extends AppEvent {}

class SwitchToLightEvent extends AppEvent {}
