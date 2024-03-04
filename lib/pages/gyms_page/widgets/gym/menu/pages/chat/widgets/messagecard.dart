import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/messagedata.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:gymapp/functions/calculate_text_size.dart';
import 'package:gymapp/local_settings/local_settings_state.dart';
import 'package:intl/intl.dart';
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
    final double scrWidth = MediaQuery.of(context).size.width;

    return Consumer<ApplicationState>(
        builder: (context, applicationState, child) {
      final double nameWidth = 36 +
          calculateTextSize(
                  sender?.displayName ??
                      applicationState.user?.displayName ??
                      'Unavailable User',
                  const TextStyle(fontSize: 15))
              .width;
      final double textWidth = 16 +
          calculateTextSize(
                  widget.messageData.message, const TextStyle(fontSize: 16))
              .width;
      final double maxMsgWidth = scrWidth / 3 * 2;

      double msgWidth = maxMsgWidth;
      if (nameWidth > textWidth && nameWidth < maxMsgWidth) {
        msgWidth = nameWidth;
      } else if (textWidth > nameWidth && textWidth < msgWidth) {
        msgWidth = textWidth;
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            applicationState.user!.uid == widget.messageData.senderId
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
        children: [
          Visibility(
            visible: widget.messageData.senderId != applicationState.user!.uid,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: ImageIcon(
                const AssetImage('assets/other.png'),
                color: adaptiveColor(const Color.fromARGB(255, 174, 174, 174),
                    const Color.fromARGB(255, 60, 60, 60), context),
                size: 9,
              ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: scrWidth / 1.5),
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Container(
                decoration: ShapeDecoration(
                  color:
                      applicationState.user!.uid == widget.messageData.senderId
                          ? adaptiveColor(
                              const Color.fromARGB(255, 188, 227, 134),
                              const Color.fromARGB(255, 29, 64, 34),
                              context)
                          : adaptiveColor(
                              const Color.fromARGB(255, 174, 174, 174),
                              const Color.fromARGB(255, 60, 60, 60),
                              context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: applicationState.user!.uid !=
                              widget.messageData.senderId
                          ? Radius.zero
                          : const Radius.circular(8),
                      topRight: applicationState.user!.uid ==
                              widget.messageData.senderId
                          ? Radius.zero
                          : const Radius.circular(8),
                      bottomLeft: const Radius.circular(8),
                      bottomRight: const Radius.circular(8),
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                      child: SizedBox(
                        width: msgWidth,
                        child: RichText(
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundImage: sender?.photoURL != null
                                        ? NetworkImage(sender!.photoURL!)
                                        : const AssetImage(
                                                'assets/no_image.jpg')
                                            as ImageProvider,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: sender?.displayName ??
                                    applicationState.user?.displayName ??
                                    'Unavailable User',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'SansSerif',
                                  color: adaptiveColor(
                                      Colors.black, Colors.white, context),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: SizedBox(
                        width: msgWidth + 16,
                        child: Text(
                          "${DateFormat.yMMMd(context.read<LocalSettingsState>().language.countryCode).format(DateTime.fromMillisecondsSinceEpoch(widget.messageData.timestamp))}, ${DateFormat.jm(context.read<LocalSettingsState>().language.countryCode).format(DateTime.fromMillisecondsSinceEpoch(widget.messageData.timestamp))}",
                          style: const TextStyle(fontSize: 8),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: msgWidth + 14,
                      child: Text(
                        widget.messageData.message,
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.messageData.senderId == applicationState.user!.uid,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, right: 8),
              child: ImageIcon(
                const AssetImage('assets/own.png'),
                color: adaptiveColor(const Color.fromARGB(255, 188, 227, 134),
                    const Color.fromARGB(255, 29, 64, 34), context),
                size: 9,
              ),
            ),
          ),
        ],
      );
    });
  }
}
