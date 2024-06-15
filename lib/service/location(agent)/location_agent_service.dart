import 'dart:async';

import 'package:geo_agency_mobile/repository/location(agent)/location_agent_remote.dart';
import 'package:geo_agency_mobile/utils/Globals.dart';
import 'package:riverpod/riverpod.dart';

import 'package:geo_agency_mobile/service/service_locator.dart';

final agentLocationServiceProvider = Provider<LocationAgentService>((ref) {
  return container<LocationAgentService>();
});

class LocationAgentService {
  final LocationAgentRemoteImpl remoteRep;

  LocationAgentService({required this.remoteRep});

  Future getPolylineJSONData(
      List<double> source, List<double> destination) async {
    try {
      final dynamic result =
          await remoteRep.getPolylineData(source, destination);

      return result;
    } catch (e) {
      talker.error(
          "Error in getting Polyline JSON data from Service: $e.toString()");
      throw e.toString();
    }
  }
}
