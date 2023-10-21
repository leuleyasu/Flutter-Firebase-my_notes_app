// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/constants/Routes.dart';
import 'dart:developer' as devtools show log;
import '../firebase_options.dart';
import '../utilities/ShowErrorDialog.dart';

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
final user= FirebaseAuth.instance.currentUser;
if(user?.emailVerified?? false){
Navigator.of(context).pushNamedAndRemoveUntil(notesroute, (route) => false);
}else{
Navigator.of(context).pushNamedAndRemoveUntil(verifyemail, (route) => false);

}
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email, password: password);

                              if(context.mounted){
                               Navigator.pushNamedAndRemoveUntil(context, notesroute, (route) => false);

                              }




                      } on FirebaseAuthException catch (e) {
                        //  showErrorDialog(context, "An internal error has occurred.");
                        // String errormessage = 'An error occured';
                        if (e.code == 'user-not-found') {
                        showErrorDialog(context, "User not found");
                    devtools.log("user not found.");

                          // errormessage = 'User not found';
                        } else if (e.code == 'Wrong-password') {
                        showErrorDialog(context,'wrong password');
                               devtools.log(e.code.toString());
                          // errormessage =
                          //     'The account already exists for that email.';


                        }

                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text(errormessage),
                        //   ),
                        // );

                      } catch (e) {
                        showErrorDialog(context,e.toString());

                      //  developertool.log(e.toString());
                      }
                    },
                    child: const Text("Login"),
                  ),
                  TextButton(onPressed: (){
                      Navigator.pushNamedAndRemoveUntil(context, registerroute, (route) => false);

                  }, child: const Text("Register Here"))
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
