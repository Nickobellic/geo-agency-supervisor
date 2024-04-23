import 'package:flutter/material.dart';
import 'package:geo_agency_mobile/repository/login/login_repo_local.dart';
import 'package:geo_agency_mobile/repository/login/login_repo_remote.dart';
import 'package:geo_agency_mobile/service/login/login_service.dart';
import 'package:ioc_container/ioc_container.dart';
import 'package:geo_agency_mobile/view_model/login/login_view_model.dart';

late IocContainer container;

Future<void> main() async{
    final builder = IocContainerBuilder(allowOverrides: true);
    builder.add((container) => LoginRepositoryLocalImpl());
    builder.add((container) => LoginRepositoryRemoteImpl());
    builder.add((container) => LoginService(localRep: container<LoginRepositoryLocalImpl>(), remoteRep: container<LoginRepositoryRemoteImpl>()));
    builder.add((container) => LoginDetailsModelImpl(loginService: container<LoginService>()));

    container = builder.toContainer();

    // final loginVM = container<LoginDetailsModelImpl>(); // Way of using container 
}