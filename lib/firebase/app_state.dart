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
import 'package:gymapp/firebase/gyms/invitedata.dart';
import 'package:gymapp/firebase/gyms/membershipdata.dart';
import 'package:gymapp/firebase/gyms/messagedata.dart';
import 'package:gymapp/firebase_options.dart';
import 'package:gymapp/functions/random_string.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/pages/exercise_demos/demodata.dart';

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
            GymData? gymData = await getGymData((documentSnapshot.data()
                as Map<String, dynamic>)['gymId'] as String);
            _gyms?.add(gymData!);
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
        .update({'photoURL': await pic.getDownloadURL()});
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

  bool checkMembership(String gymId) {
    for (GymData gymData in _gyms!) {
      if (gymData.id == gymId) {
        return true;
      }
    }
    return false;
  }

  Future<GymData?> getGymData(String gymId) async {
    Map<String, dynamic>? data =
        (await FirebaseFirestore.instance.collection('gyms').doc(gymId).get())
            .data();
    if (data != null) {
      return GymData.fromJson(data);
    }
    return null;
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

  Future<List<UserData?>> getGymUsers(String gymId) async {
    QuerySnapshot<Map<String, dynamic>> membershipsQuerySnapshot =
        await FirebaseFirestore.instance
            .collection('memberships')
            .where('gymId', isEqualTo: gymId)
            .get();
    List<String> userIds =
        List.generate(membershipsQuerySnapshot.docs.length, (index) {
      Map<String, dynamic> data = membershipsQuerySnapshot.docs[index].data();
      return data['userId'] as String;
    });
    List<UserData?> result = [];
    for (String uid in userIds) {
      result.add(await getUserInfo(uid));
    }
    return result;
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

  Future<String> createDemoVideo(String gymId, File videoFile) async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference ppFolder = referenceRoot.child('demo-vids');
    String termination = videoFile.path.split('.').last;
    Reference video = ppFolder.child('$gymId.$termination');
    await video.putFile(videoFile);
    return await video.getDownloadURL();
  }

  Future<void> addDemonstration(
      DemonstrationData demonstrationData, File? video) async {
    if (video != null) {
      String videoURL = await createDemoVideo(generateRandomString(28), video);
      demonstrationData.resourceURL = videoURL;
      demonstrationData.resourceFormat = video.path.split('.').last;
    }
    await FirebaseFirestore.instance.collection('demonstrations').add(
          demonstrationData.toJson(),
        );
  }

  Future<InviteData?> getInviteData(String gymId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('invites')
        .where('gymId', isEqualTo: gymId)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return null;
    }
    return InviteData.fromJson(
      querySnapshot.docs[0].data(),
    );
  }

  Future<InviteData?> getInviteDataByCode(String code) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('invites')
        .where('code', isEqualTo: code)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return null;
    }
    return InviteData.fromJson(
      querySnapshot.docs[0].data(),
    );
  }

  Future<void> addInviteData(String gymId) async {
    await FirebaseFirestore.instance
        .collection('invites')
        .add(InviteData(code: generateRandomString(7), gymId: gymId).toJson());
  }

  Future<void> updateInviteData(InviteData data) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('invites')
        .where('gymId', isEqualTo: data.gymId)
        .get();
    await querySnapshot.docs[0].reference.update(data.toJson());
  }

  Future<bool> verifyInvite(String code) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('invites')
        .where('code', isEqualTo: code)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return true;
    }
    return false;
  }

  Future<void> sendMessage(MessageData messageData) async {
    await FirebaseFirestore.instance
        .collection('messages')
        .add(messageData.toJson());
  }

  Future<void> sendReview(String review, double stars, String gymId) async {
    await FirebaseFirestore.instance.collection('ratings').doc(user!.uid).set({
      'review': review,
      'stars': stars,
      'gymId': gymId,
      'userId': user!.uid,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<double?> getRating(String gymId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('ratings')
        .where('gymId', isEqualTo: gymId)
        .orderBy('timestamp', descending: true)
        .limit(100)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return null;
    }
    double sum = 0;
    int amount = 0;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      sum += doc.data()['stars'] as double;
      amount++;
    }
    return sum / amount;
  }
}
