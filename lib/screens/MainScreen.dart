import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map_markers/map_markers.dart';

import 'package:im_here/helpers/ColorExtensions.dart';
import 'package:im_here/helpers/DurationExtensions.dart';

import 'package:im_here/services/ServiceLocator.dart';
import 'package:im_here/services/SettingsProvider.dart';

import 'package:im_here/services/hereiam/UserLocation.dart';
import 'package:im_here/services/hereiam/HereIAmService.dart';

import 'package:im_here/screens/SettingsScreen.dart';

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
  
  final MapController mapController = MapController();
  final SettingsProvider settings;

  bool starting = true;
  bool initializing = false;

  HereIAmService hereiam;
  List<Marker> markers = [];

  _MainScreenState(this.settings, this.hereiam);

  @override 
  void initState() {
    super.initState();
    this.hereiam.addListener(this.updateMap);
    this.startup();
  }

  @override
  void dispose() {
    this.hereiam.removeListener(this.updateMap);
    this.hereiam.dispose();
    super.dispose();
  }
  
  Future<void> startup() async {

    setState(() {
      this.starting = true;
    });

    await this.init();

    setState(() {
      this.starting = false;
    });
  }

  Future<void> init() async {
    
    print("MainScreen:init");

    var name = this.settings.preferences.displayName;
    
    if (name != null && name.isNotEmpty) {

      setState(() {
        this.initializing = true;
      });

      await this.hereiam.initialize(
        name, 
        this.settings.preferences.color ?? '',
        this.settings.preferences.updateIntervalSeconds ?? 10);
        
      setState(() {
        this.initializing = false;
      });
      
      if (this.mapController.ready) {
        this.mapController.move(this.hereiam.currentLocation, 15);
      } else {
        this.mapController.onReady.then(
          (value) => this.mapController.move(this.hereiam.currentLocation, 15)
        );
      }

    }
  }

  Future<void> updateMap() async {     
    
    print("MainScreen:updateMap");

    setState(() { 
      this.markers = this.hereiam.locations
        .where((entry) => entry != null && entry.user != null && entry.location != null)
        .map((entry) => this.getMarker(entry))
        .toList();
    }); 
  }

  Marker getMarker(UserLocation userlocation) {

    var ago = userlocation.location.age.getLabel();

    return Marker(
      width: 500,
      height: 140,
      point: userlocation.location.point,
      builder: (ctx) => BubbleMarker(
        widgetBuilder: (BuildContext context) 
          => Icon(Icons.location_on, size: 40, color: userlocation.markerColor),
        bubbleColor: userlocation.markerColor,
        bubbleContentWidgetBuilder: (BuildContext context) 
          => Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${userlocation.user.name}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                SizedBox(height: 5),
                Text('$ago', style: TextStyle(fontSize: 15)),
              ]
            )
          )
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
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Icon(Icons.cloud_off,),
          )
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
                await FindByNameDialog(this.context).show(
                  markers: this.hereiam.locations,
                  trackedMarkerKey: '',
                  onSelectFind: (location) {           
                    if (location != null) {
                      this.mapController.move(location.location.point, 18);
                    }
                  },
                  onSelectTrack: (location) {
                    if (location != null) {
                      this.mapController.move(location.location.point, 18);
                    }
                  }
                );  
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
              onTap: () => this.mapController.move(this.hereiam.currentLocation, 18)
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
                if (await Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()))) {
                  await this.init();
                }
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
      ? busyIndicator("Lade...")
      : this.hereiam.isInitialized
        ? FlutterMap(
            options: MapOptions(
              zoom: 13,
              maxZoom: 18,
              plugins: [
              ]
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(
                markers: this.markers ?? []
              ),
            ],
            mapController: this.mapController,
          ) 
        : this.initializing == true
          ? busyIndicator("Lade...")
          : Container(
              height: 400,
              child: EnterNameWidget(
                this.settings.preferences.displayName,
                this.settings.preferences.color,
                onOk: (displayName, color) async {
                  this.settings.preferences.displayName = displayName;
                  this.settings.preferences.color = color;
                  await this.settings.saveSettings();
                  await this.init();
                }
              )
            );
  }

  Widget busyIndicator(String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: CircularProgressIndicator()),
        Center(child: SizedBox(height: 20)),
        Center(child: Text(text))
      ]
    );
  }
}
