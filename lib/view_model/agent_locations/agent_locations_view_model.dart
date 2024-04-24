import 'package:geo_agency_mobile/service/agent_locations/agent_location_service.dart';
import 'package:geo_agency_mobile/service/service_locator.dart';
import 'package:geo_agency_mobile/utils/ResponseHandler.dart';
import 'package:geo_agency_mobile/utils/Globals.dart';
import 'package:riverpod/riverpod.dart';
import 'package:geo_agency_mobile/view_model/agent_locations/agent_locations_view_model.dart';
import 'package:geo_agency_mobile/view_model/agent_locations/agent_locations_view_model_abstract.dart';

final agentLocationVMProvider = Provider<AgentLocationsViewModelImpl>((ref) {
  return container<AgentLocationsViewModelImpl>();
});

class AgentLocationsViewModelImpl extends AgentLocationsViewModel{


  final AgentLocationService agentLocationService;
  AgentLocationsViewModelImpl({required this.agentLocationService});
  

  @ResponseHandler()
  Map<String, dynamic> getAgentInfo() {
    try {
      Map<String, dynamic> agentDetails = agentLocationService.retrieveAgentInfo();
      //showSnackbar("Agent Details Obtained Successfully");
      return agentDetails;
    } catch(e) {
      //showSnackbar("Error in getting Agent Details: $e.toString()");
      return {};
    }
  }
}