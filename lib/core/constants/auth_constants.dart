/// Firebase/Google Sign-In OAuth client identifiers. These are public
/// client identifiers (not secrets) sourced from `google-services.json`.
abstract final class AuthConstants {
  /// Web OAuth client ID, required by `google_sign_in` on Android so the
  /// Credential Manager flow can mint a Firebase-verifiable ID token.
  static const String googleServerClientId =
      '802691836492-5orpnbd3qr5kbfdsapdd99rc29lpgleg.apps.googleusercontent.com';
}
