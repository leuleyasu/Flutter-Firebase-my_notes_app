import 'package:flutter/material.dart';

typedef DialogoptionBuilder<T>=Map<String,T?>Function();
Future<T?>showGenericDialog  <T>({
  required BuildContext context,
  required title,
  required content,
  required DialogoptionBuilder optionBuilder,

})
{final options=optionBuilder();
  return showDialog<T>(context: context, builder: (context){
    return AlertDialog(
title: Text(title),
content: Text(content),
actions: options.keys.map((dynamicTitle) {
  final T value =options[dynamicTitle];
  return TextButton(onPressed: (){
if (value!=null) {
  Navigator.of(context).pop(value);

} else {
  Navigator.of(context).pop();
 
}

  }, child: Text(dynamicTitle));
}).toList()

    );
  });
}
