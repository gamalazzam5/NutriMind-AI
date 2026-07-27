import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repos/auth_repository.dart';

class SignOutUseCase {
  SignOutUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, void>> call() {
    return _repository.signOut();
  }
}
