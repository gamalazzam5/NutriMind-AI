import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/sign_in_with_email_usecase.dart';
import '../../domain/usecases/sign_in_with_google_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_with_email_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._signInWithEmail,
    this._signUpWithEmail,
    this._signInWithGoogle,
    this._signOut,
  ) : super(const AuthInitial());

  final SignInWithEmailUseCase _signInWithEmail;
  final SignUpWithEmailUseCase _signUpWithEmail;
  final SignInWithGoogleUseCase _signInWithGoogle;
  final SignOutUseCase _signOut;

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    final result = await _signInWithEmail(email: email, password: password);
    _emitResult(result);
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    emit(const AuthLoading());
    final result = await _signUpWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );
    _emitResult(result);
  }

  Future<void> signInWithGoogle() async {
    emit(const AuthLoading(isGoogle: true));
    final result = await _signInWithGoogle();
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        failure is CancelledFailure ? const AuthInitial() : AuthError(failure.message),
      ),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> signOut() async {
    emit(const AuthLoading());
    final result = await _signOut();
    if (isClosed) return;
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const AuthSignedOut()),
    );
  }

  void _emitResult(Either<Failure, UserEntity> result) {
    if (isClosed) return;
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }
}
