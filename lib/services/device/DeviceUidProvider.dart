import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

class DeviceUidProvider
{
  static final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

  Future<String?> getDeviceUid() async {
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        return build.androidId;  //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        return data.identifierForVendor;  //UUID for iOS
      }
    } on PlatformException {
      return null;
    }
  }
}