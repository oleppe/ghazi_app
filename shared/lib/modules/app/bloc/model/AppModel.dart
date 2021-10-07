import 'package:equatable/equatable.dart';

class AppModel extends Equatable {
  const AppModel({this.isDark = false, this.isFirstLaunch = false});
  final bool isDark;
  final bool isFirstLaunch;
  @override
  // TODO: implement props
  List<Object> get props => [isDark, isFirstLaunch];

  // factory AppModel.fromJson(Map<String, dynamic> json) =>
  //     _$AppModelFromJson(json);

  // Map<String, dynamic> toJson() => _$AppModelToJson(this);
}
