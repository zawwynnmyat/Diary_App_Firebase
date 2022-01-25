import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FireAuth {

  static String errors = '';
  static String loginErrors = '';

  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.updateProfile(displayName: name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if(e.code == "network-request-failed") {
        errors = 'network-request-failed';
      }
      if (e.code == 'weak-password') {
        errors = 'weak-password';
      } else if (e.code == 'email-already-in-use') {
        errors = 'email-already-in-use';
      }
    } catch (e) {
      print(e);
    }
    return user;
  }

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if(e.code == 'network-request-failed') {
        loginErrors = 'network-request-failed';
      } else if (e.code == 'user-not-found') {
        loginErrors = 'user-not-found';
      } else if (e.code == 'wrong-password') {
        loginErrors = 'wrong-password';
      }
    }

    return user;
  }

  static Future<User?> signInWithFacebook() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      final LoginResult result = await FacebookAuth.instance.login();

      switch (result.status) {
        case LoginStatus.success:
          final AuthCredential facebookCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);
          final userCredential =
          await auth.signInWithCredential(facebookCredential);
          user = userCredential.user;
          return user;
        case LoginStatus.cancelled:
          return null;
        case LoginStatus.failed:
          return null;
        default:
          return null;
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if(e.code == 'account-exists-with-different-credential') {
        print('Account already exists');
      }
    }
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

}