import 'dart:async';

import 'package:geo_agency_mobile/model/Agent.dart';
import 'package:geo_agency_mobile/repository/agent_locations/agent_locations_local.dart';
import 'package:geo_agency_mobile/repository/location(agent)/location_agent_remote.dart';
import 'package:geo_agency_mobile/utils/Globals.dart';
import 'package:riverpod/riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geo_agency_mobile/service/service_locator.dart';

final agentLocationServiceProvider = Provider<LocationAgentService>((ref) {
  return container<LocationAgentService>();
});

class LocationAgentService {
  final LocationAgentRemoteImpl remoteRep;
  final AgentLocationsLocalImpl singleAgentLocationLocal;

  LocationAgentService(
      {required this.remoteRep, required this.singleAgentLocationLocal});

  List<double> getYourDeliveryLocation(int agent_id) {
    try {
      Agent? agentDetail =
          singleAgentLocationLocal.getParticularAgentDetails(agent_id);

      List<double> agentDeliveryDestination = agentDetail!.deliveryPosition;

      return agentDeliveryDestination;
    } catch (e) {
      talker.error(
          "Error in getting Delivery Location for Agent ID $agent_id in View Model");
      return [];
    }
  }

  Future getPolylineJSONData(
      List<double> source, List<double> destination) async {
    try {
      final dynamic result =
          await remoteRep.getPolylineData(source, destination);
      print("From service ");
      print(result);
      return result;
    } catch (e) {
      talker.error(
          "Error in getting Polyline JSON data from Service: $e.toString()");
      throw e.toString();
    }
  }

  Future<double> getRemainingDistance(
      List<double> start, List<double> end) async {
    try {
      talker.info("Retrieving remaining distance calculation from service");
      double distance =
          await Geolocator.distanceBetween(start[0], start[1], end[0], end[1]);
      talker.info("Distance calculated successfully");
      return distance;
    } catch (e) {
      talker.error(
          "Error in getting remaining distance from service: $e.toString()");
      return 0.00;
    }
  }
}
