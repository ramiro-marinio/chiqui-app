import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/main.dart';

StreamSubscription? wifiHandler;
void handleWifi(result) {
  if (result == ConnectivityResult.none) {
    globalKeyNavState.currentContext!.push('/no-connection');
  } else {
    globalKeyNavState.currentContext!.pushReplacement('/');
  }
}
