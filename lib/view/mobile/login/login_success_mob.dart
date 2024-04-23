import "package:flutter/material.dart";
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginSuccessMobile extends HookWidget {
  const LoginSuccessMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Status'),
      ),
      body: Column(
        children: [
          Container(
            width: 400.0,
            height: 300.0,
            child: Center(
              child:             Image(
              key: Key('login_success_img_mob'),
              image: const AssetImage('assets/images/auth_success.jpg'),)
              ,) 
,
          )
          ,Container(
          margin: EdgeInsets.only(left: 70.0),
        child: Center(
          child: Text("Authenticated Successfully", 
        style: TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold),),) 
,
      )
        ],)
      
       
    );
  }
}