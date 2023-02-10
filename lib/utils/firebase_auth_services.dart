import 'package:chat_app/utils/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/exceptions.dart';

class FirebaseAuthServices {
  FirebaseAuthServices._();

  static FirebaseAuthServices? _instance;
  static FirebaseAuthServices? get instance =>
      _instance ?? FirebaseAuthServices._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _isGoogleLogin = false;

  /// It takes in an email and password, and returns a user if the email and password are correct,
  /// otherwise it throws an exception
  ///
  /// Args:
  ///   email (String): The email address of the user.
  ///   password (String): The user's password.
  ///
  /// Returns:
  ///   A Future<User?>
  Future<User?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
          throw SignInException(e.code);
        default:
          return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  /// _auth.createUserWithEmailAndPassword(email: email, password: password);
  ///
  /// Args:
  ///   email (String): The email address of the user.
  ///   password (String): The user's password.
  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      await _auth.currentUser!.updateDisplayName(displayName);
      await _auth.currentUser!.updatePhotoURL(
          'https://firebasestorage.googleapis.com/v0/b/chatty-app-c401c.appspot.com/o/avatars%2Fdefault%2Fdefault-avatar-profile-trendy-style-social-media-user-icon-187599373.jpg?alt=media&token=a0e3f474-b1ea-4e9f-a6c8-3aef7cb1b97c');
      FirebaseFirestoreService.instance.storeUser(_auth.currentUser);

      return user;
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw CreateAccountException(e.code);
        default:
      }
      return null;
    }
  }

  /// It signs in the user with Google, and returns the user's information
  ///
  /// Returns:
  ///   The user object.
  Future<User?> signInWithGoogle() async {
    try {
      _googleSignIn = GoogleSignIn();

      final googleUser = await _googleSignIn.signIn();
      (_googleSignIn.currentUser?.displayName);
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      FirebaseFirestoreService.instance.storeUser(user!);
      _isGoogleLogin = true;
      return user;
    } on PlatformException catch (_) {
      return null;
    }
  }

  void signOut() {
    _auth.signOut();
    if (_isGoogleLogin) {
      _googleSignIn.disconnect();
    }
  }

  Future<User?> get getCurrentUser async {
    return _auth.currentUser;
  }
}
