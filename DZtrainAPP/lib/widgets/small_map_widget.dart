import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;

class SmallMapWidget extends StatelessWidget {
  final latLng.LatLng startLocation;
  final latLng.LatLng destination;
  final List<latLng.LatLng> polylineCoordinates;

  SmallMapWidget({
    required this.startLocation,
    required this.destination,
    required this.polylineCoordinates,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Taille réduite pour affichage dans ProfileScreen
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: startLocation,
            initialZoom: 13.0,
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
                  width: 30,
                  height: 30,
                  child: Icon(Icons.location_on, color: Colors.red, size: 30),
                ),
                Marker(
                  point: destination,
                  width: 30,
                  height: 30,
                  child: Icon(Icons.location_on, color: Colors.blue, size: 30),
                ),
              ],
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: polylineCoordinates,
                  strokeWidth: 3.0,
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
