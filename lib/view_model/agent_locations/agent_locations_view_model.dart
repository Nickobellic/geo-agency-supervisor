import 'package:flutter/material.dart';
import 'package:geo_agency_mobile/service/agent_locations/agent_location_service.dart';
import 'package:geo_agency_mobile/service/service_locator.dart';
import 'package:geo_agency_mobile/utils/ResponseHandler.dart';
import 'package:geo_agency_mobile/utils/Globals.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod/riverpod.dart';
import 'package:geo_agency_mobile/view_model/agent_locations/agent_locations_view_model.dart';
import 'package:geo_agency_mobile/view_model/agent_locations/agent_locations_view_model_abstract.dart';

final agentLocationVMProvider = Provider<AgentLocationsViewModelImpl>((ref) {
  return container<AgentLocationsViewModelImpl>();
});

class AgentLocationsViewModelImpl extends AgentLocationsViewModel{


  final AgentLocationService agentLocationService;
  AgentLocationsViewModelImpl({required this.agentLocationService});
  
  // Get All Agent's Information
  @ResponseHandler()
  Map<int, dynamic> getAgentInfo() {
    try {
      Map<int, dynamic> agentDetails = agentLocationService.retrieveAgentInfo();
      //showSnackbar("Agent Details Obtained Successfully");
      return agentDetails;
    } catch(e) {
      //showSnackbar("Error in getting Agent Details: $e.toString()");
      return {};
    }
  }

  // Find Center of the Initial Map Render
  LatLng findCenter() {
    try {
      final agentDetails = agentLocationService.getLatLonMean();
      return LatLng(agentDetails[0], agentDetails[1]);
    } catch(e) {
      return LatLng(12.50, 80.00);
    }
  }

  // Get Agent Location from Dropdown Label result
  List<double> getAgentLocationFromDropdownLabel(String agent_name) {
    try {
      talker.info("Initializing Agent ID fetch for Dropdown");
      final agentInfos = agentLocationService.retrieveAgentInfo();
      int foundAgentID = agentInfos.keys.firstWhere((agent_id) => agentInfos[agent_id]["name"] == agent_name, orElse: () => 0);
      talker.info("Agent ID retrieved for Dropdown successfully");

      talker.info("Retrieving position of the Agent");
      List<double> agentPosition = agentInfos[foundAgentID]["position"];

      return agentPosition;
    } catch(e) {
      talker.error("Error in fetching Agent ID from Dropdown Label: $e.toString()");
      return [];
    }
  }

  // Create markers for agents
  Future<Set<Marker>> createMarkers() async{
        try {
        final agentInfos = agentLocationService.retrieveAgentInfo();
          //final customImage = await BitmapDescriptor.fromAssetImage(
         //ImageConfiguration(devicePixelRatio: 2.5),
         //'assets/images/agent_icon.png');
        Set<Marker> markerList = {};

        agentInfos.forEach((key, value) {
          final LatLng latAndLon = LatLng(value["position"][0], value["position"][1]);
          markerList.add(
            Marker(
              markerId: MarkerId(value["name"]),
              position: latAndLon,
              infoWindow: InfoWindow(
                title: value["name"],
                snippet: "$key"
              )
              //icon: customImage
            )
          );
        });

        return markerList;
        } catch(e) {
          return {};
        }
  }

  // Update first Agent's Location in map
  void updateFirstAgentLocation() {
    try {
      final thatAgentLocation = agentLocationService.retrieveLatLons();
      agentLocationService.updateLocation(1001, thatAgentLocation[1]);
    } catch(e) {
      talker.error("Error in updating First Agent Location: $e.toString()");
    }
  }


  // Get Current Location of all agents
  Future<List<double>> currentLocation() async{
    try {
      final updatedLocation = await agentLocationService.getCurrentLocation();
      return updatedLocation; 
    } catch(e) {
      talker.error("Error in getting Current Location: $e.toString()");
      return [];
    }
  }
}