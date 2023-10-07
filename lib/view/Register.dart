import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

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
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: FutureBuilder(
          future:  Firebase.initializeApp(
           options: DefaultFirebaseOptions.currentPlatform,
       ),
        builder: (context, snapshot) {
           switch(snapshot.connectionState){
            case  ConnectionState.none:
Column(
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

                 await  FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email, password: password);


                    } on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
    print('The password provided is too weak.');
  } else if (e.code == 'email-already-in-use') {
    print('The account already exists for that email.');
  }

                    }

                     catch (e) {
                      print(e);
                    }

                }, child: const Text("Register"),
               )
          ],
 );

default:return const Text("waiting connection");
        }

return const Text("someting went wrong");
          }



      ),
    );
  }
}