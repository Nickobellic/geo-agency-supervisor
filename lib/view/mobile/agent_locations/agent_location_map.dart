import 'dart:async';
import 'package:geo_agency_mobile/view_model/agent_locations/agent_locations_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AgentLocationMapMobile extends HookConsumerWidget {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(12.50, 80.00);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    //_controller.animateCamera(CameraUpdate.newLatLngBounds(_bounds(markers), 50));

  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final agentLocations = ref.watch(agentLocationVMProvider);

        final agentInfos = agentLocations.getAgentInfo();
        Set<Marker> markerList = {};
        List<LatLng> latLongs = [];

        agentInfos.forEach((key, value) {
          final LatLng latAndLon = LatLng(value[0], value[1]);
          markerList.add(
            Marker(
              markerId: MarkerId(key),
              position: latAndLon
            )
          );
          latLongs.add(latAndLon);
        });


        return Scaffold(
        appBar: AppBar(
          title: Text('Agents'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          markers: markerList,
        ),
      );
      },
    );
}
}