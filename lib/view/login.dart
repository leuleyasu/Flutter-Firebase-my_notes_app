import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/Routes.dart';
import 'package:flutter_application_1/services/auth/auth_exception.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import '../utilities/ShowErrorDialog.dart';
import 'dart:developer'as developertool show log;
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: FutureBuilder(
        future: AuthService.firbase().initializeApp(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: "Email"),
                  ),
                  TextField(
                    controller: _password,
                    autocorrect: false,
                    enableSuggestions: false,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: "Password"),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        final email = _email.text;
                        final password = _password.text;
                        await AuthService.firbase()
                            .login(email: email, password: password);
                        final user = AuthService.firbase().currentUser;
                        if (user?.isEmailVerfied ?? false) {
                          if (context.mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                notesroute, (route) => false);
                          }
                        } else {
                          if (context.mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                verifyemail, (route) => false);
                          }
                        }

                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, notesroute, (route) => false);
                        }
                      } on UserNotFoundAuthException {
                        await showErrorDialog(context, 'user not found');
                      } on WrongPasswordAuthException {
                        await showErrorDialog(context, 'wrong password');
                       }
                        on InvalidEmailException {
                        await showErrorDialog(context, 'invalid email');
                       }
                       on GenericAuthException {
                        await showErrorDialog(context, 'Authentication Error');
                      }


                      catch (e) {
                        await showErrorDialog(context, e.toString());
                        developertool.log(e.toString());

                        //  developertool.log(e.toString());
                      }
                    },
                    child: const Text("Login"),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, registerroute, (route) => false);
                      },
                      child: const Text("Register Here"))
                ],
              );

            case ConnectionState.waiting:
              return const Text("Loading...");

            default:
              return const Text("Something went wrong...");
          }
        },
      ),
    );
  }
}
