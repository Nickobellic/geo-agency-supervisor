import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ip_geolocation/ip_geolocation.dart';


class PayloadHelper {
  
  static Future<Map<String, dynamic>> getDeviceInfo() async{
    final deviceInfoPlugin = DeviceInfoPlugin();
    if(kIsWeb) {
      WebBrowserInfo browserInfo = await deviceInfoPlugin.webBrowserInfo;
      dynamic browserName = browserInfo.browserName.name;
      dynamic platform = browserInfo.platform;
      return {"type": "browser","browser": browserName, "platform": platform, "user-agent": browserInfo.userAgent};
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      return {"type": "android","model": androidInfo.model, "physical": androidInfo.isPhysicalDevice, "brand": androidInfo.brand };
    }

  }

  static Future<String> getIPAddress() async {
    try {
        GeolocationData ipData = await GeolocationAPI.getData();
        return ipData.ip.toString();
    } catch(error) {
      print(error);
      return "null";
    }
  }

  static Future<List> getLocationLatLong() async {
    try {
      Position locator = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      return [locator.latitude, locator.longitude];
    } catch(error) {
      return [null, null];
    }
  }

  static Future createPayload(Map<String, dynamic> requestObject,String login, String password, String taskName) async {
    Map<String, dynamic> payload = {
      "eventCode": "rqstevnt_agcy_agnt_$taskName",
      "systemCode": "agncy",
      "session": {
        "ruleConfirmation": false,
        "gpsLoc": await getLocationLatLong(),
        "ip": await getIPAddress(),
        "device": requestObject["device"],
        // "device": {"type": "browser", "token": "postman"},
        "task": taskName,
        "domain": "app.geo-daily.com"
      },
      "role": {
        "name": "agen",
        "request": {
          taskName: requestObject
        }
      }
    };
    return _prettyPrintJson(payload);
  }

  static Map<String, dynamic> parseSignInResponse(String responseJson) {
    return json.decode(responseJson);
  }

  static String _prettyPrintJson(dynamic data) {
    final dynamic parsed = json.decode(json.encode(data));
    final encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(parsed);
  }
}
