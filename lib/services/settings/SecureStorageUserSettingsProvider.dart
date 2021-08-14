import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:im_here/services/SettingsProvider.dart';
import 'package:im_here/services/settings/entities/Preferences.dart';
import 'package:im_here/services/settings/entities/Settings.dart';

class SecureStorageUserSettingsProvider extends SettingsProvider {

  static final secureStorage = new FlutterSecureStorage();
  static final String _key = "user_settings";

  @override
  Future<void> loadSettings() async {

    print("getSettings");
    var settings = new Settings();  
    
    var string = await secureStorage.read(key: _key);
    if (string != null && string.isNotEmpty) {
      var map = json.decode(string);
      settings = Settings.fromJson(map);
    }

    this.preferences = settings.preferences ?? new Preferences();

    super.loadSettings();
  }
  
  @override
  Future<void> setSettings(Settings? settings) async {
    
    print("setSettings");

    final storage = new FlutterSecureStorage();
    await storage.delete(key: _key);

    if (settings != null) {
      var map = settings.toJson();
      var string = json.encode(map);
      await storage.write(key: _key, value: string);
    }

    super.setSettings(settings);
  }
}