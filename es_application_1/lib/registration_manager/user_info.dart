import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'set_location.dart';

class PersonalDataPage extends StatefulWidget {
  @override
  _PersonalDataPageState createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  DateTime? _selectedDate;
  List<String> _selectedInterests = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = null; // Reset the selected date when the widget is initialized
  }

  Future<void> _submitPersonalData(BuildContext context) async {
  try {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _selectedDate == null ||
        _selectedInterests.isEmpty) {
      throw Exception('Please fill in all required fields.');
    }

    // Retrieve user information
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Use user.uid as the document ID
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'birthday': _selectedDate,
        'interests': _selectedInterests,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Personal data submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AskDistance()),
      );
    } else {
      throw Exception('User not found.');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to submit personal data. Please try again.'),
        backgroundColor: Colors.red,
      ),
    );
    print('Error submitting personal data: $e');
  }
}


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900,1,1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Enter Personal Data'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name *'),
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name *'),
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 20.0),
            GestureDetector(
            onTap: () {
              Future.microtask(() {
                _selectDate(context);
              });
            },
            child: AbsorbPointer(
              child: TextField(
                controller: TextEditingController(text: _selectedDate != null ? _selectedDate.toString().substring(0, 10) : ''),
                decoration: InputDecoration(labelText: 'Birthday *'),
              ),
            ),
          ),

            SizedBox(height: 20.0),
            Text(
              'Areas of Interest *',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Wrap(
              spacing: 8.0,
              children: [
                _buildInterestChip('Clean Beaches'),
                _buildInterestChip('Public Parks'),
                _buildInterestChip('Food Distribution'),
                _buildInterestChip('Elderly Assistance'),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _submitPersonalData(context),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestChip(String interest) {
    final isSelected = _selectedInterests.contains(interest);
    return FilterChip(
      label: Text(interest),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            if (_selectedInterests.length < 4) {
              _selectedInterests.add(interest);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('You can select up to 4 interests.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else {
            _selectedInterests.remove(interest);
          }
        });
      },
    );
  }
}
