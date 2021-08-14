import 'package:get_it/get_it.dart';

import 'package:im_here/services/LocationProvider.dart';
import 'package:im_here/services/SettingsProvider.dart';

import 'package:im_here/services/device/DeviceLocationProvider.dart';
import 'package:im_here/services/device/DeviceUidProvider.dart';
import 'package:im_here/services/hereiam/HereIAmService.dart';

import 'package:im_here/services/settings/SecureStorageUserSettingsProvider.dart';

GetIt bootstrap() {

  var serviceUri = "http://kruijs.ddns.net:81";

  var getIt = GetIt.instance;

  getIt.registerSingleton<LocationProvider>(DeviceLocationProvider());
  getIt.registerSingleton<SettingsProvider>(SecureStorageUserSettingsProvider()); 
  getIt.registerSingleton<DeviceUidProvider>(DeviceUidProvider()); 

  getIt.registerSingleton<HereIAmService>(HereIAmService(serviceUri, getIt<LocationProvider>(), getIt<DeviceUidProvider>()));
  
  return getIt; 
}

// This is our global ServiceLocator
final resolve = bootstrap();