part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class OnTokenReceivedEvent extends AuthEvent {
  final String token;
  const OnTokenReceivedEvent(this.token);
}

class OnRemoveToken extends AuthEvent {}

class OnStoreFirebaseToken extends AuthEvent {
  final String token;
  const OnStoreFirebaseToken(this.token);
}