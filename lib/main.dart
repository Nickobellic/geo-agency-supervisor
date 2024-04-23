import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geo_agency_mobile/firebase_options.dart';
import 'package:geo_agency_mobile/view/desktop/login/login_web.dart';
import 'view/mobile/login/login_mob.dart';
import 'package:talker/talker.dart';
import 'package:geo_agency_mobile/utils/Globals.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geo_agency_mobile/service/service_locator.dart' as service_locator;

void main() async{

  try {
    /*
    WidgetsFlutterBinding.ensureInitialized(); 
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);*/
    await service_locator.main();
    runApp(
    ProviderScope(  // Wrap MyApp() with Provider Scope to use Provider inside App
      child: MyApp()
    )
    );
  } catch(e) {
    print("Failed to initialize Firebase: $e");
  }

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: MainPage.platformSpecificUI(context),
      scaffoldMessengerKey: snackbarKey,
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage {
  static Widget platformSpecificUI(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.android) {
      return LoginMobile(); // Mobile Widget
    } else {
      return  LoginWeb(); // Web Widget
    }
  }
}