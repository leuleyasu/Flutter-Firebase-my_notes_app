import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  TextEditingController emailverifycontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verfify Email Adress"),),
   body: FutureBuilder(
    future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform

    ),
    builder: (context, snapshot) {
switch (snapshot.connectionState) {
  case ConnectionState.done:
return Column(
      children: [
        TextField(
          controller: emailverifycontroller,
        decoration: const InputDecoration(
          hintText: "Email adress"
        ),

        ),
        TextButton(onPressed: ()async{

          final user=FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
        }, child: const Text("Verify Email"))
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