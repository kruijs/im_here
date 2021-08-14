import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    this.displayName.text = this.settings.preferences.displayName ?? '';
    this.color.text = this.settings.preferences.color ?? '#RR000';
    this.updateInterval.text = this.settings.preferences.updateIntervalSeconds != null
      ? this.settings.preferences.updateIntervalSeconds.toString()
      : '10';
  }

  @override
  Widget build(BuildContext context) {   
    var width = MediaQuery.of(context).size.width;
    var padding = (width - 300) / 2;
    return Scaffold(
      appBar: AppBar(
        title: Text("Einstellungen"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(padding, 40, padding, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,

          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    controller: this.displayName,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: "Name",
                      hintText: 'Gib hier deinen Namen ein',
                    ),
                  ),
                ),
                Container(
                  width: 80, 
                  alignment: Alignment.centerRight,
                  child: MaterialButton(
                    onPressed: () async {
                      var color = await ColorPickerDialog(context, this.color.text.parseToColor()).show();
                      setState(() {
                        this.color.text = color.toHexString() ?? '';
                      });
                    },
                    color: this.color.text.parseToColor(),
                    textColor: Colors.white,
                    padding: EdgeInsets.all(16),
                    shape: CircleBorder(),
                  ),
                )
              ]
            ),

            SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: TextField(
                    controller: this.updateInterval,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: "Aktualisierungsintervall (in Sekunden)"
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [ 
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
              ]
            ),

            SizedBox(height: 40),
 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                OutlineButton(
                  child: Text("Speichern", ),
                  onPressed: () async {

                    this.settings.preferences.displayName = this.displayName.text;
                    this.settings.preferences.color = this.color.text;
                    this.settings.preferences.updateIntervalSeconds
                      = int.parse(this.updateInterval.text);

                    await this.settings.saveSettings();
                    Navigator.pop(context, true);
                  
                  }
                )
              ],
            )
            
          ],
        )
      )
    );
  }
}