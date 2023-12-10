import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/chat/widgets/chat_tile.dart';
import 'package:provider/provider.dart';

List<ChatTile> processConversations(List<UserData?> gymMembers,
    BuildContext context, GymData gymData, List<UserData?> users) {
  ApplicationState applicationState = Provider.of<ApplicationState>(context);
  List<ChatTile> result = [];
  for (UserData? userData in gymMembers) {
    if (userData != null && userData.userId != applicationState.user!.uid) {
      result += [
        ChatTile(
          userData: userData,
          gymData: gymData,
          users: users,
          publicChat: false,
        )
      ];
    }
  }
  return result;
}
