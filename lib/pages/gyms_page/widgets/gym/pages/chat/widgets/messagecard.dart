import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:provider/provider.dart';

class MessageCard extends StatefulWidget {
  final String uid;
  final String message;
  final List<UserData?> users;
  const MessageCard(
      {super.key,
      required this.uid,
      required this.message,
      required this.users});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Consumer<ApplicationState>(
        builder: (context, applicationState, child) {
      return Row(
        mainAxisAlignment: applicationState.user!.uid == widget.uid
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width / 1.5),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: applicationState.user!.uid == widget.uid
                    ? adaptiveColor(const Color.fromARGB(255, 188, 227, 134),
                        const Color.fromARGB(255, 29, 64, 34), context)
                    : const Color.fromARGB(255, 60, 60, 60),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0, top: 4),
                          child: CircleAvatar(
                            radius: 20,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: AutoSizeText(
                              widget.uid,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.message,
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontSize: 16),
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
