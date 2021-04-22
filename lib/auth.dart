import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> signIn(String email, String password) async {
    bool success = false;
    await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => success = true)
        .catchError((value) => success = false);
    return success;
  }

  void createUser(String email, String password) {
    _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => null)
        .catchError((value) => null);
  }

  User? currentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
