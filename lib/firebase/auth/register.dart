import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/firebase/auth/continuewithgoogle.dart';
import 'package:gymapp/functions/geterrorcodes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final globalKeyFormState = GlobalKey<FormState>();
  String errorMessage = '';
  String email = '';
  String password = '';
  String repeatPassword = '';
  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    Map<String, dynamic> errorCodes = getErrorCodes(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.signUp),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: globalKeyFormState,
          child: Column(
            children: [
              Text(
                appLocalizations.signUp,
                style: const TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
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
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: appLocalizations.email,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return appLocalizations.weakpassword;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: appLocalizations.password,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onChanged: (value) {
                    repeatPassword = value;
                  },
                  validator: (value) {
                    if (value != password) {
                      return appLocalizations.passwordsNotMatch;
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: appLocalizations.repeatPassword,
                  ),
                ),
              ),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: Text(
                  appLocalizations.alreadyHaveAccount,
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
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email, password: password);
                        context.go('/');
                      } catch (error) {
                        final e = error as FirebaseAuthException;
                        setState(() {
                          errorMessage =
                              errorCodes[e.code.replaceAll(RegExp(r'-'), '')] ??
                                  e.message;
                        });
                      }
                    },
                    child: Text(appLocalizations.signUp),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Other Options',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
