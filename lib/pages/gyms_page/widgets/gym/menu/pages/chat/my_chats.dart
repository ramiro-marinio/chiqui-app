import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/functions/processconvodocs.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/chat/widgets/chat_tile.dart';
import 'package:gymapp/widgets/filterbar.dart';
import 'package:provider/provider.dart';

class MyChats extends StatefulWidget {
  final GymData gymData;
  const MyChats({super.key, required this.gymData});

  @override
  State<MyChats> createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  String search = '';
  Future<List<UserData?>>? _getUsers;
  @override
  Widget build(BuildContext context) {
    final ApplicationState applicationState =
        Provider.of<ApplicationState>(context);
    _getUsers ??= applicationState.getGymUsers(widget.gymData.id!);
    return FutureBuilder(
        future: _getUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<UserData?> users = snapshot.data!;
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilterBar(
                        onChanged: (value) {
                          setState(() {
                            search = value;
                          });
                        },
                      ),
                      Visibility(
                        visible: search.isEmpty,
                        child: ChatTile(
                          userData: null,
                          gymData: widget.gymData,
                          users: users,
                          publicChat: true,
                        ),
                      ),
                      ...processConversations(
                        users,
                        context,
                        widget.gymData,
                        users,
                        search,
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        });
  }
}
