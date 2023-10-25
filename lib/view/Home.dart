
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/view/Notes.dart';
import 'package:flutter_application_1/view/verifyemail.dart';
import 'dart:developer' as developertool show log;
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firbase().initializeApp(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firbase().currentUser;
            if (user != null) {
              if (user.isEmailVerfied) {
                //  ScaffoldMessenger.of(context).
                // showSnackBar(const
                // SnackBar(content: Text("Welcome")));
                return const NotesPage();
              } else {
                return const VerifyEmail();
              }
            }

            developertool.log(user.toString());

          default:
            return const Text("waiting for connection");
        }
        return const Text("something went wrong");
      },
    );
  }
}
