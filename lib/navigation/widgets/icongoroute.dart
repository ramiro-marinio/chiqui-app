import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IconGoRoute extends GoRoute {
  final Widget icon;
  final bool mustBeLoggedIn;
  IconGoRoute({
    required super.path,
    required super.builder,
    required this.icon,
    required this.mustBeLoggedIn,
    super.name,
    super.onExit,
    super.redirect,
    super.routes,
    super.pageBuilder,
    super.parentNavigatorKey,
  });
}
