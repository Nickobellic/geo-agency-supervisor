
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class AgentLocationsViewModel {
  Map<int, dynamic> getAgentInfo();
  LatLng findCenter();
  List<double> getAgentLocationFromDropdownLabel(String agent_name);
  Future<Set<Marker>> createMarkers(String device);
  Marker? createMarkerForAgent(int agent_id);
  Future<Marker>? createDeliveryMarkerForAgent(int agent_id);
  bool getAgentLocationSharingSettings(int agent_id);
  void updateFirstAgentLocation();
  void updateAgentLocationSettings(int agent_id, bool settings);
  Future<List<double>> currentLocation();
}