
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class AgentLocationsViewModel {
  Map<String, dynamic> getAgentInfo();
  LatLng findCenter();
  Future<Set<Marker>> createMarkers();
}