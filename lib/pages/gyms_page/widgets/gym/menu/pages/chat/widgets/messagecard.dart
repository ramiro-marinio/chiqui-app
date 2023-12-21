import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/messagedata.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:provider/provider.dart';

class MessageCard extends StatefulWidget {
  final MessageData messageData;
  final List<UserData?> users;
  const MessageCard({
    super.key,
    required this.messageData,
    required this.users,
  });

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  UserData? sender;
  @override
  Widget build(BuildContext context) {
    for (UserData? userData in widget.users) {
      if (userData?.userId == widget.messageData.senderId) {
        sender = userData;
        break;
      }
    }
    final double width = MediaQuery.of(context).size.width;
    return Consumer<ApplicationState>(
        builder: (context, applicationState, child) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            applicationState.user!.uid == widget.messageData.senderId
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width / 1.5),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: applicationState.user!.uid == widget.messageData.senderId
                    ? adaptiveColor(const Color.fromARGB(255, 188, 227, 134),
                        const Color.fromARGB(255, 29, 64, 34), context)
                    : adaptiveColor(const Color.fromARGB(255, 174, 174, 174),
                        const Color.fromARGB(255, 60, 60, 60), context),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 4),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: sender?.photoURL != null
                                ? NetworkImage(sender!.photoURL!)
                                : const AssetImage('assets/no_image.jpg')
                                    as ImageProvider,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: AutoSizeText(
                              sender?.displayName ??
                                  applicationState.user?.displayName ??
                                  'Unavailable User',
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          widget.messageData.message,
                          textAlign: TextAlign.start,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
