import 'package:dio/dio.dart';
import 'package:geo_agency_mobile/service/service_locator.dart';
import 'package:geo_agency_mobile/utils/Globals.dart';
import 'package:geo_agency_mobile/helper/dio_payload_helper.dart';
import 'package:geo_agency_mobile/repository/login/login_repo_local.dart';
import 'package:geo_agency_mobile/repository/login/login_repo_remote.dart';
import 'package:riverpod/riverpod.dart';

final loginServiceProvider = Provider<LoginService>((ref) {
  return container<LoginService>();
});

class LoginService {
    final LoginRepositoryLocalImpl localRep;
    final LoginRepositoryRemoteImpl remoteRep;

    LoginService({required this.localRep, required this.remoteRep});

    String printUserDetails() {
        return "${localRep.getUsernames().toString()} & ${localRep.getPasswords().toString()}";
    }

    Future getUserDetailsFromApi() async{
      dynamic result = await remoteRep.getUserFromApi();
      return result;
    }

    Future<Map<String, dynamic>> successLogin(String _username, String _password) async {
      talker.info("Getting Device Information");
    dynamic deviceData = await PayloadHelper.getDeviceInfo();
    Map<String, dynamic> reqDetails = {
      "login": _username,
      "password": _password,
      "device": deviceData
    };  
    talker.info("Creating payload for the Request");
    String signInPayload = await PayloadHelper.createPayload(reqDetails,_username, _password, "login");

    List<String> fetchedUsernames = localRep.getUsernames();
    List<String> fetchedPasswords = localRep.getPasswords();

    List<dynamic> usersFromApi = await remoteRep.getUserFromApi();

    fetchedUsernames.add(usersFromApi[0]);  // Adding users details from API request inside valid Users List
    fetchedPasswords.add(usersFromApi[1]);

    talker.info("Performing Validation Logic Test");
    if(fetchedUsernames.contains(_username) && fetchedPasswords.contains(_password)) {
      localRep.saveLoginInfo(_username, _password, true);  // If already a member, set logged in as true
          talker.info("Validation done");
          final message = "Authenticated Successfully";
      return {"valid": true, "message": "Authenticated Successfully"};
    } else {
      localRep.saveLoginInfo(_username, _password, false); // If it is a new member, set logged in as false
          talker.info("Validation done");
      final message = "Unauthorized User";
      return {"valid": false, "message": "Unauthorized User"};
    }
    }


    Future<Map<String, dynamic>> errorLogin(String _username, String _password, dynamic e ) async{
            int statusCode = e.response!.statusCode!;
            
      print('Status Code : $statusCode');
          dynamic deviceData = await PayloadHelper.getDeviceInfo();
           Map<String, dynamic> reqDetails = {
          "code": statusCode,
            "message": e.toString(),
          "device": deviceData
    };  
    String signInPayload = await PayloadHelper.createPayload(reqDetails,_username, _password, "error");
      if(e is DioException) {
        talker.error("Dio Error in Validation");
      final message = "Network Error: $e.message";
      return {"valid":false,"message":message};
      } else {
        talker.error("$e.toString() error in Validation");
        final message = "Error: $e.toString()";
        return {"valid":false, "message": message};
      }

    }


    Future getFieldData() {
      final data = localRep.getLoginInfo();
      return data;
    }


}