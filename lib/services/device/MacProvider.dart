import 'package:flutter/services.dart';
import 'package:get_mac/get_mac.dart';

class MacProvider
{
  Future<String> getMac() async {
    try {
      return await GetMac.macAddress;
    } on PlatformException {
      return null;
    }
  }
}