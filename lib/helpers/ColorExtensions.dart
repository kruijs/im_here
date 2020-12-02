import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

extension StringToColorExtensions on String {

  Color parseToColor({ Color fallback }) {
    
    try {
      if (this != null && this.isNotEmpty) {
        return HexColor(this);
      }
    }
    catch (ex) {

    }
    
    return fallback;
  }

}


extension ColorToStringExtensions on Color {

  String toHexString() {
    
    try {
      return '#${this.value.toRadixString(16)}';
    }
    catch (ex) {

    }
    
    return null;
  }

}