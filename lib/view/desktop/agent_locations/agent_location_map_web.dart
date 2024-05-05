import 'dart:async';
import 'package:geo_agency_mobile/utils/MapCenterBounds.dart' as get_center;
import 'package:geo_agency_mobile/view_model/agent_locations/agent_locations_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AgentLocationMapWeb extends HookConsumerWidget {
  GoogleMapController? _controller;


  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    //_controller.animateCamera(CameraUpdate.newLatLngBounds(_bounds(markers), 50));

  }



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agentLocations = ref.watch(agentLocationVMProvider);
    var markerList = useState<Set<Marker>>({});
    var dropdownvalue = useState<String>(" ");
    var center = useState<LatLng>(LatLng(12.50, 80.00));
    Size size = MediaQuery.of(context).size;
    double width = size.width*0.75;
    double height = size.height*0.05;

    useEffect(() {
    void createAgentMarkers() async {
  Set<Marker> markers = {};
  markers = await agentLocations.createMarkers("desktop");

  

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

      if(dropdownvalue.value == "Agent3") {
        center.value = newPosition;
        _controller?.animateCamera(CameraUpdate.newLatLng(center.value));
      }

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
        List<String> items = [" "];
        agentInfos.forEach((key, value) { 
          
          latLons.add(LatLng(value["position"][0], value["position"][1]));
          items.add(value["name"]);
        });


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
        Positioned(
          left: width,
          top: height,
          child: Container(
            padding: EdgeInsets.only(left: 15.0),
          color: Colors.green,
          child: DropdownButton<String>( 
                
              // Initial Value 
              value: dropdownvalue.value, 
              borderRadius: BorderRadius.all(Radius.elliptical(5.0, 10.0)),
              style: TextStyle(color: Colors.white),
              dropdownColor: Colors.green,
              // Down Arrow Icon 
              icon: const Icon(Icons.keyboard_arrow_down), 
              
              
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
                
                dropdownvalue.value = newValue!;
                final thatAgentPosition = agentLocations.getAgentLocationFromDropdownLabel(dropdownvalue.value);
                center.value = LatLng(thatAgentPosition[0], thatAgentPosition[1]); // This one is taking value from the hardcoded latitude
                final thatAgentPos = markerList.value.firstWhere((marker) => marker.infoWindow.title == dropdownvalue.value).position; // This one chooses based on position of agent from map
                _controller?.animateCamera(CameraUpdate.newLatLng(thatAgentPos)); // setting that as the location
              }, 
            )
          )
        )
        ],
        )
      
      );
      },
    );
    
}
  
}