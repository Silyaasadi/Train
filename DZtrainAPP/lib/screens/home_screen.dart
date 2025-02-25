import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> stations = [
    "Alger",
    "El Harrach",
    "Bab Ezzouar",
    "Dar El Beïda",
    "Oued Smar",
    "Bordj El Kiffan",
    "El Djorf",
    "Rouiba",
    "Réghaïa",
    "Boudouaou",
    "Corso",
    "Thenia"
  ];

  Map<String, latLng.LatLng> stationCoordinates = {
    "Alger": latLng.LatLng(36.7538, 3.0422),
    "El Harrach": latLng.LatLng(36.7255, 3.1135),
    "Bab Ezzouar": latLng.LatLng(36.7131, 3.1529),
    "Dar El Beïda": latLng.LatLng(36.7052, 3.1910),
    "Oued Smar": latLng.LatLng(36.7040, 3.1345),
    "Bordj El Kiffan": latLng.LatLng(36.7469, 3.1928),
    "El Djorf": latLng.LatLng(36.7400, 3.2100),
    "Rouiba": latLng.LatLng(36.7380, 3.2800),
    "Réghaïa": latLng.LatLng(36.7485, 3.3400),
    "Boudouaou": latLng.LatLng(36.7300, 3.4100),
    "Corso": latLng.LatLng(36.7305, 3.4700),
    "Thenia": latLng.LatLng(36.7509, 3.8189),
  };

  String? selectedDepart;
  String? selectedDestination;
  DateTime? selectedDate;
  List<latLng.LatLng> polylineCoordinates = [];
  bool isExpanded = false;

  Future<void> _getRoute() async {
    if (selectedDepart == null || selectedDestination == null) return;

    latLng.LatLng? startLocation = stationCoordinates[selectedDepart];
    latLng.LatLng? endLocation = stationCoordinates[selectedDestination];

    if (startLocation == null || endLocation == null) return;

    final String url =
        "https://router.project-osrm.org/route/v1/driving/${startLocation.longitude},${startLocation.latitude};${endLocation.longitude},${endLocation.latitude}?geometries=geojson";

    try {
      final response = await Dio().get(url);
      final data = response.data;

      if (data["routes"].isNotEmpty) {
        List coordinates = data["routes"][0]["geometry"]["coordinates"];
        setState(() {
          polylineCoordinates = coordinates
              .map((coord) => latLng.LatLng(coord[1], coord[0]))
              .toList();
        });
      }
    } catch (e) {
      print("Erreur lors de la récupération de l'itinéraire : $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double minHeight = 250;
    double maxHeight = MediaQuery.of(context).size.height * 0.5;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: isExpanded ? maxHeight : MediaQuery.of(context).size.height - minHeight - 50,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: stationCoordinates["Alger"]!,
                  initialZoom: 10.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: polylineCoordinates,
                        strokeWidth: 5.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  // Ajout des marqueurs (Domicile & Destination)
                  MarkerLayer(
                    markers: _getMarkers(),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: isExpanded ? minHeight : maxHeight,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    isExpanded ? Icons.expand_more : Icons.expand_less,
                    size: 30,
                  ),
    DropdownButton<String>(
    value: selectedDepart,
    hint: Text("Select departure station"),
    isExpanded: true,
    items: stations.map((station) {
    return DropdownMenuItem(
    value: station,
    child: Text(station),
    );
    }).toList(),
    onChanged: (value) {
    setState(() {
    selectedDepart = value;
    });
    _getRoute(); // Mettre à jour le chemin dès la sélection
    },
    ),

    DropdownButton<String>(
    value: selectedDestination,
    hint: Text("Select destination station"),
    isExpanded: true,
    items: stations.map((station) {
    return DropdownMenuItem(
    value: station,
    child: Text(station),
    );
    }).toList(),
    onChanged: (value) {
    setState(() {
    selectedDestination = value;
    });
    _getRoute(); // Mettre à jour le chemin dès la sélection
    },
    ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedDate == null
                                ? "Select travel date"
                                : DateFormat('yyyy-MM-dd').format(selectedDate!),
                          ),
                          Icon(Icons.calendar_today, color: Colors.blueAccent),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _getRoute,
                    child: Text("Search"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  List<Marker> _getMarkers() {
    List<Marker> markers = [];

    // Ajouter un rond bleu pour la station de départ (Domicile)
    if (selectedDepart != null) {
      markers.add(
        Marker(
          point: stationCoordinates[selectedDepart]!,
          width: 30,
          height: 30,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue, // Rond bleu
            ),
          ),
        ),
      );
    }

    // Ajouter une épingle rouge pour la destination
    if (selectedDestination != null) {
      markers.add(
        Marker(
          point: stationCoordinates[selectedDestination]!,
          width: 40,
          height: 40,
          child: Icon(
            Icons.location_pin,
            color: Colors.red, // Épingle rouge
            size: 40,
          ),
        ),
      );
    }

    return markers;
  }
  }