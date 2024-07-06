import 'dart:async';
import 'package:ceylon/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  //firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create a user from a uid
  UserModel? _userWithFirebaseUid(User? user) {
    return user != null ? UserModel(uid: user.uid, email: user.email) : null;
  }

  // Getter for current user
  User? get currentUser {
    return _auth.currentUser;
  }

  //create the stream for checking the auth changes in the user
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userWithFirebaseUid);
  }

  //sign in anonymously
  Future<UserModel?> signInAnnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userWithFirebaseUid(user);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  //register with email and password
  Future<UserModel?> registerWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userWithFirebaseUid(user);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  //sign in with email and password
  Future<UserModel?> signInUsingEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userWithFirebaseUid(user);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  //sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (err) {
      print(err.toString());
      return null;
    }
  }
}
