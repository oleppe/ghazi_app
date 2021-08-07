import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
// import 'package:shared/modules/authentication/models/current_user_data.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AppAutheticated extends AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationStart extends AuthenticationState {}

class UserLogoutState extends AuthenticationState {}

class CategorySelectedState extends AuthenticationState {
  final String id;

  CategorySelectedState({this.id});
}

class SetUserData extends AuthenticationState {
  final String email;
  final String avatar;

  SetUserData({this.email, this.avatar});
}

// class SetUserData extends AuthenticationState {
//   final CurrentUserData currentUserData;
//   SetUserData({this.currentUserData});
//   @override
//   List<Object> get props => [currentUserData];
// }

class AuthenticationNotAuthenticated extends AuthenticationState {}

class AuthenticationFailure extends AuthenticationState {
  final String message;

  AuthenticationFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
