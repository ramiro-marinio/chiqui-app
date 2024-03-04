import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/firebase/auth/continuewithgoogle.dart';
import 'package:gymapp/functions/geterrorcodes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final globalKeyFormState = GlobalKey<FormState>();
  String errorMessage = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final errorCodes = getErrorCodes(context);
    final appLocalizations = AppLocalizations.of(context)!;
    //ApplicationState applicationState = Provider.of<ApplicationState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.logIn),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: globalKeyFormState,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autocorrect: false,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: appLocalizations.email,
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return appLocalizations.missingValue;
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return appLocalizations.invalidemail;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  obscureText: true,
                  autocorrect: false,
                  onChanged: (value) {
                    password = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return appLocalizations.missingValue;
                    }
                    if (value.length < 8) {
                      return appLocalizations.invalidPassword;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: appLocalizations.password,
                  ),
                ),
              ),
              Text(
                errorMessage,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
              GestureDetector(
                onTap: () {
                  context.push('/register');
                },
                child: Text(
                  appLocalizations.notHaveAccount,
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!globalKeyFormState.currentState!.validate()) {
                        return;
                      }
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (context.mounted) {
                          context.go('/');
                        }
                      } catch (error) {
                        if (context.mounted) {
                          final e = error as FirebaseAuthException;
                          setState(() {
                            errorMessage = errorCodes[
                                    e.code.replaceAll(RegExp(r'-'), '')] ??
                                appLocalizations.generalError;
                          });
                        }
                      }
                    },
                    child: Text(appLocalizations.logIn),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  appLocalizations.otherOptions,
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              ContinueWithGoogle(
                onTap: () async {
                  try {
                    await FirebaseAuth.instance
                        .signInWithProvider(GoogleAuthProvider());
                    if (context.mounted) {
                      context.go('/');
                    }
                  } catch (error) {
                    final e = error as FirebaseAuthException;
                    setState(() {
                      errorMessage =
                          errorCodes[e.code.replaceAll(RegExp(r'-'), '')] ?? '';
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
