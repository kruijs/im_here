import 'package:flutter/material.dart';

import 'package:im_here/dialogs/ColorPickerDialog.dart';

import 'package:im_here/helpers/ColorExtensions.dart';

class EnterNameWidget extends StatefulWidget {

  final String displayName;
  final String color;

  final Function(String,String) onOk;
  final Function onCancel;
  
  EnterNameWidget(this.displayName, this.color, { this.onOk, this.onCancel });

  @override
  _EnterNameWidgetState createState() => _EnterNameWidgetState(
      this.displayName, this.color, this.onOk, this.onCancel);
}

class _EnterNameWidgetState extends State<EnterNameWidget> {

  final TextEditingController displayName = TextEditingController();
  final TextEditingController color = TextEditingController();

  final Function(String,String) onOk;
  final Function onCancel;

  _EnterNameWidgetState(String displayName, String color, this.onOk, this.onCancel) {
    this.displayName.text = displayName;
    this.color.text = color;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Bitte Deinen Namen und Farbe eingeben'),
      content: Container(
        padding: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.black,width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: TextField(
                      autofocus: true,
                      maxLines: 1,
                      expands: false,
                      controller: this.displayName,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Dein Name',
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  width: 50, 
                  alignment: Alignment.topRight,
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
              ]
            )
          ]
        )
      ),
      actions: [
        Visibility(
          visible: this.widget.onCancel != null,
          child: FlatButton(
            child: Text('Abbrechen'),
            onPressed: this.widget.onCancel,
          ),
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: () async { 
    
            if (this.displayName.text != null
             && this.displayName.text.isNotEmpty) {
              
              this.widget.onOk(
                this.displayName.text,
                this.color.text
              );
             }
          },
        )
      ],
    );
  }

}