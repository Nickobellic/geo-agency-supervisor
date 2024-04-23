import '../../model/User.dart';
import "package:dio/dio.dart";
import 'abstract_login_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:geo_agency_mobile/helper/dio_client.dart';
import 'package:geo_agency_mobile/data/User_data.dart' as data;
import 'package:geo_agency_mobile/helper/dio_exceptions.dart';
import 'package:talker/talker.dart';
import 'package:geo_agency_mobile/utils/ResponseHandler.dart';
import 'package:flutter/material.dart';
import 'package:geo_agency_mobile/utils/Globals.dart';
// Repository -> Fetch Data from Data Source.

final LoginRepositoryRemoteProvider = Provider<LoginRepositoryRemote>(
    (_) => LoginRepositoryRemoteImpl()); // Provider for Login Repository

final errorMessageProvider = StateProvider<String>((ref) => 'Failed to get user details');


class LoginRepositoryRemoteImpl extends LoginRepositoryRemote {
  final talker = Talker();
  //@ResponseHandler //@GR  Show snackbar through the ResponseHandler -
  // Refer https://stackoverflow.com/questions/68846785/flutter-show-snackbar-without-context/68847551#68847551,
  @ResponseHandler()
  Future getUserFromApi() async {
    // Get random User detail from API through Dio
    try {
      talker.info("Initiating the API call");
      final dynamic response = await DioClient.instance
          .get("/users/2"); // Response from DioClient in Helper
      data.usersFromDB
          .add(User(response["data"]["email"], response["data"]["first_name"]));
      talker.info("User detail retrieved from API");
      return ([response["data"]["email"], response["data"]["first_name"]]);
    } on DioException catch (e) {
      // Sending Error to the Snackbar for display
      var error = DioExceptionClass.fromDioError(e);
      talker.error("User detail retrieval from API failed");
      showSnackbar(error.errorMessage);

      /*final SnackBar snackBar = SnackBar(content: Text("your snackbar message"));
      snackbarKey.currentState?.showSnackBar(snackBar);*/

      throw error.errorMessage;
    }
  }
}
