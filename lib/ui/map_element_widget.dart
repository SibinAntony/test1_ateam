
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../utils/constant.dart';

class MapElementWidget extends StatefulWidget {
  MapElementWidget({super.key, this.args, });

  Map<String, dynamic>? args;


  @override
  State<MapElementWidget> createState() => _MapElementWidgetState();
}

class _MapElementWidgetState extends State<MapElementWidget> {
  double startLatitude = 0.0;
  double startLongitude = 0.0;
  double endLatitude = 0.0;
  double endLongitude = 0.0;

  late MapboxMapController mapController;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;

    startLatitude = widget.args!['startLatitude'];
    startLongitude = widget.args!['startLongitude'];
    endLatitude = widget.args!['endLatitude'];
    endLongitude = widget.args!['endLongitude'];


    // Get the directions and draw the route
    _fetchAndDrawRoute();
  }

  Future<void> _fetchAndDrawRoute() async {
    try {
      final directions = await getDirections(
          ACCESS_TOKEN, startLatitude, startLongitude, endLatitude, endLongitude); // Sample coordinates

      // Extract the route coordinates
      final List<dynamic> coordinates = directions['routes'][0]['geometry']['coordinates'];
      List<LatLng> routeCoordinates = coordinates
          .map((coord) => LatLng(coord[1], coord[0])) // Convert to LatLng
          .toList();

      // Draw the polyline on the map
      mapController.addLine(
        LineOptions(
          geometry: routeCoordinates,
          lineColor: "#ff0000", // Red color for the route
          lineWidth: 5.0,       // Line width
        ),
      );

      // Optionally animate the camera to fit the route
      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(
                routeCoordinates.map((c) => c.latitude).reduce((a, b) => a < b ? a : b),
                routeCoordinates.map((c) => c.longitude).reduce((a, b) => a < b ? a : b)),
            northeast: LatLng(
                routeCoordinates.map((c) => c.latitude).reduce((a, b) => a > b ? a : b),
                routeCoordinates.map((c) => c.longitude).reduce((a, b) => a > b ? a : b)),
          ),
        ),

      );
      setState(() {

      });
    } catch (e) {
      print('------Error fetching directions: $e');
    }
  }


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {


    if(kDebugMode) {
      print("map start---------------------->");
    }
    return Scaffold(
      body: MapboxMap(
        onMapCreated: _onMapCreated,
        styleString: "mapbox://styles/mapbox/streets-v11",
        initialCameraPosition: const CameraPosition(
          target: LatLng(0.0, 0.0), // Center map on San Francisco
          zoom: 10,
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> getDirections(
      String accessToken, double startLat, double startLng, double endLat, double endLng) async {
    final url =
        'https://api.mapbox.com/directions/v5/mapbox/driving/$startLng,$startLat;$endLng,$endLat?alternatives=false&geometries=geojson&steps=false&access_token=$accessToken';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get directions');
    }
  }

}