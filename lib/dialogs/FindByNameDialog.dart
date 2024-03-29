import 'package:flutter/material.dart';

import 'package:im_here/services/hereiam/UserLocation.dart';
import 'package:im_here/widgets/FindByNameWidget.dart';

class FindByNameDialog {

  final BuildContext context;
  
  FindByNameDialog(this.context);
  
  Future<UserLocation?> show({ required List<UserLocation> markers, required String trackedMarkerKey, required Function(UserLocation?) onSelectFind, required Function(UserLocation?) onSelectTrack }) async {
    return await showDialog<UserLocation>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: FindByNameWidget(
            markers,
            trackedMarkerKey,
            onSelectFind: (marker) { onSelectFind(marker); Navigator.of(context).pop(marker); },
            onSelectTrack: (marker) { onSelectTrack(marker); },
            onCancel: () => Navigator.of(context).pop(null)
          )
        );
      }
    );
  }
}