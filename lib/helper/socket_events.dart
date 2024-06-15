import 'package:geo_agency_mobile/helper/socket_connect.dart';
import 'dart:io';

void handleLocationListen(dynamic data) {
    print("Updating $data field");
  }

void checkLocation(dynamic location) {
  socket.emit("location", {
    "latitude": location["locationDetails"][0],
    "longitude": location["locationDetails"][1],
    "agentID": location["agentID"]
  });
  print("Latitude of Agent: $location['locationDetails'][0]");
  print("Longitude of Agent: $location['locationDetails'][1]");
}

void getDataForSupervisor(dynamic data) {
  print("Read by Supervisor: $data");
}
