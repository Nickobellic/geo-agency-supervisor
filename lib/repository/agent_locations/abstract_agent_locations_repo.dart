abstract class AgentLocationsRepository {
  List<String> getAgentNames();
  List<List<double>> getAgentPositions();
  List<double> getParticularAgentLocation(int agent_id);
  void updateAgentLocation(int agent_id, List<double> location);
}