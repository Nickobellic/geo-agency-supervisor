import 'package:flutter/material.dart';
import 'package:geo_agency_mobile/repository/location(agent)/location_agent_remote.dart';
import 'package:geo_agency_mobile/repository/login/login_repo_local.dart';
import 'package:geo_agency_mobile/repository/login/login_repo_remote.dart';
import 'package:geo_agency_mobile/service/location(agent)/location_agent_service.dart';
import 'package:geo_agency_mobile/service/login/login_service.dart';
import 'package:geo_agency_mobile/service/agent_locations/agent_location_service.dart';
import 'package:geo_agency_mobile/view_model/agent_locations/agent_locations_view_model.dart';
import 'package:geo_agency_mobile/view_model/location(agent)/location_agent_view_model.dart';
import 'package:ioc_container/ioc_container.dart';
import 'package:geo_agency_mobile/repository/agent_locations/agent_locations_local.dart';
import 'package:geo_agency_mobile/view_model/login/login_view_model.dart';

late IocContainer container;

Future<void> main() async {
  final builder = IocContainerBuilder(allowOverrides: true);
  builder.add((container) => LoginRepositoryLocalImpl());
  builder.add((container) => LoginRepositoryRemoteImpl());
  builder.add((container) => LoginService(
      localRep: LoginRepositoryLocalImpl(),
      remoteRep: LoginRepositoryRemoteImpl())); // For Login Service
  builder.add((container) => LoginDetailsModelImpl(
      loginService: container<LoginService>())); // For Login View Model
  builder.add((container) => AgentLocationService(
      localRep: AgentLocationsLocalImpl())); // For Agent Location Service
  builder.add((container) => AgentLocationsViewModelImpl(
      agentLocationService:
          container<AgentLocationService>())); // For Agent Location View Model
  builder.add((container) =>
      LocationAgentService(remoteRep: LocationAgentRemoteImpl()));
  builder.add((container) => LocationAgentViewModelImpl(
      locAgentService: container<
          LocationAgentService>())); // For fetching single Agent Location
  container = builder.toContainer();

  // final loginVM = container<LoginDetailsModelImpl>(); // Way of using container
}
