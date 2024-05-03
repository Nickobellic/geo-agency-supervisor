import 'dart:async';
import 'package:geo_agency_mobile/utils/MapCenterBounds.dart' as get_center;
import 'package:geo_agency_mobile/view_model/agent_locations/agent_locations_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AgentLocationMapMobile extends HookConsumerWidget {
  GoogleMapController? _controller;


  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    //_controller.animateCamera(CameraUpdate.newLatLngBounds(_bounds(markers), 50));

  }



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agentLocations = ref.watch(agentLocationVMProvider);
    var markerList = useState<Set<Marker>>({});
    var dropdownvalue = useState<String>("Agent1");
    var center = useState<LatLng>(LatLng(12.50, 80.00));

    useEffect(() {
    void createAgentMarkers() async {
  Set<Marker> markers = {};
  markers = await agentLocations.createMarkers();

  

  // Update markerList.value with the updated markers
  markerList.value = markers;
}  
      createAgentMarkers();

    }, []);

    useEffect(() {
      void moveSecondMarker() async {

  Set<Marker> updatedMarkers = {};


  int index = 0;

  for (var marker in markerList.value) {
    if (index == 1) {
      LatLng currentPosition = marker.position;
      LatLng newPosition = LatLng(currentPosition.latitude + 0.000002, currentPosition.longitude + 0.000002);
      Marker updatedMarker = Marker(
        markerId: marker.markerId,
        position: newPosition,
        infoWindow: InfoWindow(title: marker.infoWindow.title, snippet: marker.infoWindow.snippet)
      );
      updatedMarkers.add(updatedMarker);
    } else {
      updatedMarkers.add(marker);
    }
    index++;
  }
  markerList.value = updatedMarkers;
  
      }

        Timer.periodic(Duration(seconds: 1), (timer) {
      moveSecondMarker();
    });
    });

    return Consumer(
      builder: (context, ref, child) {

        //center.value = agentLocations.findCenter();
        final agentInfos = agentLocations.getAgentInfo();
        List<LatLng> latLons = [];
        List<String> items = [];
        agentInfos.forEach((key, value) { 
          latLons.add(LatLng(value["position"][0], value["position"][1]));
          items.add(value["name"]);
        });

        LatLngBounds bounds = get_center.boundsFromLatLngList(latLons);

        return Scaffold(
        appBar: AppBar(
          title: Text('Agents'),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children:[ GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: center.value,
            zoom: 15.0,
          ),
          markers: markerList.value,
        ),
          DropdownButton<String>( 
                
              // Initial Value 
              value: dropdownvalue.value, 
                
              // Down Arrow Icon 
              icon: const Icon(Icons.keyboard_arrow_down), 
              alignment: Alignment.topRight,                
              // Array list of items 
              items: items.map((String item) { 
                return DropdownMenuItem( 
                  value: item, 
                  child: new Text(item), 
                ); 
              }).toList(), 
              // After selecting the desired option,it will 
              // change button value to selected value 
              onChanged: (newValue) {  
                print(newValue);
                dropdownvalue.value = newValue!;
                print(dropdownvalue.value);
                final thatAgentPosition = agentLocations.getAgentLocationFromDropdownLabel(dropdownvalue.value);
                print(thatAgentPosition);
                center.value = LatLng(thatAgentPosition[0], thatAgentPosition[1]);
                final thatAgentPos = markerList.value.firstWhere((marker) => marker.infoWindow.title == dropdownvalue.value).position;
                _controller?.animateCamera(CameraUpdate.newLatLng(thatAgentPos));
              }, 
            )
        ],
        )
      
      );
      },
    );
    
}
  
}