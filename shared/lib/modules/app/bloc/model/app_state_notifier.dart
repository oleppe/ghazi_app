import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'AppModel.dart';

class AppStateNotifier extends HydratedCubit<AppModel> {
  AppStateNotifier(AppModel state) : super(state);
  void updateTheme(AppModel app) {
    emit(app);
  }

  @override
  AppModel fromJson(Map<String, dynamic> json) {
    return json['isDarkMode'];
  }

  @override
  Map<String, dynamic> toJson(AppModel state) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
