import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geo_agency_mobile/repository/login/login_repo_remote.dart';
import 'package:geo_agency_mobile/helper/dio_payload_helper.dart';
import 'package:geo_agency_mobile/helper/dio_exceptions.dart';
import 'package:geo_agency_mobile/helper/dio_client.dart';
import '../../repository/login/login_repo_remote.dart';
import 'package:geo_agency_mobile/repository/login/login_repo_local.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import '../../repository/login/abstract_login_repository.dart';
import 'package:geo_agency_mobile/service/login/login_service.dart';
import 'login_view_model_abstract.dart';
import 'package:geo_agency_mobile/utils/ResponseHandler.dart';
import 'package:geo_agency_mobile/utils/Globals.dart';
import 'package:geo_agency_mobile/service/service_locator.dart';


// View Model which interacts with Login Form

final loginVMProvider = Provider<LoginDetailsModelImpl>((ref) {   // Creating provider inside View Model for accessing data in View
  return container<LoginDetailsModelImpl>();
});


//@GR - Use IOC Container ro register these and look up using service locator.
//https://pub.dev/packages/ioc_container

class LoginDetailsModelImpl extends LoginDetailsModel {

  late BuildContext context;
  final LoginService loginService;

  LoginDetailsModelImpl({required this.loginService});

  @override
  String printUser() {  // Get first User's username and password
    final userDetails = loginService.printUserDetails();
    return userDetails;
  }

  @override
  Future getOneFromApi() async {  // Call the User fetch Repository Method
    final userFromApi = loginService.getUserDetailsFromApi();
    return userFromApi;
  }

  @override
  @ResponseHandler()
  Future<Map<String, dynamic>> validateUser(String _username, String _password) async{  // Check whether they're already a member or not. Save it in shared_preferences according to the status
    try {
      final validStatus = await loginService.successLogin(_username, _password);
      final message = validStatus["message"];
      showSnackbar(message);
      return validStatus;
    } on DioException catch(e) {
      
      final networkErrorMessage = await loginService.errorLogin(_username, _password, e);
      final message = networkErrorMessage["message"];
      showSnackbar(message);
      return networkErrorMessage;
    } catch(e,stackTrace) {
      final otherErrorMessage = await loginService.errorLogin(_username, _password, e);
      final message = otherErrorMessage["message"];
      showSnackbar(message);
      return otherErrorMessage;
    }


  }

  @override
  Future getUserFilledInfo() {  // Call User's Shared Preference detail fetch Method
    return loginService.getFieldData();  
  }

}