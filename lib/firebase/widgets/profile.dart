import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/widgets/profile_config/profileconfig.dart';
import 'package:gymapp/widgets/icontext.dart';
import 'package:gymapp/widgets/zoomavatar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    ApplicationState applicationState = Provider.of<ApplicationState>(context);
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return !applicationState.loading
        ? GestureDetector(
            child: ListTile(
              leading: ZoomAvatar(
                radius: 25,
                photoURL: applicationState.userData?.photoURL,
                gymImage: false,
                tag: UniqueKey().toString(),
              ),
              title: applicationState.loggedIn
                  ? Text(appLocalizations.yourAccount)
                  : Text(appLocalizations.noAccount),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  applicationState.loggedIn
                      ? AutoSizeText(
                          applicationState.userData?.displayName ??
                              'Loading...',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )
                      : !applicationState.loading
                          ? AutoSizeText(
                              appLocalizations.tapToLogIn,
                              maxLines: 2,
                              minFontSize: 0,
                            )
                          : const AutoSizeText(
                              "Loading...",
                              maxLines: 1,
                            ),
                  Visibility(
                    visible: applicationState.loggedIn,
                    child: AutoSizeText(
                      appLocalizations.longTapMoreOptions,
                      minFontSize: 1,
                      maxLines: 1,
                    ),
                  )
                ],
              ),
              isThreeLine: applicationState.loggedIn,
              onTap: applicationState.loggedIn
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileConfig(),
                        ),
                      );
                    }
                  : !applicationState.loading
                      ? () {
                          context.push("/sign-in");
                        }
                      : null,
            ),
            onLongPressStart: (details) {
              if (applicationState.loggedIn) {
                showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                        details.globalPosition.dx,
                        details.globalPosition.dy,
                        details.globalPosition.dx,
                        details.globalPosition.dy),
                    items: [
                      PopupMenuItem(
                        child: IconText(
                            icon: const Icon(Icons.exit_to_app),
                            text: appLocalizations.logOut),
                        onTap: () {
                          applicationState
                              .updateNotificationToken(false)
                              .then((_) {
                            applicationState.signOut();
                          });
                          context.go('/');
                        },
                      ),
                    ]);
              }
            },
          )
        : const Center(
            child: CircularProgressIndicator.adaptive(),
          );
  }
}
