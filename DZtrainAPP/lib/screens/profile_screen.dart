import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:dio/dio.dart'; // ✅ Import Dio
import '../widgets/small_map_widget.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Dio _dio = Dio(); // ✅ Create Dio instance

  User? _user;
  Map<String, dynamic>? _userData;

  // ✅ Coordinates for the map
  final latLng.LatLng startLocation = latLng.LatLng(37.7749, -122.4194);
  final latLng.LatLng destination = latLng.LatLng(37.7849, -122.4094);
  List<latLng.LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _getRoute();
  }

  Future<void> _getUserInfo() async {
    _user = _auth.currentUser;
    if (_user != null) {
      DocumentSnapshot userDoc =
      await _firestore.collection("users").doc(_user!.uid).get();
      if (userDoc.exists) {
        setState(() {
          _userData = userDoc.data() as Map<String, dynamic>;
        });
      }
    }
  }

  Future<void> _getRoute() async {
    final String url =
        "https://router.project-osrm.org/route/v1/foot/${startLocation.longitude},${startLocation.latitude};${destination.longitude},${destination.latitude}?geometries=geojson";

    try {
      final response = await _dio.get(url); // ✅ Use Dio instance
      final data = response.data;

      if (data["routes"].isNotEmpty) {
        List coordinates = data["routes"][0]["geometry"]["coordinates"];
        setState(() {
          polylineCoordinates = coordinates
              .map((coord) => latLng.LatLng(coord[1], coord[0])) // Invert lat/lon
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
      appBar: AppBar(title: Text("Mon Compte")),
      body: _userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            _buildUserInfo("Nom", _userData!["nom"]),
            _buildUserInfo("Prénom", _userData!["prenom"]),
            _buildUserInfo("Email", _userData!["email"]),
            _buildUserInfo("Âge", _userData!["age"]),
            _buildUserInfo("Emploi", _userData!["emploi"]),

            SizedBox(height: 20),
            Text(
              "Localisation",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SmallMapWidget(
              startLocation: startLocation,
              destination: destination,
              polylineCoordinates: polylineCoordinates,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
