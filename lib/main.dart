import 'package:flutter/material.dart';

import 'package:im_here/screens/MainScreen.dart';
import 'package:im_here/services/ServiceLocator.dart';
import 'package:im_here/services/SettingsProvider.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  
  var userSettingsProvider = resolve<SettingsProvider>();
  await userSettingsProvider.loadSettings();

  runApp(HereIAmApp());
}

class HereIAmApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Here I Am',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(elevation: 2)
      ),
      home: MainScreen(),
    );
  }
}