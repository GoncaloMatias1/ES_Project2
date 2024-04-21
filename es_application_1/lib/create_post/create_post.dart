import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'location_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  LatLng? _selectedLocation;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  TextEditingController _activityNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  List<String> _selectedCategories = [];
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      DocumentSnapshot categoriesDoc =
          await FirebaseFirestore.instance.collection('categories').doc('categories').get();
      List<String> categories = List<String>.from(categoriesDoc.get('name'));
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  void _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime firstSelectableDate = currentDate.add(Duration(days: 3));

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate.isBefore(firstSelectableDate) ? firstSelectableDate : currentDate,
      firstDate: firstSelectableDate, // At least 3 days from today
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != _startTime) {
      setState(() {
        _startTime = pickedTime;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != _endTime) {
      setState(() {
        _endTime = pickedTime;
      });
    }
  }


  void _submitPost() {
    if (_selectedDate != null &&
        _activityNameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedLocation != null &&
        _selectedCategories.isNotEmpty &&
        _startTime != null &&
        _endTime != null &&
        _endTime!.hour > _startTime!.hour) {
      // For now, just printing the data
      print('Activity Name: ${_activityNameController.text}');
      print('Description: ${_descriptionController.text}');
      print('Date: $_selectedDate');
      print('Start Time: $_startTime');
      print('End Time: $_endTime');
      print('Location: $_selectedLocation');
      print('Selected Categories: $_selectedCategories');
    } else {
      // Show an error message indicating that all fields are required or the time selection is invalid
      String errorMessage = 'All fields are required.';
      if (_endTime != null && _startTime != null && _endTime!.hour <= _startTime!.hour) {
        errorMessage = 'End time must be greater than start time.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _updateLocation(LatLng newLocation) {
    setState(() {
      _selectedLocation = newLocation;
      _locationController.text = '${newLocation.latitude}, ${newLocation.longitude}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Post'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _activityNameController,
                decoration: InputDecoration(
                  labelText: 'Activity Name *',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description *',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                onTap: () {
                  _selectDate(context);
                },
                readOnly: true,
                controller: TextEditingController(
                  text: _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : '',
                ),
                decoration: InputDecoration(
                  labelText: 'When will it happen *',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onTap: () {
                        _selectStartTime(context);
                      },
                      readOnly: true,
                      controller: TextEditingController(
                        text: _startTime != null ? _startTime!.format(context) : '',
                      ),
                      decoration: InputDecoration(
                        labelText: 'Start Time *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      onTap: () {
                        _selectEndTime(context);
                      },
                      readOnly: true,
                      controller: TextEditingController(
                        text: _endTime != null ? _endTime!.format(context) : '',
                      ),
                      decoration: InputDecoration(
                        labelText: 'End Time *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _locationController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Location *',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  final selectedLocation = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocationPicker(
                        onLocationSelected: _updateLocation,
                      ),
                    ),
                  );
                  if (selectedLocation != null && selectedLocation is LatLng) {
                    _updateLocation(selectedLocation);
                  }
                },
                child: Text('Choose Location'),
              ),
              SizedBox(height: 16.0),
              Text(
                'Categories *',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Wrap(
                spacing: 8.0,
                children: _categories.map((category) => _buildCategoryChip(category)).toList(),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitPost,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategories.contains(category);
    return FilterChip(
      label: Text(category),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            _selectedCategories.add(category);
          } else {
            _selectedCategories.remove(category);
          }
        });
      },
    );
  }
}
