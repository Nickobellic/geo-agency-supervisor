import 'dart:async';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geo_agency_mobile/utils/Globals.dart';
import 'package:geo_agency_mobile/helper/socket_events.dart';
import 'package:geo_agency_mobile/utils/MapCenterBounds.dart' as get_center;
import 'package:geo_agency_mobile/view_model/agent_locations/agent_locations_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class SingleAgentMobile extends HookConsumerWidget {
  int myID;
  SingleAgentMobile(this.myID);
  GoogleMapController? _controller;

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    //_controller.animateCamera(CameraUpdate.newLatLngBounds(_bounds(markers), 50));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agentLocations = ref.watch(agentLocationVMProvider);
    final CompassEvent evt;
    var markerIcon = useState<Marker>(Marker(markerId: MarkerId("Dummy")));
    var deliveryMarker =
        useState<Marker>(Marker(markerId: MarkerId("Dummy Delivery Location")));
    var center = useState<LatLng>(LatLng(12.50, 80.00));
    var agentName = useState<String>("Agent");
    var agentDirection = useState<double?>(0.00);
    var locationShowEnabled = useState<bool>(false);
    var polyCoordinates = useState<Set<Polyline>>({});
    Map<PolylineId, Polyline> polylines = {};
    PolylinePoints polylinePoints = PolylinePoints();
    Size size = MediaQuery.of(context).size;
    double width = size.width * 0.75;
    double height = size.height * 0.05;
    final locationStream =
        useMemoized(agentLocations.getUpdatedcurrentLocation);

    final locationSnapshot = useStream(locationStream);

    useEffect(() {
      // Get current location of the logged in User
      void getLocation() async {
        dynamic location = await agentLocations.currentLocation();
        checkLocation({"locationDetails": location, "agent": myID});
        center.value = LatLng(location[0], location[1]);
        _controller?.animateCamera(CameraUpdate.newLatLng(center.value));
      }

      getLocation();
    });

    useEffect(() {
      if (locationSnapshot.hasData) {
        print("Updated: $locationSnapshot.data");
        final newLocation = locationSnapshot.data;
        if (newLocation != null && newLocation.isNotEmpty) {
          center.value = LatLng(newLocation[0], newLocation[1]);
          markerIcon.value = Marker(
              markerId: markerIcon.value.markerId,
              infoWindow: markerIcon.value.infoWindow,
              position: LatLng(center.value.latitude, center.value.longitude),
              icon: markerIcon.value.icon);
          _controller?.animateCamera(CameraUpdate.newLatLng(center.value));
        }
      }
    });

    useEffect(() {
      void getMarkers() async {
        Marker? yourMarker =
            await agentLocations.createMarkerForAgent(myID, "mobile");

        markerIcon.value = yourMarker!;

        // Rotate the marker according to the direction
        FlutterCompass.events?.listen((event) {
          agentDirection.value = event.heading;
        });

        markerIcon.value = Marker(
            markerId: markerIcon.value.markerId,
            infoWindow: yourMarker.infoWindow,
            position: LatLng(center.value.latitude, center.value.longitude),
            rotation: agentDirection.value ?? 0.00,
            icon: yourMarker.icon);
        //LatLng(center.value.latitude, center.value.longitude);
        String? yourName = yourMarker.infoWindow.title;
        agentName.value = yourName ?? "Agent";
        _controller?.animateCamera(CameraUpdate.newLatLng(
            center.value)); // setting that as the location
      }

      void getDeliveryMarkers() async {
        Marker? yourDeliveryMarker =
            await agentLocations.createDeliveryMarkerForAgent(myID, 'mobile');
        deliveryMarker.value = yourDeliveryMarker!;
      }

      getMarkers();
      getDeliveryMarkers();
    }, []);

    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
            appBar: AppBar(
              title: ValueListenableBuilder<String>(
                valueListenable: agentName,
                builder: (context, value, child) {
                  return Text(
                      value ?? 'Agent'); // Use a default value if value is null
                },
              ),
              backgroundColor: Colors.green[700],
            ),
            body: Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: center.value,
                    zoom: 20.0,
                  ),
                  markers: {markerIcon.value, deliveryMarker.value},
                  polylines: polyCoordinates.value,
                ),
                Positioned(
                    left: width - 130,
                    top: height + 5,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                          color: Colors.green[700],
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(15, 10))),
                      child: Text(
                        "Show Location",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    )),
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
                            agentLocations.updateAgentLocationSettings(
                                myID,
                                locationShowEnabled
                                    .value); // Updating Location settings
                          },
                        ))),
                Positioned(
                  top: height + 40,
                  left: width - 130,
                  child: ElevatedButton(
                      onPressed: () {
                        _controller?.animateCamera(CameraUpdate.newLatLng(
                            deliveryMarker.value
                                .position)); // setting that as the location
                      },
                      child: Text(
                        "Go to Delivery Location",
                        style: TextStyle(fontSize: 16.0),
                      )),
                )
              ],
            ));
      },
    );
  }
}
