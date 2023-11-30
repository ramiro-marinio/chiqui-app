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
import 'package:gymapp/firebase/gyms/membershipdata.dart';
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
  List<GymData>? _gyms;
  List<GymData>? get gyms => _gyms;
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
            _userData = UserData.fromJson(map);
          }
        }
        FirebaseFirestore.instance
            .collection('memberships')
            .where('userId', isEqualTo: user?.uid)
            .snapshots()
            .listen((event) async {
          List<QueryDocumentSnapshot> newMemberships = event.docs;
          _gyms = [];

          for (QueryDocumentSnapshot documentSnapshot in newMemberships) {
            _gyms?.add(await getGymData((documentSnapshot.data()
                as Map<String, dynamic>)['gymId'] as String));
          }
          notifyListeners();
        });
        notifyListeners();
      },
    );
    //MEMBERSHIPS LISTENER

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
      FirebaseFirestore.instance
          .collection('userData')
          .doc(user!.uid)
          .update({'photoURL': null});
      await pic.delete();
      return null;
    }
    await pic.putFile(File(filePath));
    user!.updatePhotoURL(await pic.getDownloadURL());
    FirebaseFirestore.instance
        .collection('userData')
        .doc(user!.uid)
        .update({'photoURL': pic.getDownloadURL()});
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

  Future<DocumentReference> createGym(GymData gymData, String code) async {
    gymData.id = code;
    await FirebaseFirestore.instance
        .collection('gyms')
        .doc(code)
        .set(gymData.toJson());
    return FirebaseFirestore.instance.collection('gyms').doc(code);
  }

  Future<void> joinGym(DocumentReference documentReference) async {
    FirebaseFirestore.instance.collection('memberships').add(
          MembershipData(userId: user!.uid, gymId: documentReference.id)
              .toJson(),
        );
  }

  Future<GymData> getGymData(String gymId) async {
    return GymData.fromJson(
        (await FirebaseFirestore.instance.collection('gyms').doc(gymId).get())
            .data()!);
  }

  Future<String> createGymPic(String gymId, File file) async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference ppFolder = referenceRoot.child('gym-profile-pics');
    String termination = file.path.split('.').last;
    Reference pic = ppFolder.child('$gymId.$termination');
    await pic.putFile(file);
    return pic.getDownloadURL();
  }

  Future<UserData?> getUserInfo(String uid) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('userData').doc(uid).get();
    if (snapshot.data() != null) {
      return UserData.fromJson(snapshot.data() as Map<String, dynamic>);
    }
    return null;
    // return result;
  }

  Future<List<Map<String, dynamic>>> getDemoData(String gymId) async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
        (await FirebaseFirestore.instance
                .collection('demonstrations')
                .where('gymId', isEqualTo: gymId)
                .get())
            .docs;
    return List.generate(docs.length, (index) => docs[index].data());
  }

  void addDemonstration(String gymId, Map<String, dynamic> demonstrationData) {
    FirebaseFirestore.instance.collection('demonstrations').add(
          demonstrationData,
        );
  }
}
