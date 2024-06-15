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

final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();

void redirectToAnotherWidget(Widget widget) {
  globalNavigatorKey.currentState?.push(MaterialPageRoute(
    builder: (context) => widget,
  ));
}

const reqresBaseUrl = "https://reqres.in/api";
const openStreetBaseUrl = "https://api.openrouteservice.org/v2/directions/";
const pathParam = "driving-car";
const osm_key = "5b3ce3597851110001cf6248782887ec2e864838a30d64812b66bab9";

final talker = Talker();
