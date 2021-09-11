import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_core/firebase_core.dart';
import 'package:shared/main.dart';

class AuthService {
  AuthService() {}
  firebase.FirebaseAuth _auth;
  String errorMessage;

  Future<firebase.FirebaseAuth> getAuth() async {
    if (Firebase.apps.length == 0) await Firebase.initializeApp();
    return firebase.FirebaseAuth.instance;
  }

  //Create User Object from Firebase User
  UserFromFirebaseUser _userFromFirebaseUser(firebase.User user, token) {
    return user != null
        ? UserFromFirebaseUser(uid: user.uid, email: user.email, token: token)
        : null;
  }

  //Signin With email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      firebase.UserCredential userCredential = await (await getAuth())
          .signInWithEmailAndPassword(email: email, password: password);
      final res = await userCredential.user.getIdToken();
      return _userFromFirebaseUser(userCredential.user, res);
    } catch (err) {
      errorMessage = getMessageFromErrorCode(err.code);
      print(errorMessage);
      return Future.error(errorMessage);
    }
  }

  //Register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      firebase.UserCredential userCredential = await (await getAuth())
          .createUserWithEmailAndPassword(email: email, password: password);
      final res = await userCredential.user.getIdToken();
      return _userFromFirebaseUser(userCredential.user, res);
    } catch (err) {
      errorMessage = getMessageFromErrorCode(err.code);
      print(errorMessage);
      return Future.error(errorMessage);
    }
  }

  Future getCurrentUser() async {
    try {
      final firebase.User user = await (await getAuth()).currentUser;
      if (user != null) {
        final res = await user.getIdToken();
        return _userFromFirebaseUser(user, res);
      } else {
        return null;
      }
    } catch (err) {
      errorMessage = getMessageFromErrorCode(err.code);
      print(errorMessage);
      return Future.error(errorMessage);
    }
  }

  //signout
  Future<void> signOut() async {
    return await (await getAuth()).signOut();
  }

  //getMessageFromErrorCode
  String getMessageFromErrorCode(errorCode) {
    switch (errorCode) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used. Go to login page.";
        break;
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong email/password combination.";
        break;
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No user found with this email. Please signUp to continue";
        break;
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too many requests to log into this account.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return "Server error, please try again later.";
        break;
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Email address is invalid.";
        break;
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No account found with this email";
        break;
      default:
        return "Login failed. Please try again.";
        break;
    }
  }
}
