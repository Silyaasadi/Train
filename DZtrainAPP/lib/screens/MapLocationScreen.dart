import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:dio/dio.dart';

class MapLocationScreen extends StatefulWidget {
  @override
  MapLocationScreenState createState() => MapLocationScreenState();
}

class MapLocationScreenState extends State<MapLocationScreen> {
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
              .map((coord) => latLng.LatLng(coord[1], coord[0]))
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
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
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
                              child: Icon(Icons.location_pin, color: Colors.red, size: 40),
                            ),
                            Marker(
                              point: destination,
                              width: 40,
                              height: 40,
                              child: Icon(Icons.location_pin, color: Colors.blue, size: 40),
                            ),
                          ],
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search location",
                  prefixIcon: Icon(Icons.search, color: Colors.black54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Where would you like to go today?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Home"),
                      Icon(Icons.swap_vert, color: Colors.blueAccent),
                      Text("Airport"),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Today", style: TextStyle(color: Colors.grey)),
                      Text("1 Passenger", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      print("Search clicked");
                    },
                    child: Text("Search", style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
