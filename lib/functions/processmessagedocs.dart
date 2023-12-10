import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymapp/firebase/gyms/messagedata.dart';

List<MessageData> processMessageDocs(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> json) {
  List<MessageData> result = [];
  for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in json) {
    MessageData messageData = MessageData.fromJson(documentSnapshot.data());
    result += [messageData];
  }
  return result;
}
