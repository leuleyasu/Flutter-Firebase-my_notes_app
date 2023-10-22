import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/Notes.dart';
import 'package:flutter_application_1/view/Register.dart';
import 'package:flutter_application_1/view/constants/Routes.dart';
import 'package:flutter_application_1/view/login.dart';
import 'package:flutter_application_1/view/verifyemail.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

enum Actionmenu { logout }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: const NotesPage(),
        routes: {
          loginRoute: (context) => const Login(),
          notesroute: (context) => const NotesPage(),
          registerroute: (context) => const Register(),
          verifyemail: (context) => const VerifyEmail(),
        });
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Signout"),
          content: const Text("Are u sure u want to sign out?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("cancel")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Logout"))
          ],
        );
      }).then((value) => value ?? false);
}
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
   return FutureBuilder(
  builder: (context, snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.done:
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          if (user.emailVerified) {
            return const NotesPage();
          } else {
            return const VerifyEmail();
          }
        }
        // If user is null or email is not verified, you might want to return a login page or something else.
        return const Login();

      case ConnectionState.waiting:
        return const Text("waiting ....");

      default:
        return const Text("something went wrong");
    }
  },
);

}
}
