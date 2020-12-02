import 'package:flutter/material.dart';

import 'package:im_here/dialogs/ColorPickerDialog.dart';

import 'package:im_here/services/ServiceLocator.dart';
import 'package:im_here/services/SettingsProvider.dart';

import 'package:im_here/helpers/ColorExtensions.dart';

class SettingsScreen extends StatefulWidget {

  @override
  _SettingsScreenState createState() => _SettingsScreenState(
    resolve<SettingsProvider>()
  );
}

class _SettingsScreenState extends State<SettingsScreen> {
  
  final SettingsProvider settings;
  final TextEditingController displayName = TextEditingController();
  final TextEditingController updateInterval = TextEditingController();
  final TextEditingController color = TextEditingController();

  _SettingsScreenState(this.settings) {
    this.displayName.text = this.settings.preferences.displayName;
    this.color.text = this.settings.preferences.color ?? '#RR000';
    this.updateInterval.text = this.settings.preferences.updateIntervalSeconds != null
      ? this.settings.preferences.updateIntervalSeconds.toString()
      : '10';
  }

  @override
  Widget build(BuildContext context) {   
    return Scaffold(
      appBar: AppBar(
        title: Text("Einstellungen"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 200,
                  alignment: Alignment.topCenter,
                  child: TextFormField(
                    minLines: 1,
                    maxLines: 1,
                    controller: this.displayName,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Dein Name',
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 200, 
                    alignment: Alignment.topCenter,
                    child: MaterialButton(
                      onPressed: () async {
                        var color = await ColorPickerDialog(context, this.color.text.parseToColor()).show();
                        setState(() {
                          this.color.text = color.toHexString();
                        });
                      },
                      color: this.color.text.parseToColor(),
                      textColor: Colors.white,
                      padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
                    ),
                  )
                )
              ]
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                OutlineButton(
                  child: Text("Speichern"),
                  onPressed: () async {

                    this.settings.preferences.displayName = this.displayName.text;
                    this.settings.preferences.color = this.color.text;
                    this.settings.preferences.updateIntervalSeconds
                      = int.parse(this.updateInterval.text);

                    await this.settings.saveSettings();
                    Navigator.pop(context, true);
                  
                  }
                ),
                SizedBox(width: 10,),
                OutlineButton(
                  child: Text("Abbrechen"),
                  onPressed: () => Navigator.pop(context, false)
                )
              ],
            )
            
          ],
        )
      )
    );
  }
}