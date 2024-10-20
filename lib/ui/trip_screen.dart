import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/trip_db.dart';
import '../utils/constant.dart';
import 'map_element_widget.dart';

class TripScreen extends StatefulWidget {
  TripScreen({super.key});



  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  String startLocation = "";
  String startPlace = "";
  double startLatitude = 0.0;
  double startLongitude = 0.0;

  String endPlace = "";
  double endLatitude = 0.0;
  double endLongitude = 0.0;

  bool isSave = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // isSave = widget.isSave;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    startLatitude = data['startLatitude'];
    startLongitude = data['startLongitude'];
    endLatitude = data['endLatitude'];
    endLongitude = data['endLongitude'];
    startPlace = data['startPlace'];
    endPlace = data['endPlace'];
    isSave = data['isSave'];




    print("startLatitude $startLatitude");
    print("data ${data.toString()}");

    return MaterialApp(
        title: 'Trip Screen',
        home: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(230.0),
              child: Center(
                child: Container(
                  decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 8 / 2.5),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            startLocation,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                          ),
                          Text(
                            startPlace,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            '$startLatitude, $startLongitude',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            endPlace,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            '$endLatitude, $endLongitude',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
          body: Container(
            child: MapElementWidget(
              args: data,
            ),
          ),
          bottomNavigationBar: Container(
            height: 80,
            color: primaryColor,
            child: Center(
              child: TextButton(
                  onPressed: () {
                    onSaveTrip();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child:  Text(
                    isSave ? 'Save' : 'GoBack',
                    style: const TextStyle(color: primaryColor),
                  )),
            ),
          ),
        ));
  }

  void onSaveTrip() {
    if(isSave) {
      TripDB.createUser({
        "startLocation": startLocation,
        "startPlace": startPlace,
        "startLatitude": startLatitude,
        "startLongitude": startLongitude,
        "endPlace": endPlace,
        "endLatitude": endLatitude,
        "endLongitude": endLongitude
      });
    }



    Navigator.of(context).pop();
  }
}
