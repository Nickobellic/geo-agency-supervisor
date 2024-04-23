import 'package:flutter_test/flutter_test.dart';
import 'package:geo_agency_mobile/repository/login/login_repo_local.dart';
import 'package:geo_agency_mobile/repository/login/login_repo_remote.dart';
import 'package:dio/dio.dart';
import 'package:geo_agency_mobile/view_model/login/login_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geo_agency_mobile/helper/dio_client.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late LoginDetailsModelImpl loginVM;


  setUpAll(() {
    LoginRepositoryLocalImpl loginLocalRep = LoginRepositoryLocalImpl();
    LoginRepositoryRemoteImpl loginRemoteRep = LoginRepositoryRemoteImpl();
    loginVM = LoginDetailsModelImpl(loginLocalRep: loginLocalRep, loginRemoteRep: loginRemoteRep);
  });
  test('Check validation status of User Login', ()async {
    final result = await loginVM.validateUser("nithish@gmail.com", "nithish");

    expect(result["valid"], equals(false));
    expect(result["message"], equals("Unauthorized User"));
  });
}