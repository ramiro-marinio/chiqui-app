import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, AuthProvider;
//this is necessary because there is another emailauthprovider,
//which collides with firebase_ui_auth's emailauthprovider, creating errors.
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  User? _user;
  User? get user => _user;
  UserData? _userData;
  UserData? get userData => _userData;
  void init() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
    FirebaseAuth.instance.userChanges().listen(
      (userUpdate) async {
        _loggedIn = userUpdate != null;
        _user = userUpdate;
        Map<String, dynamic>? map = (await FirebaseFirestore.instance
                .collection("userData")
                .doc(user?.uid)
                .get())
            .data();
        if (map != null) {
          if (map.isNotEmpty) {
            _userData = UserData.fromMap(map);
          }
        }
        notifyListeners();
      },
    );
    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);
    // FirebaseFirestore.instance.collection('userData').snapshots();
  }

  void signOut() async {
    FirebaseAuth.instance.signOut();
  }

  Future<String?> changeUserImage(String? filePath) async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference ppFolder = referenceRoot.child('profile-pics');
    Reference pic = ppFolder.child(user!.uid);
    if (filePath == null) {
      user!.updatePhotoURL(null);
      await pic.delete();
      return null;
    }
    await pic.putFile(File(filePath));
    user!.updatePhotoURL(await pic.getDownloadURL());
    return pic.getDownloadURL();
  }

  Future<void> createUserData(
      Map<String, dynamic> data, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection("userData")
          .doc(user!.uid)
          .set(data);
    } on Exception {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Check your internet connection.'),
          ),
        );
      }
    }
  }

  Future<void> updateUserData(Map<String, dynamic> userData) async {
    FirebaseFirestore.instance
        .collection('userData')
        .doc(user!.uid)
        .update(userData);
  }

  Future<List<Map<String, dynamic>>> getGyms() async {
    List<Map<String, dynamic>> result = [];
    FirebaseFirestore.instance
        .collection("memberships")
        .where("userId", isEqualTo: user?.uid)
        .snapshots()
        .listen((event) {
      result =
          List.generate(event.docs.length, (index) => event.docs[index].data());
    });
    return result;
  }

  Future<void> createGym(GymData gymData) async {
    FirebaseFirestore.instance.collection('gyms').add(gymData.toJson());
  }
}
