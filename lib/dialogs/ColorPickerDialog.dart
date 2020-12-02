import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog {

  final BuildContext context;
  final Color color;
  
  ColorPickerDialog(this.context, this.color);
  
  Future<Color> show() async {
    return await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text('Farbe auswählen'),
            content: Container(
              child: BlockPicker(
                pickerColor: this.color,
                onColorChanged: (color) => Navigator.of(context).pop(color)
              )
            )
          )
        );
      }
    );
  }
}