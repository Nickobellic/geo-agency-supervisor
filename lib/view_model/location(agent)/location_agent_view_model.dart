import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_agency_mobile/service/agent_locations/agent_location_service.dart';
import 'package:geo_agency_mobile/service/location(agent)/location_agent_service.dart';
import 'package:geo_agency_mobile/service/service_locator.dart';
import 'package:geo_agency_mobile/utils/ResponseHandler.dart';
import 'package:geo_agency_mobile/utils/Globals.dart';
import 'package:geo_agency_mobile/view/desktop/agent_chat/Chat_Web.dart';
import 'package:geo_agency_mobile/view/mobile/agent_chat/Chat.dart';
import 'package:geo_agency_mobile/view_model/location(agent)/abstract_location_agent.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod/riverpod.dart';
import 'package:geo_agency_mobile/helper/google_map/marker_helper.dart';
import 'package:geo_agency_mobile/view_model/agent_locations/agent_locations_view_model.dart';
import 'package:geo_agency_mobile/view_model/agent_locations/agent_locations_view_model_abstract.dart';

final locationAgentVMProvider = Provider<LocationAgentViewModelImpl>((ref) {
  return container<LocationAgentViewModelImpl>();
});

class LocationAgentViewModelImpl extends LocationsAgentViewModel {
  final LocationAgentService locAgentService;

  LocationAgentViewModelImpl({required this.locAgentService});

  List<double> getAgentDeliveryLocation(int agent_id) {
    try {
      final yourDeliveryLocation =
          locAgentService.getYourDeliveryLocation(agent_id);

      return yourDeliveryLocation;
    } catch (e) {
      talker.error(
          "Error in obtaining delivery location for Agent ID $agent_id in View Model");
      return [];
    }
  }

  Future<List<LatLng>> createLineStringsForPolyline(
      List<double> source, List<double> dest) async {
    try {
      print("Source $source Dest $dest");
      final polylineData =
          await locAgentService.getPolylineJSONData(source, dest);

      final lsData = polylineData['features'][0]['geometry']['coordinates'];

      print("here bro $lsData");

      List<LatLng> polyPoints = [];

      for (int line = 0; line < lsData.length; line++) {
        polyPoints.add(LatLng(lsData[line][1], lsData[line][0]));
      }

      return polyPoints;
    } catch (e) {
      talker.error(
          "Error in creating Polyline Strings from View Model: $e.toString()");
      return Future.value([]);
    }
  }
}
