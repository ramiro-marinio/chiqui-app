import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/firebase/auth/loginscreen.dart';
import 'package:gymapp/navigation/widgets/icongoroute.dart';
import 'package:gymapp/pages/home_page/homepage.dart';
import 'package:gymapp/pages/gyms_page/gyms_list.dart';

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
];
final GoRouter goRouter = GoRouter(
  routes: routes,
);
