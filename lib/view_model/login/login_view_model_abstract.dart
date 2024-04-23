import 'package:flutter/widgets.dart';

abstract class LoginDetailsModel {
  String printUser();
  Future getOneFromApi();
  Future validateUser(String _user, String _pass);
  Future getUserFilledInfo();
}
