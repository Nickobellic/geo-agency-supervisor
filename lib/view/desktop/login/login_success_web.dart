import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class LoginSuccessWeb extends HookWidget {
  const LoginSuccessWeb({super.key});

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
              image: const AssetImage('assets/images/auth_success.jpg'),
              key: Key('login_success_img_web'),)
              ,) 
,
          )
          ,Center(
        child: Text("Authenticated Successfully", 
        style: TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold),),
      )
        ],)
      
       
    );
  }
}