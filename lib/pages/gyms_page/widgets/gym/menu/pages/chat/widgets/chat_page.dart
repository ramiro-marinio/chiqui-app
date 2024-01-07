import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/gyms/membershipdata.dart';
import 'package:gymapp/firebase/gyms/messagedata.dart';
import 'package:gymapp/functions/processmessagedocs.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/chat/widgets/chat_options.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/chat/widgets/messagecard.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/chat/widgets/messagetyper.dart';
import 'package:gymapp/widgets/crawl.dart';
import 'package:gymapp/widgets/zoomavatar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatPage extends StatefulWidget {
  final String gymId;
  final UserData? otherUser;
  final List<UserData?> users;
  final bool publicChat;
  const ChatPage({
    super.key,
    required this.gymId,
    required this.otherUser,
    required this.users,
    required this.publicChat,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<MessageData> myMessages = [];
  List<MessageData> theirMessages = [];
  List<MessageData> messages = [];
  late ApplicationState applicationState;
  late Future<MembershipData?> membershipData;
  late Future<GymData?> gymData;
  @override
  void initState() {
    super.initState();
    applicationState = context.read<ApplicationState>();
    applicationState.currentChatID = widget.otherUser?.userId;
    membershipData = applicationState.getMembership(
        widget.gymId, applicationState.user!.uid);
    gymData = applicationState.getGymData(widget.gymId);
    //Listener for messages from the client user
    if (widget.publicChat == false) {
      applicationState
          .getChatStream(
              gymId: widget.gymId,
              senderId: applicationState.user!.uid,
              receiverId: widget.otherUser!.userId)
          .listen((event) {
        setState(() {
          myMessages = processMessageDocs(event.docs);
          messages = myMessages + theirMessages;
          messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        });
      });
      //Listener for messages from other user
      applicationState
          .getChatStream(
              gymId: widget.gymId,
              senderId: widget.otherUser!.userId,
              receiverId: applicationState.user!.uid)
          .listen((event) {
        setState(() {
          theirMessages = processMessageDocs(event.docs);
          messages = myMessages + theirMessages;
          messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        });
      });
    } else {
      applicationState
          .getChatStream(gymId: widget.gymId, receiverId: null, senderId: null)
          .listen((event) {
        setState(() {
          messages = processMessageDocs(event.docs);
          messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        });
      });
    }
  }

  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return WillPopScope(
      onWillPop: () async {
        applicationState.currentChatID = null;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              if (widget.otherUser != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ZoomAvatar(
                    photoURL: widget.otherUser!.photoURL,
                    radius: 20,
                    tag: 'Chat-Pic',
                  ),
                ),
              SizedBox(
                height: AppBar().preferredSize.height,
                child: InkWell(
                  onTap: !widget.publicChat
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatOptions(
                                userData: widget.otherUser!,
                                membership: membershipData,
                                gymData: gymData,
                              ),
                            ),
                          );
                        }
                      : null,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: widget.otherUser?.displayName != null
                        ? Crawl(child: Text(widget.otherUser!.displayName))
                        : Text(appLocalizations.publicChat),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                controller: controller,
                children: List.generate(
                  messages.length,
                  (index) => MessageCard(
                    messageData: messages[index],
                    users: widget.users,
                  ),
                ),
              ),
            ),
            MessageTyper(
              onSubmit: (text) async {
                await applicationState.sendMessage(
                  MessageData(
                      message: text,
                      gymId: widget.gymId,
                      senderId: applicationState.user!.uid,
                      receiverId: widget.otherUser?.userId,
                      timestamp: DateTime.now().millisecondsSinceEpoch),
                );
                controller.jumpTo(controller.position.maxScrollExtent);
                if (!widget.publicChat) {
                  applicationState.sendNotification(
                    receiver: widget.otherUser!,
                    gymId: widget.gymId,
                    message: text,
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
