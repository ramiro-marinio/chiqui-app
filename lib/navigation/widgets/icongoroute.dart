import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IconGoRoute extends GoRoute {
  final Widget icon;
  final bool mustBeLoggedIn;
  final bool mustBeVerified;
  IconGoRoute({
    required super.path,
    required super.builder,
    required this.icon,
    this.mustBeLoggedIn = true,
    this.mustBeVerified = false,
    super.name,
    super.onExit,
    super.redirect,
    super.routes,
    super.pageBuilder,
    super.parentNavigatorKey,
  });
}
