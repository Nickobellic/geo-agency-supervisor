import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:geo_agency_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() {
  testWidgets('Successful Authentication Test (Mobile)', (tester) async{

    await tester.pumpWidget(ProviderScope(child: MyApp())); // Launches the App

    await tester.pump(new Duration(seconds: 3));

    final usernameField = find.byKey(const Key('textField_username_mob'));
    final passwordField = find.byKey(const Key('textField_password_mob'));
    final loginButton = find.byKey(const Key('textField_submit_mob'));

    expect(find.text("Login"), findsOneWidget);

    expect(find.text("Username").first, findsOneWidget, reason: 'Username Label Found');
    expect(usernameField, findsOneWidget, reason: "Username Text Field Found");

    expect(find.text("Password").first, findsOneWidget, reason: 'Password Label Found');
    expect(passwordField, findsOneWidget, reason: "Password Text Field Found");

    expect(loginButton, findsOneWidget, reason: "Login Submit Button Found");


    await tester.enterText(usernameField, "nithish@gmail.com");
    await tester.enterText(passwordField, "nithish");
    await tester.tap(loginButton);

    await tester.pumpAndSettle(const Duration(seconds: 2));

    final successImg = find.byKey(const Key('login_success_img_mob'));
    final snackbarMob = find.byKey(const Key('login_snackbar_mob'));
    
    expect(successImg, findsOneWidget, reason: "Authentication Success image appears");
    expect(find.text("Authenticated Successfully").first, findsOneWidget, reason: "Authentication success message appears");
    expect(snackbarMob, findsOneWidget, reason: "Snackbar gets displayed");

    await tester.pumpAndSettle(const Duration(seconds: 2));


  });

  testWidgets('Failed Authentication Test (Mobile)', (tester) async{

    await tester.pumpWidget(ProviderScope(child: MyApp())); // Launches the App

    await tester.pump(new Duration(seconds: 3));

    final usernameField = find.byKey(const Key('textField_username_mob'));
    final passwordField = find.byKey(const Key('textField_password_mob'));
    final loginButton = find.byKey(const Key('textField_submit_mob'));

    expect(find.text("Login"), findsOneWidget);

    expect(find.text("Username").first, findsOneWidget, reason: 'Username Label Found');
    expect(usernameField, findsOneWidget, reason: "Username Text Field Found");

    expect(find.text("Password").first, findsOneWidget, reason: 'Password Label Found');
    expect(passwordField, findsOneWidget, reason: "Password Text Field Found");

    expect(loginButton, findsOneWidget, reason: "Login Submit Button Found");


    await tester.enterText(usernameField, "noah@gmail.com");
    await tester.enterText(passwordField, "nithish");
    await tester.tap(loginButton);

    await tester.pumpAndSettle(const Duration(seconds: 2));

    final failureImg = find.byKey(const Key('login_failure_img_mob'));
    final snackbarMob = find.byKey(const Key('login_snackbar_mob'));
    
    expect(failureImg, findsOneWidget, reason: "Authentication Failure image appears");
    expect(find.text("Unauthorized User").first, findsOneWidget, reason: "Authentication failure message appears");
    expect(snackbarMob, findsOneWidget, reason: "Snackbar gets displayed");

    await tester.pumpAndSettle(const Duration(seconds: 2));


  });
}