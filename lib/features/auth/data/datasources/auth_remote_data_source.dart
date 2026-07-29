import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/constants/auth_constants.dart';

/// Thin wrapper around the Firebase Auth and Google Sign-In SDKs.
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._firebaseAuth, this._googleSignIn);

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  bool _googleSignInInitialized = false;

  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

  Future<firebase_auth.User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user!;
  }

  Future<firebase_auth.User> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user!.updateDisplayName(displayName);
    await credential.user!.reload();
    return _firebaseAuth.currentUser!;
  }

  Future<firebase_auth.User> signInWithGoogle() async {
    await _ensureGoogleSignInInitialized();
    final account = await _googleSignIn.authenticate();
    final idToken = account.authentication.idToken;
    final credential = firebase_auth.GoogleAuthProvider.credential(
      idToken: idToken,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    return userCredential.user!;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _ensureGoogleSignInInitialized();
    await _googleSignIn.signOut();
  }

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) return;
    await _googleSignIn.initialize(
      serverClientId: AuthConstants.googleServerClientId,
    );
    _googleSignInInitialized = true;
  }
}
