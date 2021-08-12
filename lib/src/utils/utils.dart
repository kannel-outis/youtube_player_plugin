import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
class Utils {
  static double blockHeight = 0.0;
  static double blockWidth = 0.0;

  static void calculateBlockHeightAndWidth(BuildContext context) {
    blockHeight = MediaQuery.of(context).size.height / 100;
    blockWidth = MediaQuery.of(context).size.width / 100;
  }
}
