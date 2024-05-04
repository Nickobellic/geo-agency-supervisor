import 'dart:async';
import 'package:geo_agency_mobile/utils/MapCenterBounds.dart' as get_center;
import 'package:geo_agency_mobile/view_model/agent_locations/agent_locations_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyLocationMobile extends HookConsumerWidget {
  int myID;
  MyLocationMobile(this.myID);
  GoogleMapController? _controller;


  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    //_controller.animateCamera(CameraUpdate.newLatLngBounds(_bounds(markers), 50));

  }



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agentLocations = ref.watch(agentLocationVMProvider);
    var markerIcon = useState<Marker>(Marker(markerId: MarkerId("Dummy")));
    var center = useState<LatLng>(LatLng(12.50, 80.00));
    Size size = MediaQuery.of(context).size;
    double width = size.width*0.75;
    double height = size.height*0.05;

    useEffect(() {
    void getTheMarker() {
      Marker? yourMarker = agentLocations.createMarkerForAgent(myID);
      markerIcon.value = yourMarker!;
      center.value = yourMarker.position;
      _controller?.animateCamera(CameraUpdate.newLatLng(center.value)); // setting that as the location

    }

    getTheMarker();

    }, []);


    return Consumer(
      builder: (context, ref, child) {

        return Scaffold(
        appBar: AppBar(
          title: Text('Agent1'),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children:[ GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: center.value,
            zoom: 15.0,
          ),
          markers: {markerIcon.value},
        ),
        Positioned(
          left: width,
          top: height,
          child: Container(
            padding: EdgeInsets.only(left: 15.0),
          color: Colors.green,
          child: const Text("Hi")
          )
        )
        ],
        )
      
      );
      },
    );
    
}
  
}