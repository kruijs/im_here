import 'package:flutter/material.dart';

import 'package:im_here/helpers/DurationExtensions.dart';
import 'package:im_here/services/hereiam/UserLocation.dart';

class FindByNameWidget extends StatelessWidget {
  final Function onCancel;
  final Function(UserLocation) onSelectFind;
  final List<UserLocation> markers;
  final Function(UserLocation) onSelectTrack;
  final String trackedMarkerKey;

  FindByNameWidget(this.markers, this.trackedMarkerKey,
      {this.onSelectFind, this.onCancel, this.onSelectTrack});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      buttonPadding: EdgeInsets.fromLTRB(0, 0, 20, 0),
      titlePadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      insetPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      title: Text('Zentriere auf'),
      content: Container(
        width: 300,
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
                children: markers
                    .map((e) => Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                child: Icon(Icons.location_on,
                                    size: 40, color: e.markerColor),
                                onTap: () => this.onSelectFind(e),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      child: Text(e.user?.name ?? '',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              height: 2.1)),
                                      onTap: () => this.onSelectFind(e),
                                    ),
                                    Text(e.location.age.getLabel(),
                                        style:
                                            TextStyle(height: 1, fontSize: 10)),
                                  ]),
                              Container(
                                width: 30,
                                child: RadioListTile(
                                  value: e.key,
                                  groupValue: this.trackedMarkerKey,
                                  selected: e.key == this.trackedMarkerKey,
                                  onChanged: (key) => this.onSelectTrack(
                                      markers.firstWhere(
                                          (element) => element.key == key,
                                          orElse: () => null)),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                width: 10,
                              ),
                            ]))
                    .toList())),
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
