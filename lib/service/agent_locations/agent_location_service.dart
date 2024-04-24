import 'package:geo_agency_mobile/repository/agent_locations/agent_locations_local.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geo_agency_mobile/utils/Globals.dart';
import 'package:riverpod/riverpod.dart';
import 'package:geo_agency_mobile/service/service_locator.dart';

final agentLocationServiceProvider = Provider<AgentLocationService>((ref) {
  return container<AgentLocationService>();
});

class AgentLocationService {
  final AgentLocationsLocalImpl localRep;

  AgentLocationService({required this.localRep});

  Map<String, dynamic> retrieveAgentInfo() {
    try {
        final agentNames = localRep.getAgentNames();
        final agentPositions = localRep.getAgentPositions();

        Map<String, dynamic> detailsMap = {};
        talker.info("Retrieving Agents Info");
        for(int agents=0; agents<agentNames.length; agents++) {
          detailsMap[agentNames[agents]] = agentPositions[agents];
          }
        talker.info("Agents Info retrieved successfully");
        return detailsMap;
    } catch(e) {
      talker.error("Error in retrieving Agents Info: $e.toString()");
      return {};
    }
  }

  
}