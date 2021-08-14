import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

extension StringToColorExtensions on String? {

  Color parseToColor({ Color? fallback }) {
    
    try {
      if (this != null && this!.isNotEmpty) {
        return HexColor(this!);
      }
    }
    catch (ex) {

    }
    
    return fallback ?? Colors.transparent;
  }

}


extension ColorToStringExtensions on Color? {

  String? toHexString() {

    try {
      return this == null ? null : '#${this?.value.toRadixString(16)}';
    }
    catch (ex) {
    }
    
    return null;
  }

}