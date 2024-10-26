import 'package:flutter/material.dart';

Color getColorByName(String name) {
  switch (name) {
    case "emas":
      return Colors.yellow[700]!;
    case "coklat":
      return Colors.brown;
    case "silver":
      return Colors.grey;
    case "yellow":
      return Colors.yellow;
    case "hitam":
      return Colors.black;
    case "putih":
      return Colors.white;
    default:
      return Colors.black;
  }
}
