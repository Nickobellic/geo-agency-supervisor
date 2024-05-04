import 'package:geo_agency_mobile/data/Agent_data.dart' as agentData;
import 'package:geo_agency_mobile/model/Agent.dart';
import 'package:geo_agency_mobile/repository/agent_locations/abstract_agent_locations_repo.dart';
import 'package:geo_agency_mobile/utils/Globals.dart';
import 'package:riverpod/riverpod.dart';
import 'package:geo_agency_mobile/utils/ResponseHandler.dart';

final AgentLocationLocalProvider = Provider<AgentLocationsLocalRepository>((_) => AgentLocationsLocalImpl()); // Provider for Login Repository


class AgentLocationsLocalImpl extends AgentLocationsLocalRepository {

  List<String> getAgentNames() {
    try {
      List<String> names = [];
      talker.info("Initiating Agent Names Fetch");
      agentData.availableAgents.forEach((agent) => {
        names.add(agent.agentName)
      });
      talker.info("Agent Names fetched successfully");
      return names;
    } catch(e) {
      talker.error("Error in fetching Agent Names: $e.toString()");
      return [];
    }
  }

  Agent? getParticularAgentDetails(int agent_id){
    try {
      talker.info("Initiating Agent Details fetch");
      Agent foundAgent = agentData.availableAgents.firstWhere((agent) => agent.agentID == agent_id);
      talker.info("Agent details fetched successfully");
      return foundAgent;
    } catch(e) {
      talker.error("Error in fetching Agent Details: $e.toString()");
      return null;
    }
  }

  List<int> getAgentIDs() {
    try {
      List<int> ids = [];
      talker.info("Initiating Agent ID Fetch");
      agentData.availableAgents.forEach((agent) => {
        ids.add(agent.agentID)
      });
      talker.info("Agent ID fetched successfully");
      return ids;
    } catch(e) {
      talker.error("Error in fetching Agent IDs: $e.toString()");
      return [];
    }
  }
  

  List<List<double>> getAgentPositions() {
    try {
      List<List<double>> positions = [];
      talker.info("Initiating Agent Positions Fetch");
      agentData.availableAgents.forEach((agent) => {
        positions.add(agent.position)
      });
      talker.info("Agent Positions fetched successfully");
      return positions;
    } catch(e) {
      talker.error("Error in fetching Agent Positions: $e.toString()");
      return [];
    }
  }

  List<List<double>> getAgentDeliveryLocations() {
    try {
      List<List<double>> positions = [];
      talker.info("Initiating Agent Delivery Locations Fetch");
      agentData.availableAgents.forEach((agent) => {
        positions.add(agent.deliveryPosition)
      });
      talker.info("Agent Positions fetched successfully");
      return positions;
    } catch(e) {
      talker.error("Error in fetching Agent Delivery Locations: $e.toString()");
      return [];
    }
  }

  List<bool> getAllAgentLocationSettings() {
    try {
      List<bool> settings = [];
      talker.info("Initiating Agent Settings Fetch");
      agentData.availableAgents.forEach((agent) => {
        settings.add(agent.showLocation)
      });
      talker.info("Agent Settings fetched successfully");
      return settings;
    } catch(e) {
      talker.error("Error in fetching Agent Settings: $e.toString()");
      return [];
    }
  }


  


  void updateAgentLocation(int agent_id, List<double> location) {
    try{
      talker.info("Initiating Agent $agent_id's position update");
      List<Agent> thatAgent = agentData.availableAgents.where((agent) => agent.agentID == agent_id).toList();
      int agentInfo = agentData.availableAgents.indexOf(thatAgent[0]);

      agentData.availableAgents[agentInfo].position = location;
      talker.info("Agent $agent_id's position updated successfully");

    } catch(e) {
      talker.error("Error in updating Agent $agent_id's position: $e.toString()");
    }
  }

}
