import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:dio/dio.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  LatLng? _selectedStartPosition; // Position de départ choisie
  LatLng? _selectedDestination; // Destination choisie
  String? _selectedDate; // Date du trajet
  List<LatLng> _polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  final String _googleApiKey = "AIzaSyCzKWnrTKBVdTIQDzilMqmCcPY6sNH5epA"; // 🔥 Remplace avec ta clé Google Maps API
  Set<Marker> _markers = {};
  String? _selectedStartName; // 🔥 Stocke le nom du domicile sélectionné
  String? _selectedDestinationName; // 🔥 Stocke le nom de la destination sélectionnée

  Future<void> _getRoute() async {
    if (_selectedStartPosition == null || _selectedDestination == null) {
      print("🚨 Sélectionnez un point de départ et une destination !");
      return;
    }

    // 🔥 URL corrigée avec la bonne structure
    final String url =
        "https://router.project-osrm.org/route/v1/train/"
        "${_selectedStartPosition!.longitude},${_selectedStartPosition!.latitude};"
        "${_selectedDestination!.longitude},${_selectedDestination!.latitude}?overview=full&geometries=geojson";

    try {
      final response = await Dio().get(url);
      final data = response.data;

      if (data["routes"].isNotEmpty) {
        List coordinates = data["routes"][0]["geometry"]["coordinates"];

        setState(() {
          _polylineCoordinates.clear();
          _polylineCoordinates.addAll(
            coordinates.map((coord) => LatLng(coord[1], coord[0])),
          );

          _polylines.clear();
          _polylines.add(Polyline(
            polylineId: PolylineId("train_route"),
            color: Colors.blue, // 🔵 Couleur bleue pour le train
            width: 5,
            points: _polylineCoordinates,
          ));
        });
      } else {
        print("🚨 Aucune route trouvée !");
      }
    } catch (e) {
      print("🚨 Erreur lors de la récupération de l'itinéraire : $e");
    }
  }



  // 📌 Liste des gares de train à Alger
  List<Map<String, dynamic>> trainStations = [
    {"name": "Gare de l'Aéroport Houari Boumédiène", "location": LatLng(36.6910, 3.2154)},
    {"name": "Gare de l'Agha", "location": LatLng(36.7649, 3.0535)},
    {"name": "Gare de Aïn Naâdja", "location": LatLng(36.7136, 3.0867)},
    {"name": "Gare d'Alger", "location": LatLng(36.7805, 3.0603)},
    {"name": "Gare des Ateliers", "location": LatLng(36.7481, 3.0866)},
    {"name": "Gare de Bab Ezzouar", "location": LatLng(36.7072, 3.1910)},
    {"name": "Gare de Baba Ali", "location": LatLng(36.6667, 2.9592)},
    {"name": "Gare de Beni Mered", "location": {"lat": 36.5233, "lng": 2.8585}},
    {"name": "Gare de Birtouta", "location": LatLng(36.6372, 2.9597)},
    {"name": "Gare de Blida", "location": {"lat": 36.4808, "lng": 2.8296}},
    {"name": "Gare de Bordj Menaïel", "location": {"lat": 36.7489, "lng": 3.7231}},
    {"name": "Gare de Boudouaou", "location": {"lat": 36.7278, "lng": 3.4094}},
    {"name": "Gare de Boufarik", "location": {"lat": 36.5745, "lng": 2.9101}},
    {"name": "Gare de Boukhalfa", "location": {"lat": 36.7065, "lng": 4.0184}},
    {"name": "Gare de Boumerdès", "location": {"lat": 36.7590, "lng": 3.4740}},
    {"name": "Gare du Caroubier", "location": LatLng(36.7481, 3.0866)},
    {"name": "Gare de Chiffa", "location": {"lat": 36.4464, "lng": 2.7512}},
    {"name": "Gare de Corso", "location": {"lat": 36.7304, "lng": 3.4503}},
    {"name": "Gare de Dar El Beïda", "location": LatLng(36.7043, 3.2125)},
    {"name": "Gare de Draâ Ben Khedda", "location": {"lat": 36.7345, "lng": 3.9633}},
    {"name": "Gare d'El Affroun", "location": {"lat": 36.4664, "lng": 2.6251}},
    {"name": "Gare d'El Harrach", "location": LatLng(36.7131, 3.1529)},
    {"name": "Gare du Gué de Constantine", "location": LatLng(36.7136, 3.0867)},
    {"name": "Gare de Hussein Dey", "location": LatLng(36.7481, 3.0866)},
    {"name": "Gare des Issers", "location": {"lat": 36.7442, "lng": 3.6716}},
    {"name": "Gare de Kef Naâdja", "location": {"lat": 36.6928, "lng": 4.0453}},
    {"name": "Gare de Mouzaïa", "location": {"lat": 36.4667, "lng": 2.7052}},
    {"name": "Gare de Naciria", "location": {"lat": 36.7461, "lng": 3.8319}},
    {"name": "Gare de Oued Aïssi - Université", "location": {"lat": 36.6833, "lng": 4.0667}},
    {"name": "Gare de Oued Aïssi", "location": {"lat": 36.6781, "lng": 4.0833}},
    {"name": "Gare de Oued Smar", "location": LatLng(36.7131, 3.1529)},
    {"name": "Gare de Réghaïa", "location": LatLng(36.7389, 3.3400)},
    {"name": "Gare de Réghaïa ZI", "location": LatLng(36.7389, 3.3400)},
    {"name": "Gare de Rouïba", "location": LatLng(36.7389, 3.2800)},
    {"name": "Gare de Rouïba SNVI", "location": LatLng(36.7389, 3.2800)},
    {"name": "Gare de Rouïba ZI", "location": LatLng(36.7389, 3.2800)},
    {"name": "Gare de Sidi Abdellah", "location": {"lat": 36.6802202, "lng": 2.8921599}},
    {"name": "Gare de Si Mustapha", "location": {"lat": 36.6778, "lng": 3.4094}},
    {"name": "Gare de Tadmaït", "location": {"lat": 36.7447, "lng": 3.9013}},
    {"name": "Gare de Tessala El Merdja", "location": {"lat": 36.639515, "lng": 2.935544}},
    {"name": "Gare de Thénia", "location": {"lat": 36.7361, "lng": 3.6036}},
    {"name": "Gare de Tidjelabine", "location": {"lat": 36.7358, "lng": 3.5456}},
    {"name": "Gare de Tizi Ouzou", "location": {"lat": 36.7118, "lng": 4.0459}},
    {"name": "Gare de Zéralda", "location": LatLng(36.7111, 2.8425)},

  ];


  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  /// 🔥 Obtenir la position actuelle de l'utilisateur
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("🚨 GPS désactivé !");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("🚨 Permission refusée !");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("🚨 Permission bloquée définitivement !");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
      _selectedStartPosition = LatLng(position.latitude, position.longitude);
    });

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(
      LatLng(position.latitude, position.longitude),
      14.0,
    ));
  }

  /// 🔥 Sélecteur de date pour choisir la date du trajet
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  /// 🔥 Mise à jour de la position de départ
  void _updateStartPosition(LatLng position) {
    setState(() {
      _selectedStartPosition = position;
    });

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(position, 14.0));
  }

  /// 🔥 Mise à jour de la destination
  void _updateDestination(LatLng destination) {
    setState(() {
      _selectedDestination = destination;
    });

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(destination, 14.0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌍 Google Map en arrière-plan
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(36.7538, 3.0422),
              zoom: 12.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: {
              if (_selectedStartPosition != null)
                Marker(
                  markerId: MarkerId("start"),
                  position: _selectedStartPosition!,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                ),
              if (_selectedDestination != null)
                Marker(
                  markerId: MarkerId("destination"),
                  position: _selectedDestination!,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                ),
            },
            polylines: _polylines,
          ),

          // 📍 Fenêtre dynamique en bas
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Where would you like to go today?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),

                  // 📌 Choix du domicile
                  _buildLocationSelector(
                    icon: Icons.home,
                    label: "Choose Home Location",
                    onTap: () => _showStartLocationPicker(context),
                    isSelected: _selectedStartPosition != null,
                    selectedValue: _selectedStartName,
                  ),
                  SizedBox(height: 10),

                  // 🎯 Choix de la destination
                  _buildLocationSelector(
                    icon: Icons.train,
                    label: "Choose Train Station",
                    onTap: () => _showDestinationPicker(context),
                    isSelected: _selectedDestination != null,
                    selectedValue: _selectedDestinationName,
                  ),
                  SizedBox(height: 10),

                  // 📅 Sélection de la date
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.black54),
                            SizedBox(width: 8),
                            Text(
                              _selectedDate ?? "Today",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Text("1 Passenger", style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),

                  // 🔍 Bouton de recherche
                  ElevatedButton(
                    onPressed:_getRoute,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Center(
                      child: Text("Search", style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _showStartLocationPicker(BuildContext context) async {
    String? choice = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Définir votre domicile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.my_location),
                title: Text("Utiliser ma position actuelle"),
                onTap: () => Navigator.pop(context, "current"),
              ),
              ListTile(
                leading: Icon(Icons.train),
                title: Text("Choisir une gare"),
                onTap: () => Navigator.pop(context, "station"),
              ),
            ],
          ),
        );
      },
    );

    if (choice == "current") {
      await _setGpsLocation(); // Utiliser la position actuelle
    } else if (choice == "station") {
      await _selectTrainStation(context); // Ouvrir la liste des gares
    }
  }

  /// 🔥 Fonction pour sélectionner une gare
  Future<void> _selectTrainStation(BuildContext context) async {
    String? selectedStation = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sélectionner une gare"),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: trainStations.map((station) {
                return ListTile(
                  title: Text(station["name"]),
                  onTap: () => Navigator.pop(context, station["name"]),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (selectedStation != null) {
      var selectedStationData = trainStations.firstWhere(
            (station) => station["name"] == selectedStation,
      );

      setState(() {
        _selectedStartPosition = selectedStationData["location"];
        _selectedStartName = selectedStation;
        // Supprime l'ancien marqueur du domicile
        _markers.removeWhere((m) => m.markerId.value == "start");

        // Ajouter un marqueur vert pour la gare sélectionnée
        _markers.add(
          Marker(
            markerId: MarkerId("start"),
            position: _selectedStartPosition!,
            infoWindow: InfoWindow(title: selectedStation),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          ),
        );
      });

      // Déplacer la caméra vers la gare sélectionnée
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_selectedStartPosition!, 14),
      );
    }
  }

  /// 🔥 Get the user's current location and set it as the start position
  Future<void> _setGpsLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("🚨 GPS is disabled!");
      return;
    }

    // Check for permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        print("🚨 Location permission permanently denied!");
        return;
      }
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _selectedStartPosition = LatLng(position.latitude, position.longitude);

      // Remove previous start marker
      _markers.removeWhere((m) => m.markerId.value == "start");

      // Add new marker for current location
      _markers.add(
        Marker(
          markerId: MarkerId("start"),
          position: _selectedStartPosition!,
          infoWindow: InfoWindow(title: "Current Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    });

    // Move camera to new location
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_selectedStartPosition!, 14),
    );
  }


  void _showDestinationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        children: trainStations.map((station) {
          return ListTile(
            title: Text(station["name"]),
            onTap: () {
              _updateDestination(station["location"]);
              _selectedDestinationName = station["name"];
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}
/// 🔥 Widget for selecting home or destination
Widget _buildLocationSelector({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  required bool isSelected,
  String? selectedValue,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
          SizedBox(width: 10),
         /*
          Text(label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),*/
          Expanded(
            child: Text(
              selectedValue ?? label, // ✅ Afficher le nom sélectionné
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}


























