import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizley/models/user.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Userdetails _userFromFirebaseUser(User user) {
    return user != null ? Userdetails(uid: user.uid) : null;
  }

  Future signInEmailAndPass(String email, String password) async {
    try {
      UserCredential authResult = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e);
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential authResult = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseuser = authResult.user;
      return _userFromFirebaseUser(firebaseuser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPass(String email) async {
    try {
      return await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}