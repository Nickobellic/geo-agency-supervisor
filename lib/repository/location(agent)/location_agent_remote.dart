import 'dart:convert';

import 'package:geo_agency_mobile/repository/location(agent)/abstract_location_agent_repository.dart';

import "package:dio/dio.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:geo_agency_mobile/helper/dio_client.dart';
import 'package:geo_agency_mobile/helper/dio_exceptions.dart';
import 'package:talker/talker.dart';
import 'package:geo_agency_mobile/utils/ResponseHandler.dart';
import 'package:flutter/material.dart';
import 'package:geo_agency_mobile/utils/Globals.dart';
// Repository -> Fetch Data from Data Source.

final LocationAgentRemoteProvider = Provider<LocationAgentRemote>(
    (_) => LocationAgentRemoteImpl()); // Provider for Login Repository

final errorMessageProvider =
    StateProvider<String>((ref) => 'Failed to get Polyline details');

class LocationAgentRemoteImpl extends LocationAgentRemote {
  final talker = Talker();

  @ResponseHandler()
  Future getPolylineData(List<double> startCoord, List<double> endCoord) async {
    try {
      talker.info("Initiating Polyline data fetch");

      final dioClient = DioClient(openStreetBaseUrl);
      final dynamic response = await dioClient.get(
          "$pathParam?api_key=$osm_key&start=$startCoord.toString()&end=$endCoord.toString()");

      showSnackbar("Polyline details obtained");
      return response;
    } on DioException catch (e) {
      var error = DioExceptionClass.fromDioError(e);
      talker.error("Error in obtaining polyline data: $e.toString()");
      showSnackbar(error.errorMessage);

      throw error.errorMessage;
    }
  }
}

// Repository -> Fetch Data from Data Source.