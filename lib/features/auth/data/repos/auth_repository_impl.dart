import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../../../core/error/failures.dart';
import '../../../../core/network/firebase_auth_failure_mapper.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repos/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final AuthRemoteDataSource _dataSource;

  @override
  UserEntity? get currentUser => _toEntity(_dataSource.currentUser);

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _dataSource.signInWithEmail(
        email: email,
        password: password,
      );
      return Right(_toEntity(user)!);
    } catch (e) {
      return Left(mapFirebaseAuthException(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final user = await _dataSource.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      return Right(_toEntity(user)!);
    } catch (e) {
      return Left(mapFirebaseAuthException(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final user = await _dataSource.signInWithGoogle();
      return Right(_toEntity(user)!);
    } catch (e) {
      return Left(mapFirebaseAuthException(e));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _dataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(mapFirebaseAuthException(e));
    }
  }

  UserEntity? _toEntity(firebase_auth.User? user) {
    if (user == null) return null;
    return UserEntity(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }
}
