import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/widgets/profile_config/profileconfig.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ApplicationState applicationState = Provider.of<ApplicationState>(context);
    return SignInScreen(
      actions: [
        AuthStateChangeAction(
          (context, state) {
            User? user;
            if (state.runtimeType == SignedIn) {
              user = (state as SignedIn).user;
              Navigator.pop(context);
              //TODO: Do something with email verification
            } else if (state.runtimeType == UserCreated) {
              user = (state as UserCreated).credential.user;
              user!.updateDisplayName('New User');
              user.updatePhotoURL(null);
              applicationState.createUserData(
                  UserData(
                    userId: user.uid,
                    info: 'At the gym.',
                    sex: true,
                    birthDay: DateTime.now(),
                    staff: false,
                    displayName: 'New User',
                    photoURL: null,
                  ).toMap(),
                  context);
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileConfig(),
                ),
              );
            }
          },
        ),
        ForgotPasswordAction(
          (context, email) => context.push(Uri(
            path: '/sign-in/forgot-password',
            queryParameters: {'email': email},
          ).toString()),
        ),
      ],
    );
  }
}
