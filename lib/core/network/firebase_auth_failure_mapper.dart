import 'package:firebase_auth/firebase_auth.dart';

import '../error/failures.dart';

Failure mapFirebaseAuthException(Object error) {
  if (error is! FirebaseAuthException) {
    return const UnknownFailure('Something went wrong. Please try again.');
  }

  switch (error.code) {
    case 'invalid-email':
      return const ServerFailure('That email address looks invalid.');
    case 'user-disabled':
      return const ServerFailure('This account has been disabled.');
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return const ServerFailure('Incorrect email or password.');
    case 'email-already-in-use':
      return const ServerFailure('An account already exists with that email.');
    case 'weak-password':
      return const ServerFailure(
        'Choose a stronger password (at least 6 characters).',
      );
    case 'too-many-requests':
      return const ServerFailure('Too many attempts. Please try again later.');
    case 'account-exists-with-different-credential':
      return const ServerFailure(
        'An account already exists with a different sign-in method.',
      );
    case 'network-request-failed':
      return const NetworkFailure(
        'No internet connection. Please check your network.',
      );
    default:
      return ServerFailure(error.message ?? 'Something went wrong. Please try again.');
  }
}
