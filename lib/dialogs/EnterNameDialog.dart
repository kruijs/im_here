import 'package:flutter/material.dart';

import 'package:im_here/services/SettingsProvider.dart';
import 'package:im_here/widgets/EnterNameWidget.dart';

class EnterNameDialog {

  final BuildContext context;
  final SettingsProvider settings;
  
  EnterNameDialog(this.context, this.settings);
  
  Future<bool> show() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: EnterNameWidget(
            this.settings,
            onOk: () => Navigator.of(context).pop(true),
            onCancel: () => Navigator.of(context).pop(false)
          )
        );
      }
    );
  }
}