import 'package:flutter/material.dart';
import 'package:talker/talker.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void redirectToAnotherWidget(Widget widget) {
  navigatorKey.currentState?.push(MaterialPageRoute(
    builder: (context) => widget,
  ));
}


final talker = Talker();
