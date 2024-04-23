import "package:flutter/material.dart";
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginFailureMobile extends HookWidget {
  const LoginFailureMobile({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Status'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0.0,80.0,0,30.0),
            width: 400.0,
            height: 300.0,
            child: Center(
              child:             Image(
                key: Key('login_failure_img_mob'),
              image: const AssetImage('assets/images/auth_fail.jpg'),)
              ,) 
,
          )
          ,Center(
        child: Text("Unauthorized User", 
        style: TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold),),
      )
        ],)
      
       
    );
  }
}