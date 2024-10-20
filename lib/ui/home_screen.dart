import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/home_provider.dart';
import '../utils/constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _startLocationController =
      TextEditingController();
  final TextEditingController _endLocationController = TextEditingController();

  // MapboxMap? _startMapboxMap;
  // MapboxMap? _endMapboxMap;
  // PointAnnotationManager? pointAnnotationManager;
  // PointAnnotation? pointAnnotation;
  //
  // CameraOptions? startCamera;
  // CameraOptions? endCamera;

  double startLat = 0.0;
  double startLng = 0.0;

  double endLat = 0.0;
  double endLng = 0.0;

  late MapboxMapController? mapControllerStart;
  late MapboxMapController? mapControllerEnd;

  @override
  Widget build(BuildContext context) {

    void _onMapCreatedStart(MapboxMapController controller) {
      mapControllerStart = controller;
    }

    void _onMapCreatedEnd(MapboxMapController controller) {
      mapControllerEnd = controller;
    }

    void updateCameraPositionStart(
        double latitude, double longitude, double zoom) {
      final cameraUpdate = CameraUpdate.newLatLngZoom(
        LatLng(latitude, longitude),
        zoom,
      );

      // Smoothly animate the camera to the new position
      mapControllerStart!.animateCamera(cameraUpdate);
    }

    void updateCameraPositionEnd(
        double latitude, double longitude, double zoom) {
      final cameraUpdate = CameraUpdate.newLatLngZoom(
        LatLng(latitude, longitude),
        zoom,
      );

      // Smoothly animate the camera to the new position
      mapControllerEnd!.animateCamera(cameraUpdate);
    }

    return MaterialApp(
        title: 'Home Screen',
        home: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(150.0),
              child: Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      child: const Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Robert Doe',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            'robertdoe@gmail.com',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
          body: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child:
                  Consumer<HomeProvider>(builder: (context, provider, child) {
                startLat = provider.startLatitude;
                startLng = provider.startLongitude;

                endLat = provider.endLatitude;
                endLng = provider.endLongitude;

                if (startLat != 0.0) {
                  updateCameraPositionStart(startLat, startLng,
                      11); // Example coordinates for San Francisco
                }

                if (endLat != 0.0) {
                  updateCameraPositionEnd(endLat, endLng,
                      11); // Example coordinates for San Francisco
                }

                return Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 4.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: primaryColor,
                            width: 1, // Border width
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: TextFormField(
                                    controller: _startLocationController,
                                    decoration: const InputDecoration(
                                      hintText: 'Start Location',
                                      prefixIcon:
                                          Icon(Icons.location_on_outlined),
                                      border: InputBorder.none,
                                    ),
                                    textCapitalization:
                                        TextCapitalization.words,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                    maxLines: 1,
                                    textInputAction: TextInputAction.done,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: IconButton(
                                    icon: const Icon(Icons.search),
                                    onPressed: () {
                                      if (_startLocationController
                                          .text.isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: "Please enter Trip Location",
                                          toastLength: Toast.LENGTH_SHORT,
                                        );
                                        return;
                                      }

                                      provider.getStartSearch(
                                          _startLocationController.text,
                                          true,
                                          false);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Stack(children: [
                              Container(
                                  color: Colors.grey,
                                  height:
                                      MediaQuery.of(context).size.height / 6.21,
                                  child: MapboxMap(
                                    accessToken: ACCESS_TOKEN,
                                    onMapCreated: _onMapCreatedStart,
                                    styleString:
                                        "mapbox://styles/mapbox/streets-v11",
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(provider.startLatitude,
                                          provider.startLatitude),
                                      // Center map on San Francisco
                                      zoom: 10,
                                    ),
                                  )),
                              provider.onStartLocationShow
                                  ? Container(
                                      height: 100,
                                      color: Colors.white,
                                      child: ListView.builder(
                                        itemCount:
                                            provider.searchResultsStart.length,
                                        itemBuilder: (context, index) {
                                          final place = provider
                                              .searchResultsStart[index];
                                          return InkWell(
                                            onTap: () {
                                              provider.setOnStartLocationShow(
                                                  false);

                                              Map<String, dynamic> geometry =
                                                  place['geometry'];
                                              List<dynamic> coordinates =
                                                  geometry['coordinates'];

                                              provider.setStartlatlng(
                                                  coordinates[0],
                                                  coordinates[1]);
                                              _startLocationController.text =
                                                  place['text'];

                                              startLng = coordinates[0];
                                              startLat = coordinates[1];
                                            },
                                            child: ListTile(
                                              title: Text(place['place_name']),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Container()
                            ])
                            // })
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 4.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: primaryColor,
                            width: 1, // Border width
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: TextFormField(
                                    controller: _endLocationController,
                                    decoration: const InputDecoration(
                                      hintText: 'End Location',
                                      prefixIcon:
                                          Icon(Icons.location_on_outlined),
                                      border: InputBorder.none,
                                    ),
                                    textCapitalization:
                                        TextCapitalization.words,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                    maxLines: 1,
                                    textInputAction: TextInputAction.done,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: IconButton(
                                    icon: const Icon(Icons.search),
                                    onPressed: () {
                                      if (_startLocationController
                                          .text.isEmpty) {
                                        Fluttertoast.showToast(
                                          msg:
                                              "Please select Start Trip Location",
                                          toastLength: Toast.LENGTH_SHORT,
                                        );
                                        return;
                                      }
                                      if (_endLocationController.text.isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: "Please enter Trip Location",
                                          toastLength: Toast.LENGTH_SHORT,
                                        );
                                        return;
                                      }

                                      provider.getStartSearch(
                                          _endLocationController.text,
                                          false,
                                          true);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Stack(children: [
                              Container(
                                  color: Colors.grey,
                                  height:
                                  MediaQuery.of(context).size.height / 6.21,
                                  child: MapboxMap(
                                    accessToken: ACCESS_TOKEN,
                                    onMapCreated: _onMapCreatedEnd,
                                    styleString:
                                    "mapbox://styles/mapbox/streets-v11",
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(provider.endLatitude,
                                          provider.endLongitude),
                                      // Center map on San Francisco
                                      zoom: 10,
                                    ),
                                  )),
                              provider.onEndLocationShow
                                  ? Container(
                                      height: 100,
                                      color: Colors.white,
                                      child: ListView.builder(
                                        itemCount:
                                            provider.searchResultsStart.length,
                                        itemBuilder: (context, index) {
                                          final place = provider
                                              .searchResultsStart[index];
                                          return InkWell(
                                            onTap: () {
                                              provider
                                                  .setOnEndLocationShow(false);
                                              _endLocationController.text =
                                                  place['text'];

                                              Map<String, dynamic> geometry =
                                                  place['geometry'];
                                              List<dynamic> coordinates =
                                                  geometry['coordinates'];

                                              provider.setEndlatlng(
                                                  coordinates[1],
                                                  coordinates[0]);
                                            },
                                            child: ListTile(
                                              title: Text(place['place_name']),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Container()
                            ])
                            // })
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              })),
          bottomNavigationBar: Container(
            height: 80,
            color: primaryColor,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      onNavigate();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      'Navigate',
                      style: TextStyle(color: primaryColor),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/saved_trip_screen',
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      'Saved',
                      style: TextStyle(color: primaryColor),
                    )),
              ],
            ),
          ),
        ));
  }

  void onNavigate() {
    String startLocation = _startLocationController.text;
    String endLocation = _endLocationController.text;
    if (startLocation.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please select your Start Trip Location",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }
    if (endLocation.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please select your End Trip Location",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    Map<String, dynamic> args = {
      "startLongitude": startLng,
      "startLatitude": startLat,
      "endLongitude": endLng,
      "endLatitude": endLat,
      "startPlace": _startLocationController.text,
      "endPlace": _endLocationController.text,
      "isSave": true,
    };

    Navigator.pushNamed(context, '/trip_screen', arguments: args);
  }
}
