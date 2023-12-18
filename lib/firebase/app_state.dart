import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, AuthProvider;
import 'package:firebase_messaging/firebase_messaging.dart';
//this is necessary because there is another emailauthprovider,
//which collides with firebase_ui_auth's emailauthprovider, creating errors.
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/gyms/invitedata.dart';
import 'package:gymapp/firebase/gyms/membershipdata.dart';
import 'package:gymapp/firebase/gyms/messagedata.dart';
import 'package:gymapp/functions/random_string.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/exercise_demos/demodata.dart';
import 'package:http/http.dart' as http;

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
    FirebaseAuth.instance.userChanges().listen(
      (userUpdate) async {
        _loggedIn = userUpdate != null;
        _user = userUpdate;
        updateNotificationToken(signedIn: _user != null);
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

  Future<void> updateGym(GymData gymData) async {
    await FirebaseFirestore.instance
        .collection('gyms')
        .doc(gymData.id!)
        .update(gymData.toJson());
    notifyListeners();
  }

  Future<void> joinGym(DocumentReference documentReference) async {
    FirebaseFirestore.instance.collection('memberships').add(
          MembershipData(
                  userId: user!.uid,
                  gymId: documentReference.id,
                  admin: false,
                  coach: false)
              .toJson(),
        );
  }

  Future<void> leaveGym(String gymId) async {
    (await FirebaseFirestore.instance
            .collection('memberships')
            .where('gymId', isEqualTo: gymId)
            .where('userId', isEqualTo: user!.uid)
            .get())
        .docs[0]
        .reference
        .delete();
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

  Future<String> saveGymPic(String gymId, String picturePath) async {
    File? file = File(picturePath);
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference ppFolder = referenceRoot.child('gym-profile-pics');
    String extension = file.path.split('.').last;
    String name =
        !picturePath.contains('.') ? '$gymId.$extension' : picturePath;
    Reference pic = ppFolder.child(name);
    await pic.putFile(file);
    return pic.getDownloadURL();
  }

  Future<void> deleteGymPic(String photoName) async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference ppFolder = referenceRoot.child('gym-profile-pics');
    Reference pic = ppFolder.child(photoName);
    await pic.delete();
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

  Future<String?> modifyDemoVideo(
      String designatedId, File? videoFile, String? extension) async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference ppFolder = referenceRoot.child('demo-vids');
    if (videoFile != null) {
      String extension = videoFile.path.split('.').last;
      String videoName = '$designatedId.$extension';
      if (designatedId.contains('.')) {
        videoName = designatedId;
      }
      Reference video = ppFolder.child(videoName);
      await video.putFile(videoFile);
      return await video.getDownloadURL();
    } else {
      Reference video = ppFolder.child('$designatedId.$extension');
      await video.delete();
    }
    return null;
  }

  Future<void> addDemonstration(
      DemonstrationData demonstrationData, File? video) async {
    if (video != null) {
      String id = generateRandomString(28);
      String extension = video.path.split('.').last;
      String videoURL = (await modifyDemoVideo(id, video, null))!;
      demonstrationData.resourceName = '$id.$extension';
      demonstrationData.resourceURL = videoURL;
    }
    String id = generateRandomString(28);
    demonstrationData.id = id;
    await FirebaseFirestore.instance
        .collection('demonstrations')
        .doc(demonstrationData.id)
        .set(demonstrationData.toJson());
    notifyListeners();
  }

  Future<void> editDemonstration(
      DemonstrationData demonstrationData, String? videoPath) async {
    if (videoPath != null && videoPath != demonstrationData.resourceURL) {
      File video = File(videoPath);
      String id = generateRandomString(28);
      //Extension value will only be used if there was no resource before
      String extension = video.path.split('.').last;
      String videoURL = (await modifyDemoVideo(
          demonstrationData.resourceName ?? '$id.$extension', video, null))!;
      demonstrationData.resourceName ??= '$id.$extension';
      demonstrationData.resourceURL = videoURL;
    } else if (videoPath == null && demonstrationData.resourceURL != null) {
      String extension = demonstrationData.resourceName!.split('.').last;
      await modifyDemoVideo(
        demonstrationData.resourceName!,
        null,
        extension,
      );
      demonstrationData.resourceName = null;
      demonstrationData.resourceURL = null;
    }
    await FirebaseFirestore.instance
        .collection('demonstrations')
        .doc(demonstrationData.id)
        .update(demonstrationData.toJson());
    notifyListeners();
  }

  Future<void> deleteDemonstration(DemonstrationData demonstrationData) async {
    await FirebaseFirestore.instance
        .collection('demonstrations')
        .doc(demonstrationData.id)
        .delete();
    if (demonstrationData.resourceName != null) {
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference folder = referenceRoot.child('demo-vids');
      Reference file = folder.child(demonstrationData.resourceName!);
      await file.delete();
    }
    notifyListeners();
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

  Future<void> sendNotification(
      {required UserData receiver,
      required String gymId,
      required String message}) async {
    String? displayName = user?.displayName;
    if (displayName == null) {
      return;
    }
    UserData? userData = await getUserInfo(user!.uid);
    await http.post(
      Uri.parse('https://sendmessagenotification-xg2n2l3ccq-uc.a.run.app'),
      body: jsonEncode({
        'displayName': displayName,
        'gymId': gymId,
        'message': message,
        'senderId': user!.uid,
        'receiverId': receiver.userId,
        'user': jsonEncode(userData!.toMap()),
      }),
    );
  }

  Future<void> sendReview(String review, double stars, String gymId) async {
    await FirebaseFirestore.instance
        .collection('ratings')
        .doc(user!.uid + gymId)
        .set({
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

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatStream(
      {required String gymId, String? senderId, String? receiverId}) {
    if (receiverId == null || senderId == null) {
      return FirebaseFirestore.instance
          .collection('messages')
          .where('receiverId', isEqualTo: null)
          .where('gymId', isEqualTo: gymId)
          .orderBy('timestamp', descending: false)
          .snapshots();
    }
    return FirebaseFirestore.instance
        .collection('messages')
        .where('gymId', isEqualTo: gymId)
        .where('senderId', isEqualTo: senderId)
        .where('receiverId', isEqualTo: receiverId)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> updateNotificationToken({required bool signedIn}) async {
    FirebaseFirestore.instance.collection('tokens').doc(user!.uid).set({
      'userId': user!.uid,
      'token': signedIn ? await FirebaseMessaging.instance.getToken() : null,
    });
  }

  Future<void> modifyMembership(
      Map<String, dynamic> json, MembershipData membershipData) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('memberships')
        .where('gymId', isEqualTo: membershipData.gymId)
        .where('userId', isEqualTo: membershipData.userId)
        .get();
    querySnapshot.docs[0].reference.update(json);
  }

  Future<MembershipData> getMembership(String gymId, String userId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('memberships')
        .where('gymId', isEqualTo: gymId)
        .where('userId', isEqualTo: userId)
        .get();
    return MembershipData.fromJson(querySnapshot.docs[0].data());
  }
}
