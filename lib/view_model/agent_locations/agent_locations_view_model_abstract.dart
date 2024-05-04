
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class AgentLocationsViewModel {
  Map<int, dynamic> getAgentInfo();
  LatLng findCenter();
  List<double> getAgentLocationFromDropdownLabel(String agent_name);
  Future<Set<Marker>> createMarkers();
  Marker? createMarkerForAgent(int agent_id);
  void updateFirstAgentLocation();
  Future<List<double>> currentLocation();
}