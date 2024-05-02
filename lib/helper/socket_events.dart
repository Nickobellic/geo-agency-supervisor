import 'package:geo_agency_mobile/helper/socket_connect.dart';
import 'dart:io';

void handleLocationListen(dynamic data) {
    print("Updating $data field");
  }

void checkLocation(dynamic location) {
  socket.emit("location", location);
  print("Latitude of Agent: $location[0]");
  print("Longitude of Agent: $location[1]");
}
