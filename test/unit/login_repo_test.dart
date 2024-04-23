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
  LoginRepositoryLocalImpl? loginLocalRep;
  LoginRepositoryRemoteImpl? loginRemoteRep;
  LoginDetailsModelImpl? loginVM;
  final dio = Dio();
  final dioAdapter = DioAdapter(dio: DioClient.instance.dio);
  dio.httpClientAdapter = dioAdapter;


  setUpAll(() {
    loginLocalRep = LoginRepositoryLocalImpl();
    loginRemoteRep = LoginRepositoryRemoteImpl();
  });

  // Group 1
  group("Login Repo Local Tests - ", () {
        test("Gets the Usernames from the List", () {

    expect(loginLocalRep!.getUsernames(), isA<List<String>>());
  }); 

        test("Gets the Password from the List", () {
    final result = loginLocalRep!.getPasswords();

    expect(result, isA<List<String>>());

  });

          // Testing Shared Preferences Methods
        test('Get data from Shared Preferences', () async {
    SharedPreferences.setMockInitialValues({
      'Username': "john.doe@example.com",
      'Password': "johnnyboy",
      'Logged_In': true,
    });   
    String sharedPrefResult = await loginLocalRep!.getLoginInfo();

    expect(sharedPrefResult, equals("From Shared Preferences => Username: john.doe@example.com Password: johnnyboy Logged In?: true"), reason: "Test to check whether Shared Preference data is ready for retrieval");

  });

  // Testing the Setup of Shared Preferences
        test('Set data to Shared Preferences', () async {
    SharedPreferences.setMockInitialValues({});

    await loginLocalRep!.saveLoginInfo("john.doe@example.com", "johnnyboy", true);

    final testPref = await SharedPreferences.getInstance();
    
    expect(testPref.getString("Username"), equals('john.doe@example.com'), reason: "Test whether Username is saved in SP");
    expect(testPref.getString("Password"), equals('johnnyboy'), reason: 'Test whether Password is saved in SP');
    expect(testPref.getBool("Logged_In"), equals(true), reason: "Test to check whether login status is saved in SP");
  });
  });


  // Group 2
  group("Login Repo Remote Tests - ", () {
      // API Mock testing
    test('Get 2nd User data from Reqres API', () async{
    dioAdapter.onGet('/users/2', (server) => server.reply(200, {
      "data": {
        "email": "janet.weaver@reqres.in",
        "first_name": "Janet",
    },

    }, delay: const Duration(seconds: 2)));

    final result = await loginRemoteRep!.getUserFromApi();
    if(result != null) {
    expect(result, isNotNull, reason: "API request is not null");
    expect(result.length, 2, reason: "Returns a list of Length 2");
    expect(result[0], isA<String>(), reason: "Returns username as string");
    expect(result[1], isA<String>(), reason: "Returns password as string");
    }
  }); 

      test('Reqres API Internal Server Error Testing', () async {
  // Set up mock response for status code 500
  dioAdapter.onGet('/users/2', (server) => server.reply(500, {
    "error": "Internal Server Error"
  }, delay: const Duration(seconds: 2)));

  // Expect the exception to be thrown
  expect(() async => await loginRemoteRep!.getUserFromApi(), throwsA("Internal server error."));
});

      test('Reqres API Unauthorized User Error Testing', () async {
  // Set up mock response for status code 500
  dioAdapter.onGet('/users/2', (server) => server.reply(401, {
    "error": "Unauthorized User"
  }, delay: const Duration(seconds: 2)));

  // Expect the exception to be thrown
  expect(() async => await loginRemoteRep!.getUserFromApi(), throwsA("Authentication failed."));
});

      test('Reqres API No Resource Error Testing', () async {
  // Set up mock response for status code 500
  dioAdapter.onGet('/users/2', (server) => server.reply(404, {
    "error": "Resource doesn't exist"
  }, delay: const Duration(seconds: 2)));

  // Expect the exception to be thrown
  expect(() async => await loginRemoteRep!.getUserFromApi(), throwsA("The requested resource does not exist."));
});

  } );


  // Test Validate Method


}