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

  List<double> getParticularAgentLocation(int agent_id){
    try {
      talker.info("Initiating Agent $agent_id's position fetch");
      List<Agent> thatAgentLocation = agentData.availableAgents.where((agent) => agent.agentID == agent_id).toList();
      talker.info("Agent $agent_id's position fetched");
      return thatAgentLocation[0].position;
    } catch(e) {  
      talker.error("Error in fetching Agent $agent_id's Location: $e.toString()");
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
