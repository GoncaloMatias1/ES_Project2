import 'package:flutter/material.dart';
import 'user_info.dart';
import 'set_location.dart';
import '../main_page.dart';

class RegistrationManager {
  final BuildContext context;

  RegistrationManager(this.context);

  Future<void> startRegistration() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PersonalDataPage()),
    );
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AskDistance()),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }
}
