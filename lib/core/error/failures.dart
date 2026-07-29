/// Typed failures surfaced from the data layer to the domain layer.
sealed class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

/// The user backed out of a flow themselves (e.g. dismissed the Google
/// account picker). Not an error — callers should return to the prior state
/// silently instead of surfacing a message.
class CancelledFailure extends Failure {
  const CancelledFailure() : super('');
}
