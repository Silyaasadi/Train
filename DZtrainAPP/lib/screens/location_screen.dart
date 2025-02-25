import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:dio/dio.dart';

class LocationScreen extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<LocationScreen> {
  final latLng.LatLng startLocation = latLng.LatLng(37.7749, -122.4194);
  final latLng.LatLng destination = latLng.LatLng(37.7849, -122.4094);
  List<latLng.LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    _getRoute();
  }

  Future<void> _getRoute() async {
    final String url =
        "https://router.project-osrm.org/route/v1/foot/${startLocation.longitude},${startLocation.latitude};${destination.longitude},${destination.latitude}?geometries=geojson";

    try {
      final response = await Dio().get(url);
      final data = response.data;

      if (data["routes"].isNotEmpty) {
        List coordinates = data["routes"][0]["geometry"]["coordinates"];
        setState(() {
          polylineCoordinates = coordinates
              .map((coord) => latLng.LatLng(coord[1], coord[0])) // Inverser lat/lon
              .toList();
        });
      }
    } catch (e) {
      print("Erreur lors de la récupération de l'itinéraire : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Carte de localisation")),
      body: Column(
        children: [
          // La carte prend tout l'espace disponible
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: startLocation,
                initialZoom: 14.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: startLocation,
                      width: 40,
                      height: 40,
                      child: Icon(Icons.location_on, color: Colors.red, size: 40),
                    ),
                    Marker(
                      point: destination,
                      width: 40,
                      height: 40,
                      child: Icon(Icons.location_on, color: Colors.blue, size: 40),
                    ),
                  ],
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: polylineCoordinates,
                      strokeWidth: 4.0,
                      color: Colors.greenAccent,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // La section du bas reste visible
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Informations sur la localisation",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    print("Bouton cliqué");
                  },
                  child: Text("Voir plus de détails"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
