import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_agency_mobile/service/agent_locations/agent_location_service.dart';
import 'package:geo_agency_mobile/service/service_locator.dart';
import 'package:geo_agency_mobile/utils/ResponseHandler.dart';
import 'package:geo_agency_mobile/utils/Globals.dart';
import 'package:geo_agency_mobile/view/desktop/agent_chat/Chat_Web.dart';
import 'package:geo_agency_mobile/view/mobile/agent_chat/Chat.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod/riverpod.dart';
import 'package:geo_agency_mobile/helper/google_map/marker_helper.dart';
import 'package:geo_agency_mobile/view_model/agent_locations/agent_locations_view_model.dart';
import 'package:geo_agency_mobile/view_model/agent_locations/agent_locations_view_model_abstract.dart';

final agentLocationVMProvider = Provider<AgentLocationsViewModelImpl>((ref) {
  return container<AgentLocationsViewModelImpl>();
});

class AgentLocationsViewModelImpl extends AgentLocationsViewModel {
  final AgentLocationService agentLocationService;
  AgentLocationsViewModelImpl({required this.agentLocationService});

  // Get All Agent's Information
  @ResponseHandler()
  Map<int, dynamic> getAgentInfo() {
    try {
      Map<int, dynamic> agentDetails = agentLocationService.retrieveAgentInfo();

      Map<int, dynamic> filteredAgents = {};

      for (var key in agentDetails.keys) {
        if (agentDetails[key]["location_share_enabled"] == true) {
          filteredAgents[key] = agentDetails[key];
        }
      }

      //showSnackbar("Agent Details Obtained Successfully");
      return filteredAgents;
    } catch (e) {
      //showSnackbar("Error in getting Agent Details: $e.toString()");
      return {};
    }
  }

  // Find Center of the Initial Map Render
  LatLng findCenter() {
    try {
      final agentDetails = agentLocationService.getLatLonMean();
      return LatLng(agentDetails[0], agentDetails[1]);
    } catch (e) {
      return LatLng(12.50, 80.00);
    }
  }

  // Get Agent Location from Dropdown Label result
  List<double> getAgentLocationFromDropdownLabel(String agent_name) {
    try {
      talker.info("Initializing Agent ID fetch for Dropdown");
      final agentInfos = agentLocationService.retrieveAgentInfo();
      int foundAgentID = agentInfos.keys.firstWhere(
          (agent_id) => agentInfos[agent_id]["name"] == agent_name,
          orElse: () => 0);
      talker.info("Agent ID retrieved for Dropdown successfully");

      talker.info("Retrieving position of the Agent");
      List<double> agentPosition = agentInfos[foundAgentID]["position"];

      return agentPosition;
    } catch (e) {
      talker.error(
          "Error in fetching Agent ID from Dropdown Label: $e.toString()");
      return [];
    }
  }

  // Create markers for agents
  Future<Set<Marker>> createMarkers(String device) async {
    try {
      final agentInfos = agentLocationService.retrieveAgentInfo();
      Map<int, dynamic> filteredAgents = {};

      for (var key in agentInfos.keys) {
        if (agentInfos[key]["location_share_enabled"] == true) {
          filteredAgents[key] = agentInfos[key];
        }
      }

      var desktopIcon, mobileIcon;

      final asset = await rootBundle.load('assets/images/agent_icon.jpg');
      if (device == "desktop") {
        final Uint8List markerIcoenter =
            await getBytesFromCanvas(30, 30, asset.buffer.asUint8List());
        desktopIcon = BitmapDescriptor.fromBytes(markerIcoenter);
      } else {
        final Uint8List markerIcoenter =
            await getBytesFromCanvas(100, 80, asset.buffer.asUint8List());
        mobileIcon = BitmapDescriptor.fromBytes(markerIcoenter);
      }
      //final customImage = await BitmapDescriptor.fromAssetImage(
      //ImageConfiguration(devicePixelRatio: 2.5),
      //'assets/images/agent_icon.png');
      Set<Marker> markerList = {};

      filteredAgents.forEach((key, value) {
        final LatLng latAndLon =
            LatLng(value["position"][0], value["position"][1]);
        markerList.add(Marker(
            markerId: MarkerId(value["name"]),
            position: latAndLon,
            icon: desktopIcon ?? mobileIcon,
            onTap: () {
              print("Redirecting to " + value["name"] + "'s chat");
              if (device == "mobile") {
                redirectToAnotherWidget(ChatToAgentMobile(value["name"]));
              } else {
                redirectToAnotherWidget(ChatToAgentWeb(value["name"]));
              }
            },
            infoWindow: InfoWindow(
              title: value["name"],
              snippet: "$key",
            )
            //icon: customImage
            ));
      });

      return markerList;
    } catch (e) {
      return {};
    }
  }

  Future<Marker>? createMarkerForAgent(int agent_id, String device) async {
    try {
      final thatAgentDetails = agentLocationService.getDetailOfAgent(agent_id);
      double latitude = thatAgentDetails!.position[0];
      double longitude = thatAgentDetails.position[1];
      String? agentName = thatAgentDetails.agentName;

      var desktopIcon, mobileIcon;
      final asset = await rootBundle.load('assets/images/agent_icon.jpg');
      if (device == "desktop") {
        final Uint8List markerIcoenter =
            await getBytesFromCanvas(30, 30, asset.buffer.asUint8List());
        desktopIcon = BitmapDescriptor.fromBytes(markerIcoenter);
      } else {
        final Uint8List markerIcoenter =
            await getBytesFromCanvas(100, 80, asset.buffer.asUint8List());
        mobileIcon = BitmapDescriptor.fromBytes(markerIcoenter);
      }

      Marker thatAgentMarker = Marker(
          markerId: MarkerId("$agent_id"),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: agentName ?? 'Agent',
          ),
          icon: desktopIcon ?? mobileIcon);

      return thatAgentMarker;
    } catch (e) {
      talker.error(
          "Error in creating Marker for Agent ID $agent_id: $e.toString()");
      return Future.value(null);
    }
  }

  Future<Marker>? createDeliveryMarkerForAgent(
      int agent_id, String device) async {
    try {
      final thatAgentDetails = agentLocationService.getDetailOfAgent(agent_id);
      double latitude = thatAgentDetails!.deliveryPosition[0];
      double longitude = thatAgentDetails.deliveryPosition[1];

      var desktopIcon, mobileIcon;

      final asset = await rootBundle.load('assets/images/delivery_icon.png');

      if (device == "desktop") {
        final Uint8List markerIcoenter =
            await getBytesFromCanvas(30, 30, asset.buffer.asUint8List());
        desktopIcon = BitmapDescriptor.fromBytes(markerIcoenter);
      } else {
        final Uint8List markerIcoenter =
            await getBytesFromCanvas(100, 80, asset.buffer.asUint8List());
        mobileIcon = BitmapDescriptor.fromBytes(markerIcoenter);
      }

      Marker thatAgentDeliveryMarker = Marker(
          markerId: MarkerId("$agent_id-delivery"),
          position: LatLng(latitude, longitude),
          icon: desktopIcon ?? mobileIcon,
          infoWindow: InfoWindow(title: "Delivery Location of $agent_id"));

      return thatAgentDeliveryMarker;
    } catch (e) {
      talker.error(
          "Error in creating Marker for Agent ID $agent_id: $e.toString()");
      return Future.value(null);
    }
  }

  bool getAgentLocationSharingSettings(int agent_id) {
    try {
      final agentDetails = agentLocationService.getDetailOfAgent(agent_id);
      talker.info("Fetching Agent Location Sharing Settings");
      bool locationSettings = agentDetails!.showLocation;
      talker.info("Agent Location Sharing Settings fetched");
      return locationSettings;
    } catch (e) {
      talker.error("Error in getting Location Sharing Settings: $e.toString()");
      return false;
    }
  }

  void updateAgentLocationSettings(int agent_id, bool settings) {
    try {
      final agentDetails = agentLocationService.getDetailOfAgent(agent_id);
      talker.info("Updating Agent Location settings");
      agentDetails!.showLocation = settings;
      talker.info("Agent Location settings updated successfully");
    } catch (e) {
      talker.error("Error in updating Agent Location Settings: $e.toString()");
    }
  }

  // Update first Agent's Location in map
  void updateFirstAgentLocation() {
    try {
      final thatAgentLocation = agentLocationService.retrieveLatLons();
      agentLocationService.updateLocation(1001, thatAgentLocation[1]);
    } catch (e) {
      talker.error("Error in updating First Agent Location: $e.toString()");
    }
  }

  // Get Current Location of all agents
  Future<List<double>> currentLocation() async {
    try {
      final location = await agentLocationService.getCurrentLocation();
      return location;
    } catch (e) {
      talker.error("Error in getting Current Location: $e.toString()");
      return [];
    }
  }

  Stream<List<double>> getUpdatedcurrentLocation() {
    try {
      final updatedLocation = agentLocationService.getLocationUpdates();
      return updatedLocation;
    } catch (e) {
      talker.error("Error in getting Updated Location: $e.toString()");
      return Stream.empty();
    }
  }
}
