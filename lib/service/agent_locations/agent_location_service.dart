import 'dart:async';

import 'package:geo_agency_mobile/repository/agent_locations/agent_locations_local.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geo_agency_mobile/utils/Globals.dart';
import 'package:riverpod/riverpod.dart';

import 'package:geo_agency_mobile/model/Agent.dart';
import 'package:geo_agency_mobile/service/service_locator.dart';

final agentLocationServiceProvider = Provider<AgentLocationService>((ref) {
  return container<AgentLocationService>();
});

class AgentLocationService {
  final AgentLocationsLocalImpl localRep;

  AgentLocationService({required this.localRep});

  Future<List<double>> getCurrentLocation() async{
    try {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final latitude = position.latitude;
    final longitude = position.longitude;
    return [latitude, longitude];
    } catch(e) {
      talker.error("Error in getting Current Location: $e.toString()");
      return [];
    }
  }

  Map<int, dynamic> retrieveAgentInfo() {
    try {
        final agentNames = localRep.getAgentNames();
        final agentPositions = localRep.getAgentPositions();
        final agentIDs = localRep.getAgentIDs();
        final agentLocationSettings = localRep.getAllAgentLocationSettings();
        final agentDeliveryLocations = localRep.getAgentDeliveryLocations();

        Map<int, dynamic> detailsMap = {};
        talker.info("Retrieving Agents Info");
        for(int agents=0; agents<agentNames.length; agents++) {
          detailsMap[agentIDs[agents]] = {
            "name": agentNames[agents],
            "position": agentPositions[agents],
            "location_share_enabled": agentLocationSettings[agents],
            "delivery_position": agentDeliveryLocations[agents]
          };
          }
        talker.info("Agents Info retrieved successfully");
        return detailsMap;
    } catch(e) {
      talker.error("Error in retrieving Agents Info: $e.toString()");
      return {};
    }
  }

  List<List<double>> retrieveLatLons() {
    try {
      final agentPositions = localRep.getAgentPositions();
      return agentPositions;
    }
    catch(e) {
      talker.error("Error in retrieving Agents Positions: $e.toString()");
      return [];
    }
  }

  void updateLocation(int agent_id, List<double> location) {
    try {
      final updated = localRep.updateAgentLocation(agent_id, location);
    } catch(e) {
      talker.error("Error in Updating Location: $e.toString()");
    }
  }

  Agent? getDetailOfAgent(int agent_id) {
    try {
      talker.info("Starting Agent Details fetch");
      Agent? foundAgent = localRep.getParticularAgentDetails(agent_id);
      talker.info("Sent to View Model successfully");
      return foundAgent;
    } catch(e) {
      talker.error("Error in sending Agent ID $agent_id's details: $e.toString()");
      return null;
    }
  }

  

  List<double> getLatLonMean() {
    try{
      final allPositions = localRep.getAgentPositions();
      final totalAgents = allPositions.length;
      double totalLat = 0;
      double totalLon = 0;

      talker.info("Initiating the Center point calculation");

      allPositions.forEach((agent) {
          totalLat += agent[0];
          totalLon += agent[1];
       });

       double meanLat = totalLat / totalAgents;
       double meanLon = totalLon / totalAgents;
       talker.info("Center point calculated successfully");
       return [meanLat, meanLon];

    } catch(e) {
      talker.error("Error in getting the Center Latitude: $e.toString()");
      return [12.50, 80.50];
    }
  }



  
}