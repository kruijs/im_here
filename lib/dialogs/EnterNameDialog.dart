import 'package:flutter/material.dart';

import 'package:im_here/services/SettingsProvider.dart';
import 'package:im_here/widgets/EnterNameWidget.dart';

class EnterNameDialog {

  final BuildContext context;
  final SettingsProvider settings;
  
  EnterNameDialog(this.context, this.settings);
  
  Future<bool?> show() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: SingleChildScrollView(
            child: EnterNameWidget(
              this.settings.preferences.displayName,
              this.settings.preferences.color,
              onOk: (displayName, color) async {
                
                  this.settings.preferences.displayName = displayName;
                  this.settings.preferences.color = color;
                  
                  await this.settings.saveSettings();

                Navigator.of(context).pop(true);
              },
              onCancel: () => Navigator.of(context).pop(false)
            )
          )
        );
      }
    );
  }
}