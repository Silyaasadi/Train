import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  Map<String, dynamic>? _trajetData;

  @override
  void initState() {
    super.initState();
    _getTrajetInfo();
  }

  // 🔹 Récupérer les infos du trajet
  Future<void> _getTrajetInfo() async {
    _user = _auth.currentUser;
    if (_user != null) {
      DocumentSnapshot trajetDoc =
      await _firestore.collection("trajets").doc(_user!.uid).get();
      if (trajetDoc.exists) {
        setState(() {
          _trajetData = trajetDoc.data() as Map<String, dynamic>;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Accueil")),
      body: _trajetData == null
          ? Center(child: CircularProgressIndicator()) // ⏳ Chargement
          : Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "🚆 Votre prochain trajet",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow("📍 Départ", _trajetData!["depart"]),
                    _buildInfoRow("📍 Destination", _trajetData!["destination"]),
                    _buildInfoRow("📅 Date", _trajetData!["date"]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
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
