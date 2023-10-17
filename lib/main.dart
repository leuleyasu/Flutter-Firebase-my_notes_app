import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/verifyemail.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
enum Actionmenu {logout }

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
      home: const VerifyEmail(),
    );
  }
}
Future<bool>showLogOutDialog(BuildContext context){
  return showDialog<bool>(context: context, builder: (_){
    return  AlertDialog(
      title: const Text("Signout"),
      content: const Text("Are u sure u want to sign out?"),
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop(false);
        }, child: const Text("cancel")),
        TextButton(onPressed: (){
          Navigator.of(context).pop(true);

        },
        child: const Text("Logout"))


      ],

    );

  }).then((value) =>value ?? false);

}
