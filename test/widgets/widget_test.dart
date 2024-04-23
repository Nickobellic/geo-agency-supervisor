
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_agency_mobile/view/mobile/login/login_failed_mob.dart';
import 'package:geo_agency_mobile/view/mobile/login/login_mob.dart';
import 'package:geo_agency_mobile/view/mobile/login/login_success_mob.dart';
import 'package:geo_agency_mobile/view/desktop/login/login_failed_web.dart';
import 'package:geo_agency_mobile/view/desktop/login/login_success_web.dart';
import 'package:geo_agency_mobile/view/desktop/login/login_web.dart';


void main() {

  group("Testing Web Widgets" ,() {
    testWidgets('Presence of Login Screen Widgets (Web)', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: ProviderScope( child: LoginWeb() )));

    final userNameLabel = find.byKey(Key("username_web"));
    final passwordLabel = find.byKey(Key("password_web"));

    final usernameTextField = find.byKey(Key('textField_username_web'));
    final passwordTextField = find.byKey(Key('textField_password_web'));

    final submitButton = find.byKey(Key('textField_submit_web'));

    expect(userNameLabel, findsOneWidget, reason: "Username label found");
    expect(passwordLabel, findsOneWidget, reason: "Password label found");

    expect(usernameTextField, findsOneWidget, reason: "Username Text Field found");
    expect(passwordTextField, findsOneWidget, reason: "Password Text Field found");

    expect(submitButton, findsOneWidget, reason: "Login Button found");

  });

  testWidgets("Testing Login Success Screen (Web)", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ProviderScope( child: LoginSuccessWeb() )));

    final successImg = find.byKey(const Key('login_success_img_web'));
    expect(find.text("Authenticated Successfully").first, findsOneWidget, reason: "Success Message found");
    expect(successImg, findsOneWidget, reason: "Login Success Image found");
  });

  testWidgets("Testing Login Failure Screen (Web)", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ProviderScope( child: LoginFailureWeb() )));

    final failureImg = find.byKey(const Key('login_failure_img_web'));
    expect(find.text("Unauthorized User").first, findsOneWidget, reason: "Failure Message found");
    expect(failureImg, findsOneWidget, reason: "Login Failure Image found");
  });
  });


  group("Testing Mobile Widgets", () {
    testWidgets('Presence of Login Screen Widgets (Mobile)', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: ProviderScope( child: LoginMobile() )));

    final userNameLabel = find.text("Username").first;
    final passwordLabel = find.text("Password").first;

    final usernameTextField = find.byKey(Key('textField_username_mob'));
    final passwordTextField = find.byKey(Key('textField_password_mob'));

    final submitButton = find.byKey(Key('textField_submit_mob'));

    expect(userNameLabel, findsOneWidget, reason: "Username label found");
    expect(passwordLabel, findsOneWidget, reason: "Password label found");

    expect(usernameTextField, findsOneWidget, reason: "Username Text Field found");
    expect(passwordTextField, findsOneWidget, reason: "Password Text Field found");

    expect(submitButton, findsOneWidget, reason: "Login Button found");

  });

  testWidgets("Testing Login Success Screen (Mobile)", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ProviderScope( child: LoginSuccessMobile() )));

    final successImg = find.byKey(const Key('login_success_img_mob'));
    expect(find.text("Authenticated Successfully").first, findsOneWidget, reason: "Success Message found");
    expect(successImg, findsOneWidget, reason: "Login Success Image found");
  });

  testWidgets("Testing Login Failure Screen (Mobile)", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ProviderScope( child: LoginFailureMobile() )));

    final failureImg = find.byKey(const Key('login_failure_img_mob'));
    expect(find.text("Unauthorized User").first, findsOneWidget, reason: "Failure Message found");
    expect(failureImg, findsOneWidget, reason: "Login Failure Image found");
  });

  });
  }
