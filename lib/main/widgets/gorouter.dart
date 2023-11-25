import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/main/widgets/icongoroute.dart';
import 'package:gymapp/pages/home_page/homepage.dart';
import 'package:gymapp/pages/gyms_page/gyms_list.dart';

final List<IconGoRoute> routes = [
  IconGoRoute(
    path: "/",
    builder: (context, state) => const HomePage(),
    icon: const Icon(Icons.home),
    name: "Home",
  ),
  IconGoRoute(
    path: "/myGym",
    builder: (context, state) => const MyGyms(),
    icon: const Icon(Icons.fitness_center),
    name: "My Gyms",
  ),
];
final GoRouter goRouter = GoRouter(
  routes: routes,
);
