import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/firebase/auth/loginscreen.dart';
import 'package:gymapp/navigation/widgets/icongoroute.dart';
import 'package:gymapp/pages/help/help.dart';
import 'package:gymapp/pages/home_page/homepage.dart';
import 'package:gymapp/pages/gyms_page/gyms_list.dart';
import 'package:gymapp/pages/settings/settings.dart';
import 'package:gymapp/pages/suggestion.dart/suggestion.dart';

final List<GoRoute> routes = [
  IconGoRoute(
    path: "/",
    builder: (context, state) => const HomePage(),
    icon: const Icon(Icons.home),
    name: "Home Page",
    mustBeLoggedIn: false,
    routes: [
      GoRoute(
        path: "sign-in",
        builder: (context, state) => const LoginScreen(),
        routes: [
          GoRoute(
            path: 'forgot-password',
            builder: (context, state) {
              final arguments = state.uri.queryParameters;
              return ForgotPasswordScreen(
                email: arguments['email'],
                headerMaxExtent: 200,
              );
            },
          ),
        ],
      ),
    ],
  ),
  IconGoRoute(
    path: "/my-gym",
    mustBeLoggedIn: true,
    builder: (context, state) => const MyGyms(),
    icon: const Icon(Icons.fitness_center),
    name: "My Gyms",
  ),
  IconGoRoute(
    path: '/help',
    mustBeLoggedIn: false,
    builder: (context, state) => const Help(),
    icon: const Icon(Icons.help),
    name: 'Help',
  ),
  IconGoRoute(
    path: '/suggestion',
    builder: (context, state) => const Suggestion(),
    icon: const Icon(Icons.lightbulb),
    mustBeLoggedIn: true,
    name: 'Send a Suggestion',
  ),
  IconGoRoute(
    path: '/settings',
    builder: (context, state) => const LocalSettings(),
    icon: const Icon(Icons.settings),
    mustBeLoggedIn: false,
    name: 'Settings',
  ),
];
final GoRouter goRouter = GoRouter(
  routes: routes,
);
