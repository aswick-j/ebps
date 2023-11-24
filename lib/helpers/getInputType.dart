import 'package:flutter/material.dart';

dynamic getInputType(String? value) {
  switch (value) {
    case "NUMERIC":
      return TextInputType.number;
    case "ALPHANUMERIC":
      return TextInputType.text;
    default:
      TextInputType.text;
  }
}
