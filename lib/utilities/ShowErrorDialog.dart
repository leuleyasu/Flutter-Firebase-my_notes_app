import 'package:flutter/material.dart';
import 'package:flutter_application_1/utilities/generic_call_back.dart';

Future<void>showErrorDialog(BuildContext context, String text){

   return showGenericDialog<void>(context: context,
   title: const Text("An Error occured"),
   content: Text(text),
   optionBuilder:()=>{
"ok":null
   } );

}
Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog(context: context,
   title: const Text("data"),
   content: "Are you sure you want log out",
   optionBuilder: ()=>{
"cancel":false,
"Logout":true,
   }).then((value) => value??false);

}

Future<bool> showDelteDialog(BuildContext context){

return showGenericDialog(context: context, title: const  Text("delete"), content: "are you sure you want to delete",
optionBuilder: ()=>{
"cancel":false,
"Delete":true,
}).then((value) => value??false );
}