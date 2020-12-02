import 'package:im_here/services/settings/entities/Preferences.dart';
import 'package:im_here/services/settings/entities/Settings.dart';

abstract class SettingsProvider {
    
  Preferences preferences = new Preferences();

  Future<void> loadSettings() async {
  }

  Future<void> saveSettings() async {
    await this.setSettings(Settings(
      preferences: this.preferences
    ));
  }

  Future<void> setSettings(Settings settings) async {
    this.preferences = settings.preferences;
  }

}