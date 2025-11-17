import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_providers.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

class AuthController {
  final Ref ref;
  AuthController(this.ref);

  FirebaseAuth get _auth => ref.read(firebaseAuthProvider);
  GoogleSignIn get _google => ref.read(googleAuthProvider);

  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapError(e.code);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapError(e.code);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (_) {
      throw "Logout failed.";
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _mapError(e.code);
    }
  }

  Future<void> googleSignIn() async{
    try {
      final user = await _google.signIn();
      if(user == null) throw "Cancelled";

      final auth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken
      );

      await _auth.signInWithCredential(credential);

    } on FirebaseAuthException catch (e) {
      throw _mapError(e.code);
    }
    catch(_){
      throw "Google sign- in failed";
    }
  }

  String _mapError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return "Email already used.";
      case 'invalid-email':
        return "Invalid email.";
      case 'weak-password':
        return "Weak password.";
      case 'user-not-found':
        return "User not found.";
      case 'wrong-password':
        return "Wrong password.";
      default:
        return "Something went wrong.";
    }
  }
}
