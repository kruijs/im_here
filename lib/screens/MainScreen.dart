import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map_markers/map_markers.dart';


import 'package:im_here/services/ServiceLocator.dart';
import 'package:im_here/services/SettingsProvider.dart';

import 'package:im_here/services/hereiam/UserLocation.dart';
import 'package:im_here/services/hereiam/HereIAmService.dart';

import 'package:im_here/screens/SettingsScreen.dart';

import 'package:im_here/helpers/ColorExtensions.dart';
import 'package:im_here/helpers/DateTimeExtensions.dart';
import 'package:im_here/helpers/DurationExtensions.dart';

import 'package:im_here/dialogs/EnterNameDialog.dart';
import 'package:im_here/dialogs/FindByNameDialog.dart';

import 'package:im_here/widgets/EnterNameWidget.dart';

class MainScreen extends StatefulWidget {

  @override
  _MainScreenState createState() => _MainScreenState(
    resolve<SettingsProvider>(),
    resolve<HereIAmService>()
  );
}

class _MainScreenState extends State<MainScreen> {
  
  final MapController controller = MapController();
  final SettingsProvider settings;

  bool starting = true;
  HereIAmService hereiam;
  List<Marker> markers = [];

  _MainScreenState(this.settings, this.hereiam);

  @override 
  void initState() {
    super.initState();
    this.hereiam.addListener(this.updateMap);
    this.init();
  }

  @override
  void dispose() {
    this.hereiam.removeListener(this.updateMap);
    this.hereiam.dispose();
    super.dispose();
  }

  Future<void> init() async {
    
    print("MainScreen:init");

    setState(() {
      this.starting = true;
    });

    var name = this.settings.preferences.displayName;
    
    if (name != null && name.isNotEmpty) {
      await this.hereiam.initialize(name, this.settings.preferences.color);
      
      if (this.controller.ready) {
        this.controller.move(this.hereiam.currentLocation, 15);
      } else {
        this.controller.onReady.then((value) {
          this.controller.move(this.hereiam.currentLocation, 15);
        });
      }
    }

    setState(() {
      this.starting = false;
    });
  }

  Future<void> updateMap() async {     
    
    print("MainScreen:updateMap");

    setState(() { 
      this.markers = this.hereiam.locations
        .map((entry) => this.getMarker(entry))
        .toList();
    }); 
  }

  Marker getMarker(UserLocation userlocation) {
    
    var age = userlocation.location.timestamp.parseIso6801String()
              .difference(DateTime.now());

    var isoffline = age > Duration(minutes: 10);

    return Marker(
      height: 100.0,
      width: 120.0,
      point: userlocation.location.point,
      builder: (ctx) => BubbleMarker(
        widgetBuilder: (BuildContext context) 
          => Icon(Icons.location_on, size: 35.0, color: userlocation.user.color.parseToColor().withAlpha(isoffline ? 100 : 255)),
        bubbleColor: userlocation.user.color.parseToColor(),
        bubbleContentWidgetBuilder: (BuildContext context) 
          => Text('${userlocation.user.name} (${age.formatDuration()})')
      ),
    );
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: this.starting || !this.hereiam.isInitialized 
        ? null 
        : this.buildAppBar(context),
      body: this.buildBody(context)
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: this.settings.preferences.color.parseToColor(fallback: Colors.red),
      actions: [
        Visibility(
          visible: this.hereiam.sendingfailed || this.hereiam.loadingfailed,
          child: Icon(Icons.warning,),
        ),
        Visibility(
          visible: this.hereiam.isInitialized,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: InkWell(
              child: Icon(
                Icons.search, 
                color: this.hereiam.locations.length > 1 
                  ? Colors.white 
                  : Colors.white.withAlpha(128),
              ),
              onTap: this.hereiam.locations.length > 1 ? () async {
                var location = await FindByNameDialog(this.context, this.hereiam.locations).show();              
                if (location != null) {
                   this.controller.move(location.location.point, 18);
                }
              } : null
            )
          ),
        ),
        Visibility(
          visible: this.hereiam.isInitialized,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: InkWell(
              child: Icon(Icons.center_focus_strong_outlined,),
              onTap: () => this.controller.move(this.hereiam.currentLocation, 18)
            )
          ),
        ),
        Visibility(
          visible: this.hereiam.isInitialized,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: InkWell(
              child: Icon(Icons.settings,),
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
                await this.init();
              }
            ) 
          )
        )
      ],
      title: InkWell(
        onTap: () async {
          await EnterNameDialog(this.context, this.settings).show();              
          await this.init();
        },
        child: this.settings.preferences.displayName != null
          ? Text(this.settings.preferences.displayName)
          : Container(),
      )
    );
  }
  
  Widget buildBody(BuildContext context) {
    return this.starting == true 
      ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: CircularProgressIndicator()),
          Center(child: SizedBox(height: 20)),
          Center(child: Text("Lade..."))
        ]
      )
      : this.hereiam.isInitialized
        ? FlutterMap(
            options: MapOptions(
              zoom: 13.0,
              plugins: [
              ],
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']
              ),
              MarkerLayerOptions(markers: this.markers ?? []),
            ],
            mapController: this.controller,
          )
        : Container(
          child: EnterNameWidget(
            this.settings,
            onOk: () async {
              await this.init();
            }
          )
        );
  }
}
