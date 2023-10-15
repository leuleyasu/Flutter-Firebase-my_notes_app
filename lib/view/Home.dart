import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/verifyemail.dart';

import '../firebase_options.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FutureBuilder(
       future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
        builder: (context, snapshot) {
switch(snapshot.connectionState){
  case ConnectionState.done:
 final user= FirebaseAuth.instance.currentUser;
 final emailverified=user?.emailVerified??false;
 if(emailverified){
  ScaffoldMessenger.of(context).
  showSnackBar(const
  SnackBar(content: Text("Welcome")));
 }else{
  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const VerifyEmail()));
  ScaffoldMessenger.of(context).
  showSnackBar(const
  SnackBar(content: Text("please verify email address")));
 }
  print(user);
  const Column(
    children: [

    ],

  );
  default:return const Text("waiting for connection");

}return const Text("something went wrong");
        },

      ),
    );
  }
}