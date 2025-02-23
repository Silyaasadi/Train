import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  String? _selectedDepart;
  String? _selectedDestination;
  DateTime? _selectedDate;

  List<String> trainStops = [
    "Gare d'Alger",
    "Agha",
    "Ateliers",
    "Hussein Dey",
    "Caroubier",
    "El Harrach",
    "Oued Smar",
    "Bab Ezzouar",
    "Dar El Beïda",
    "Rouiba",
    "Rouiba Ind",
    "Reghaia",
    "Reaghaia Ind",
    "Boudouaou",
    "Corso",
    "Boumerdes",
    "Tidjelabin",
    "Thenia",

    "Bordj El Kiffan",
    "Bordj El Bahri",
    "El Djemila",
    "Zeralda",
    "Blida",
    "Boufarik",
    "Birtouta"
  ];

  @override
  void initState() {
    super.initState();
    _loadTrajetInfo();
  }

  Future<void> _loadTrajetInfo() async {
    _user = _auth.currentUser;
    if (_user != null) {
      try {
        DocumentSnapshot trajetDoc =
        await _firestore.collection("trajets").doc(_user!.uid).get();
        if (trajetDoc.exists) {
          Map<String, dynamic> data = trajetDoc.data() as Map<String, dynamic>;
          setState(() {
            _selectedDepart = data["depart"];
            _selectedDestination = data["destination"];
            if (data["date"] != null) {
              _selectedDate = DateTime.parse(data["date"]);
            }
          });
        }
      } catch (e) {
        print("Erreur lors du chargement des trajets: $e");
      }
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "📅 Today";
    return DateFormat('dd MMM yyyy', 'fr_FR').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 20,
                right: 20,
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search location",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Where would you like to go today?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildDropdownField("Départ", _selectedDepart, (String? newValue) {
                          setState(() {
                            _selectedDepart = newValue;
                          });
                        }),
                        _buildDropdownField("Destination", _selectedDestination, (String? newValue) {
                          setState(() {
                            _selectedDestination = newValue;
                          });
                        }),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickDate,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.blue),
                          SizedBox(width: 5),
                          Text(_formatDate(_selectedDate)),
                        ],
                      ),
                      Text("1 Passenger", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text("Search"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, String? selectedValue, Function(String?) onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: trainStops.map((String stop) {
          return DropdownMenuItem<String>(
            value: stop,
            child: Text(stop),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
