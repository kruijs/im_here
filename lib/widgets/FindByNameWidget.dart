import 'package:flutter/material.dart';

import 'package:im_here/services/hereiam/UserLocation.dart';

class FindByNameWidget extends StatelessWidget {

  final Function onCancel;
  final Function(UserLocation) onSelect;
  final List<UserLocation> markers;

  FindByNameWidget(this.markers, { this.onSelect, this.onCancel });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Bitte wählen'),
      content: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: markers.map((e) => 
              Row(
                children: [
                  InkWell(child: Icon(Icons.center_focus_weak), onTap: () => this.onSelect(e),),
                  InkWell(child: Text(e.user.name), onTap: () => this.onSelect(e),),
                  SizedBox(height:30)
                ]
              ),
            ).toList()
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
      ],
    );
  }

}