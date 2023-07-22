import 'package:flutter/material.dart';

BoxDecoration shadowBoxDecoration(
    {Color color = Colors.white,
      double borderRadius = 4,
      Color shadowColor = const Color(0x10000000),
      double blurRadius = 3,
      double spreadRadius = 1,
      Offset offset = const Offset(0, 1)}) {
  return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
            blurRadius: blurRadius,
            color: shadowColor,
            spreadRadius: spreadRadius,
            offset: offset),
      ]);
}
