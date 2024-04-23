import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:geo_agency_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geo_agency_mobile/service/service_locator.dart' as service_locator;


// flutter drive  --driver=integration_test/login_web.dart  --target=integration_test/login_web_test.dart -d chrome 

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized(); // NEW

  testWidgets('Successful Authentication Test (Web)', (tester) async{
    await service_locator.main();
    await tester.pumpWidget(ProviderScope(child: MyApp())); // Launches the App

    await tester.pump(new Duration(seconds: 3));

    final usernameField = find.byKey(const Key('textField_username_web'));
    final passwordField = find.byKey(const Key('textField_password_web'));
    final loginButton = find.byKey(const Key('textField_submit_web'));

    expect(find.text("Login (Web)"), findsOneWidget);

    expect(find.text("Username").first, findsOneWidget, reason: 'Username Label Found');
    expect(usernameField, findsOneWidget, reason: "Username Text Field Found");

    expect(find.text("Password").first, findsOneWidget, reason: 'Password Label Found');
    expect(passwordField, findsOneWidget, reason: "Password Text Field Found");

    expect(loginButton, findsOneWidget, reason: "Login Submit Button Found");


    await tester.enterText(usernameField, "nithish@gmail.com");
    await tester.enterText(passwordField, "nithish");
    await tester.tap(loginButton);

    await tester.pumpAndSettle(const Duration(seconds: 2));

    final successImg = find.byKey(const Key('login_success_img_web'));
    final snackbarWeb = find.byKey(const Key('login_snackbar_web'));
    
    expect(successImg, findsOneWidget, reason: "Authentication Success image appears");
    expect(find.text("Authenticated Successfully").first, findsOneWidget, reason: "Authentication success message appears");
    expect(snackbarWeb, findsOneWidget, reason: "Snackbar gets displayed");

    await tester.pumpAndSettle(const Duration(seconds: 2));


  });

  testWidgets('Failed Authentication Test (Web)', (tester) async{

    await tester.pumpWidget(ProviderScope(child: MyApp())); // Launches the App

    await tester.pump(new Duration(seconds: 3));

    final usernameField = find.byKey(const Key('textField_username_web'));
    final passwordField = find.byKey(const Key('textField_password_web'));
    final loginButton = find.byKey(const Key('textField_submit_web'));

    expect(find.text("Login (Web)"), findsOneWidget);

    expect(find.text("Username").first, findsOneWidget, reason: 'Username Label Found');
    expect(usernameField, findsOneWidget, reason: "Username Text Field Found");

    expect(find.text("Password").first, findsOneWidget, reason: 'Password Label Found');
    expect(passwordField, findsOneWidget, reason: "Password Text Field Found");

    expect(loginButton, findsOneWidget, reason: "Login Submit Button Found");


    await tester.enterText(usernameField, "noah@gmail.com");
    await tester.enterText(passwordField, "nithish");
    await tester.tap(loginButton);

    await tester.pumpAndSettle(const Duration(seconds: 2));

    final failureImg = find.byKey(const Key('login_failure_img_web'));
    final snackbarWeb = find.byKey(const Key('login_snackbar_web'));
    
    expect(failureImg, findsOneWidget, reason: "Authentication Failure image appears");
    expect(find.text("Unauthorized User").first, findsOneWidget, reason: "Authentication failure message appears");
    expect(snackbarWeb, findsOneWidget, reason: "Snackbar gets displayed");

    await tester.pumpAndSettle(const Duration(seconds: 2));


  });
}