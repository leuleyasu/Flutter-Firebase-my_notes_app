// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

import '../firebase_options.dart';

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
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
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

                    onPressed: ( ) async {
                      try {
                        final email = _email.text;
                        final password = _password.text;

                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email, password: password);
                            
                      } on FirebaseAuthException catch (e) {
                        String errormessage = 'An error occured';
                        if (e.code == 'user-not-found') {
                          errormessage = 'User not found';
                        } else if (e.code == 'Wrong-password') {
                          errormessage =
                              'The account already exists for that email.';


                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errormessage),
                          ),
                        );

                      } catch (e) {
                        print(e);
                      }
                    },
                    child: const Text("Login"),
                  )
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
