import 'dart:async';
import 'package:geo_agency_mobile/utils/Globals.dart';
import 'package:geo_agency_mobile/utils/MapCenterBounds.dart' as get_center;
import 'package:geo_agency_mobile/view_model/agent_locations/agent_locations_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';


class MyLocationWeb extends HookConsumerWidget {
  int myID;
  MyLocationWeb(this.myID);
  GoogleMapController? _controller;


  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    //_controller.animateCamera(CameraUpdate.newLatLngBounds(_bounds(markers), 50));

  }



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agentLocations = ref.watch(agentLocationVMProvider);
    var markerIcon = useState<Marker>(Marker(markerId: MarkerId("Dummy")));
    var deliveryMarker = useState<Marker>(Marker(markerId: MarkerId("Dummy Delivery Location")));
    var center = useState<LatLng>(LatLng(12.50, 80.00));
    var locationShowEnabled = useState<bool>(false);
    var polyCoordinates = useState<Set<Polyline>>({});
    Map<PolylineId, Polyline> polylines = {};
    PolylinePoints polylinePoints = PolylinePoints();
    Size size = MediaQuery.of(context).size;
    double width = size.width*0.75;
    double height = size.height*0.05;

    useEffect(() {
    void getMarkers() async {
      Marker? yourMarker = agentLocations.createMarkerForAgent(myID);
      markerIcon.value = yourMarker!;
      center.value = yourMarker.position;
      _controller?.animateCamera(CameraUpdate.newLatLng(center.value)); // setting that as the location
    }

    void getDeliveryMarkers() async {
        Marker? yourDeliveryMarker = await agentLocations.createDeliveryMarkerForAgent(myID);
        deliveryMarker.value = yourDeliveryMarker!;
    }

    _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 8,
    );
      
    }
  

    void getPolyline() async {
      List<LatLng> polylineCoordinates = [];
      Set<Polyline> polylineSet = {};

      double sourceLatitude = markerIcon.value.position.latitude;
      double sourceLongitude = markerIcon.value.position.longitude;

      double destLatitude = deliveryMarker.value.position.latitude;
      double destLongitude = deliveryMarker.value.position.longitude;
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates("AIzaSyAF_RQ5A50TjztBn9ff_dWhsVHvkM7NrDQ",
        PointLatLng(sourceLatitude, sourceLongitude), PointLatLng(destLatitude, destLongitude),
        travelMode: TravelMode.driving);

      print(result);
      int count = 0;

      if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));

        polylineSet.add(
          Polyline(
      polylineId: PolylineId("$count"),
      points: polylineCoordinates,
      width: 8,
    )
      );
      count++;
      });
    } else {
      print(result.errorMessage);
    } 
    
    }
    
    void updateSettings() {
      bool fetchedSettings = agentLocations.getAgentLocationSharingSettings(myID);
      locationShowEnabled.value = fetchedSettings;
    }

    getMarkers();
    getDeliveryMarkers();
    getPolyline();
    updateSettings();

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
          markers: {markerIcon.value, deliveryMarker.value},
          polylines: polyCoordinates.value,

        ),
        Positioned(
          left: width-130,
          top: height+5,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(
            color: Colors.green[700],
            borderRadius: BorderRadius.all(Radius.elliptical(15, 10))
          ),
          
          child: Text("Show Location", style: TextStyle(color: Colors.white, fontSize: 20.0),),
          )
        ),

        Positioned(
          left: width,
          top: height,
          child: Container(
            padding: EdgeInsets.only(left: 15.0),
          
          child: Switch(
      // This bool value toggles the switch.
      value: locationShowEnabled.value,
      activeColor: Colors.red,
      onChanged: (bool newValue) {
        locationShowEnabled.value = newValue;
        agentLocations.updateAgentLocationSettings(myID, locationShowEnabled.value); // Updating Location settings
      },
    )
          )
        ),
        Positioned(
          top: height+40,
          left: width-130,
          child: ElevatedButton(onPressed: () {
                  
                  _controller?.animateCamera(CameraUpdate.newLatLng(deliveryMarker.value.position)); // setting that as the location
          }, child: Text("Go to Delivery Location", style: TextStyle(fontSize: 16.0),)),
        )
        ],
        )
      
      );
      },
    );
    
}
  
}