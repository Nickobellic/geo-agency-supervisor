import 'dart:async';
import 'package:geo_agency_mobile/utils/MapCenterBounds.dart' as get_center;
import 'package:geo_agency_mobile/view_model/agent_locations/agent_locations_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AgentLocationMapMobile extends HookConsumerWidget {
  Completer<GoogleMapController> _controller = Completer();

  static LatLng _center = const LatLng(12.50, 80.00);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    //_controller.animateCamera(CameraUpdate.newLatLngBounds(_bounds(markers), 50));

  }



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agentLocations = ref.watch(agentLocationVMProvider);
    var markerList = useState<Set<Marker>>({});
    

    useEffect(() {
    void createAgentMarkers() async{
      Set<Marker> markers = {};
      markers = await agentLocations.createMarkers();
      markerList.value = markers;
    }  
    createAgentMarkers();
    }, []);

    print(markerList);
    return Consumer(
      builder: (context, ref, child) {

        _center = agentLocations.findCenter();
        final agentInfos = agentLocations.getAgentInfo();
        List<LatLng> latLons = [];
        agentInfos.forEach((key, value) { 
          latLons.add(LatLng(value[0], value[1]));
        });
        
        LatLngBounds bounds = get_center.boundsFromLatLngList(latLons);

        print(bounds);
        return Scaffold(
        appBar: AppBar(
          title: Text('Agents'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 15.0,
          ),
          markers: markerList.value,
          cameraTargetBounds: CameraTargetBounds(bounds),
        ),
      );
      },
    );
}
}