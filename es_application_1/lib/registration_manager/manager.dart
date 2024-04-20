import 'package:flutter/material.dart';
import 'user_info.dart';
import 'set_location.dart';
import '../main_page.dart';

class RegistrationManager extends StatelessWidget {
  final BuildContext context;

  RegistrationManager(this.context);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: startRegistration(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          // Return a default widget if needed
          return SizedBox();
        }
      },
    );
  }

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
