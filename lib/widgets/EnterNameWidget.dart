import 'package:flutter/material.dart';

import 'package:im_here/dialogs/ColorPickerDialog.dart';

import 'package:im_here/services/SettingsProvider.dart';
import 'package:im_here/helpers/ColorExtensions.dart';

class EnterNameWidget extends StatelessWidget {

  final SettingsProvider settings;

  final TextEditingController displayName = TextEditingController();
  final TextEditingController color = TextEditingController();

  final Function onOk;
  final Function onCancel;

  EnterNameWidget(this.settings, { this.onOk, this.onCancel }) {
    this.displayName.text
      = this.settings.preferences.displayName;
    this.color.text
      = this.settings.preferences.color;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Bitte Deinen Namen eingeben'),
      content: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.black,width: 1),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            children: [
              TextField(
                controller: this.displayName,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Dein Name',
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  var color = await ColorPickerDialog(context, this.color.text.parseToColor()).show();
                  this.color.text = color.toHexString();
                },
                color: this.color.text.parseToColor(),
                textColor: Colors.white,
                padding: EdgeInsets.all(16),
                shape: CircleBorder(),
              ),
            ]
          )
        ),
      ),
      actions: [
        Visibility(
          visible: this.onCancel != null,
          child: FlatButton(
            child: Text('Abbrechen'),
            onPressed: this.onCancel,
          ),
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: () async { 
    
            if (this.displayName.text != null
             && this.displayName.text.isNotEmpty) {
              
              this.settings.preferences.displayName = this.displayName.text;
              this.settings.preferences.color = this.color.text;
              
              await this.settings.saveSettings();

              this.onOk();
             }
          },
        )
      ],
    );
  }

}