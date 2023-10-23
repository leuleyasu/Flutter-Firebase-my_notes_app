import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/Routes.dart';
import 'package:flutter_application_1/services/auth/auth_exception.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';

import '../firebase_options.dart';
import 'dart:developer' as devtools show log;

import '../utilities/ShowErrorDialog.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
        title: const Text("Register"),
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

                        await AuthService.firbase().createuser(
                          email: email,
                          password: password,
                        );
                        if (context.mounted) {
                          Navigator.of(context).pushNamed(verifyemail);
                        }
                        AuthService.firbase().sendEmailVerfication();
                      } on WeakPasswordAuthException {
                        await showErrorDialog(context, 'weak password');
                      } on EmailAlreadyInUseExistAuthException {
                        await showErrorDialog(context, 'email already in-use');
                      } on GenericAuthException {
                        await showErrorDialog(context, 'Failed to Register');
                      } catch (e) {
                       await showErrorDialog(context, e.toString());
                          devtools.log(e.toString());
                      }
                    },
                    child: const Text("Register"),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, loginRoute, (route) => false);
                      },
                      child: const Text("Login Here"))
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
