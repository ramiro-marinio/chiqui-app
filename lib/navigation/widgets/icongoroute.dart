import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IconGoRoute extends GoRoute {
  final Widget icon;
  IconGoRoute({
    required super.path,
    required super.builder,
    required this.icon,
    super.name,
    super.onExit,
    super.redirect,
    super.routes,
    super.pageBuilder,
    super.parentNavigatorKey,
  });
}
