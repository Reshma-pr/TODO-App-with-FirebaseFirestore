import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list/Screens/todo.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

Future<String?> signUp(BuildContext context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    UserCredential result = await auth.signInWithCredential(credential);
    User? user = result.user;
    if (result != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => Todo(
                    auth: auth,
                    uid: auth.currentUser?.uid,
                  )));
    }
  }
}
