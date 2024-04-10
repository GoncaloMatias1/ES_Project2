import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AskDistance extends StatefulWidget {
  @override
  _AskDistanceState createState() => _AskDistanceState();
}

class _AskDistanceState extends State<AskDistance> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _distanceController = TextEditingController();
  double _sliderValue = 5;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Position? _currentLocation;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _distanceController.text = _sliderValue.toStringAsFixed(0);
    _checkPermissionAndGetCurrentLocation();
  }

  Future<void> _checkPermissionAndGetCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        // Handle the case when the user denied or permanently denied the permission
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle the case when the user permanently denied the permission
      return;
    }

    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = position;
        _moveToCurrentLocation();
      });
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  void _moveToCurrentLocation() {
    if (_mapController != null && _currentLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
            zoom: 14,
          ),
        ),
      );
    }
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedLocation = position;
      _markers.clear();
      _markers.add(Marker(markerId: MarkerId('selectedLocation'), position: position));
    });
  }

  void _onUseCurrentLocation() {
    setState(() {
      _markers.clear(); // Clear existing markers
      _selectedLocation = null; // Reset selected location

      // Fetch current location
      _checkPermissionAndGetCurrentLocation().then((_) {
        // Set marker at the current location
        if (_currentLocation != null) {
          _markers.add(Marker(
            markerId: MarkerId('currentLocation'),
            position: LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
          ));
        }
      });
    });
  }

  void _saveUserData() {
    if (_selectedLocation != null || _markers.isNotEmpty) {
      LatLng? location;
      if (_selectedLocation != null) {
        location = _selectedLocation;
      } else if (_markers.isNotEmpty) {
        location = _markers.first.position;
      }

      if (location != null) {
        // Retrieve user information
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Store data in the database
          String userId = user.uid;
          double distance = _sliderValue;
          double latitude = location.latitude;
          double longitude = location.longitude;
          // Store the data in the database
          print('User ID: $userId, Distance: $distance km, Latitude: $latitude, Longitude: $longitude');

          // Add your database storage logic here
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please select a location on the map.'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a location on the map.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Ask Distance'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16),
          Text(
            'Choose the distance',
            style: TextStyle(fontSize: 20, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: Colors.green[800],
                    inactiveTrackColor: Colors.green[700],
                    thumbColor: Colors.green[200],
                  ),
                  child: Slider(
                    value: _sliderValue,
                    min: 5,
                    max: 50,
                    divisions: 45,
                    label: '${_sliderValue.round()} km',
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                        _distanceController.text = _sliderValue.toStringAsFixed(0);
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 8),
              Padding(
                padding: EdgeInsets.only(right: 16.0), // Ajuste o espaçamento à direita conforme necessário
                child: Text(
                  '${_sliderValue.round()} km', style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Select the location',
            style: TextStyle(fontSize: 20, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(37.7749, -122.4194),
                    zoom: 12,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    setState(() {
                      _mapController = controller;
                    });
                  },
                  onTap: _onMapTap,
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false, // Remove o botão padrão de localização atual
                ),
                Positioned(
                  top: 16.0,
                  left: 16.0,
                  child: ElevatedButton(
                    onPressed: _onUseCurrentLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Use current location'),
                  ),
                ),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: _saveUserData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[800],
              foregroundColor: Colors.white,
            ),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AskDistance(),
  ));
}
