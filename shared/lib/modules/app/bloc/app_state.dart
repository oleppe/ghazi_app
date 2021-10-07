part of 'app_bloc.dart';

@immutable
class AppState extends Equatable {
  final bool isDark;
  bool isFirstLaunch = true;
  AppState({this.isDark = false, this.isFirstLaunch});
  @override
  List<Object> get props => [this.isDark, this.isFirstLaunch];
}

class AppDarkTheme extends AppState {
  AppDarkTheme() : super(isDark: true);
}

class AppLightTheme extends AppState {
  AppLightTheme() : super(isDark: false);
}

class AppFirstLaunch extends AppState {
  AppFirstLaunch() : super(isFirstLaunch: false);
}
