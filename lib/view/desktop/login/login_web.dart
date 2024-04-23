import "package:flutter/material.dart";
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../rules/login_validation.dart';
import 'package:geo_agency_mobile/view_model/talker_logger/observer.dart';
import 'package:talker/talker.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import '../../../view_model/login/login_view_model.dart';
import 'package:geo_agency_mobile/view/desktop/login/login_success_web.dart';
import 'package:geo_agency_mobile/view/desktop/login/login_failed_web.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// Login View -> User interactible UI


class LoginWeb extends HookConsumerWidget {
  // ConsumerStatefulWidget

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameControllerState = StateProvider<String>((ref) => '');
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late LoginDetailsModelImpl ldModel; // Instance of View Model defined
//  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordControllerState = useState('');
    //final observer = CrashlitycsTalkerObserver(crashlytics: _crashlytics);

    return Consumer(
      // Use Consumer to access the Provider methods
      builder: (context, ref, child) {
        final state =
            ref.watch(loginVMProvider); // Using the View Model Provider

        return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: const Text("Login (Web)"),
            ),
            body: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Username",
                            key: Key('username_label_web'),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                          SizedBox(
                              // Username Field
                              width: 300.0,
                              child: TextFormField(
                                key: const Key('textField_username_web'),
                                validator: (value) =>
                                    LoginValidation.validateTextField(
                                        value, "Username"),
                                obscureText: false,
                                controller: usernameController,
                                onChanged: (value) => ref
                                    .read(usernameControllerState.notifier)
                                    .state = value,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Center(
                                    child: Text(
                                      'Username',
                                      key: Key('username_web'),
                                    ),
                                  ),
                                ),
                              ))
                        ]),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Password',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                            key: Key("password_label"),
                          ),
                          SizedBox(
                              width: 300.0, // Password Field
                              child: TextFormField(
                                key: const Key('textField_password_web'),
                                obscureText: true,
                                controller: passwordController,
                                onChanged: (value) =>
                                    passwordControllerState.value = value,
                                validator: (value) =>
                                    LoginValidation.validateTextField(
                                        value, "Password"),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Center(
                                    child: Text(
                                      'Password',
                                      key: Key('password_web'),
                                    ),
                                  ),
                                ),
                              )),
                        ]),
                    Container(
                      margin: EdgeInsets.only(top: 50.00),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          ElevatedButton(
                            key: const Key('textField_submit_web'),
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(20.0)),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                //print(passwordController.text); // Prints Password Text in the Console
                                //print(await state.getOneFromApi()); // Sample DIO request to get User detail
                                //final state = Provider.of<loginVMProvider>(context, listen: false);
                                String username = ref
                                    .read(usernameControllerState.notifier)
                                    .state;
                                String password = passwordControllerState.value;
                                Map<String, dynamic> existingUser = await state
                                    .validateUser(username, password);
                                dynamic userInfo = await state.getUserFilledInfo(); // Read data from Shared Preference
                                //print(existingUser); // Prints the Shared Preferences
                                print("$username & $password");
                                //@GR - Show snackbar from Repo layer, use globalkey without context. Annotate with @ResponseHandler - see login_repo_remote

                                if (existingUser["valid"] == true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginSuccessWeb()),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginFailureWeb()),
                                  );
                                }
                                ref
                                    .read(usernameControllerState.notifier)
                                    .state = '';
                                passwordControllerState.value = '';
                                usernameController.clear();
                                passwordController.clear();
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                )));
      },
    );
  }
}
