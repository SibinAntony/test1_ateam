import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:test1/provider/home_provider.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:test1/ui/home_screen.dart';
import 'package:test1/ui/map_element_widget.dart';
import 'package:test1/ui/saved_trips_screen.dart';
import 'package:test1/ui/trip_screen.dart';
import 'package:test1/utils/constant.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // MapboxOptions.setAccessToken(ACCESS_TOKEN);

  // String ACCESS_TOKEN = String.fromEnvironment("ACCESS_TOKEN");
  // MapboxOptions.setAccessToken(ACCESS_TOKEN);

  await Hive.initFlutter();
  await Hive.openBox(tripHiveBox);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: HomeProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      initialRoute: '/home_screen',
      routes: {
        '/home_screen': (context) => const HomeScreen(),
        '/trip_screen': (context) =>  TripScreen(),
        '/saved_trip_screen': (context) => const SavedTripScreen(),
      },
      // home: const HomeScreen(),
    );
  }
}


