import '../../domain/entities/user_entity.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading({this.isGoogle = false});


  final bool isGoogle;
}

class AuthSuccess extends AuthState {
  final UserEntity user;
  const AuthSuccess(this.user);
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

class AuthSignedOut extends AuthState {
  const AuthSignedOut();
}
