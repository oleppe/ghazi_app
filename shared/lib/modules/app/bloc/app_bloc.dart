import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared/modules/app/bloc/model/AppModel.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends HydratedBloc<AppEvent, AppState> {
  AppBloc() : super(AppLightTheme()) {
    on<SwitchToDarkEvent>((event, emit) {
      emit(AppDarkTheme());
    });
    on<SwitchToLightEvent>((event, emit) {
      emit(AppLightTheme());
    });
    on<FirstLaunchEvent>((event, emit) {
      emit(AppFirstLaunch());
    });
  }

  @override
  AppState fromJson(Map<String, dynamic> json) {
    return AppState(
        isDark: json['isDark'] as bool,
        isFirstLaunch: json['isFirstLaunch'] as bool);
  }

  @override
  Map<String, dynamic> toJson(AppState state) {
    return <String, dynamic>{
      'isDark': state.isDark,
      'isFirstLaunch': state.isFirstLaunch
    };
  }
}
