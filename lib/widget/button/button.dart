import 'package:flutter/material.dart';

Widget getelevatedbutton(
    {required String textchild, required Function()? onpress}) {
  return ElevatedButton(
      onPressed: onpress,
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      child: Text(textchild));
}
