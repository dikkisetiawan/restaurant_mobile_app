import 'package:flutter/material.dart';

Widget getimageicon(double width, double height) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('Image/icon2.png'),
        ),
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20)),
  );
}
