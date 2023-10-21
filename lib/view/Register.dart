import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/view/constants/Routes.dart';

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
                  onPressed: () async {
                    try {
                      final email = _email.text;
                      final password = _password.text;

                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: email, password: password);
                              if(context.mounted){
                              Navigator.of(context).pushNamed(verifyemail);
                              }
                    } on FirebaseAuthException catch (e) {
                      // String errormessage='An error occured';
                      if (e.code == 'weak-password') {

                    // errormessage='The password provided is too weak.';
                    showErrorDialog(context, "The password provided is too weak.");

                      } else if (e.code == 'email-already-in-use') {

                    // errormessage='The account already exists for that email.';
                    showErrorDialog(context, "The account already exists for that email.");

                    devtools.log("The account already exists for that email.");
                        // print('');
                      }

      //                ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(errormessage),
      //   ),
      // );
                    }
                    catch (e) {
                    showErrorDialog(context,e.toString());
                    //  devtools.log(e.toString());
                    }
                  },
                  child: const Text("Register"),
                ),
                TextButton(onPressed: (){
                  Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);


                }, child: const Text("Login Here"))
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