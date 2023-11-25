import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  void init() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
    FirebaseAuth.instance.userChanges().listen(
      (user) {
        _loggedIn = user != null;
        notifyListeners();
      },
    );
    //TODO: Get user's gyms and create user data upon login.
    // FirebaseFirestore.instance.collection('userData').snapshots();
  }
}
