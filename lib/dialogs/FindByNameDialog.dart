import 'package:flutter/material.dart';

import 'package:im_here/services/hereiam/UserLocation.dart';
import 'package:im_here/widgets/FindByNameWidget.dart';

class FindByNameDialog {

  final BuildContext context;
  final List<UserLocation> markers;

  FindByNameDialog(this.context, this.markers);
  
  Future<UserLocation> show() async {
    return await showDialog<UserLocation>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: FindByNameWidget(
            this.markers,
            onSelect: (marker) => Navigator.of(context).pop(marker),
            onCancel: () => Navigator.of(context).pop(null)
          )
        );
      }
    );
  }
}