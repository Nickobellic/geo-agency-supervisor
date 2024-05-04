import 'package:geo_agency_mobile/model/Agent.dart';
abstract class AgentLocationsLocalRepository {
  List<String> getAgentNames();
  List<List<double>> getAgentPositions();
  Agent? getParticularAgentDetails(int agent_id);
  List<List<double>> getAgentDeliveryLocations();
  List<bool> getAllAgentLocationSettings();
  void updateAgentLocation(int agent_id, List<double> location);
}