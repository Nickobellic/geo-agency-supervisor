import 'dart:async';
import 'dart:typed_data';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:typed_data';
import 'dart:ui';

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
