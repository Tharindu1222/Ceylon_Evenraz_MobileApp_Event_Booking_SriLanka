import 'package:flutter/material.dart';
import 'package:ceylon/constants/colors.dart';
import 'package:ceylon/screens/admin/createevent.dart';
import 'package:ceylon/screens/admin/manageevent.dart';
import 'package:ceylon/screens/admin/viewbooking_users.dart';
import 'package:ceylon/services/auth.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel"),
        elevation: 0,
        backgroundColor: bgBlack,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthServices().signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/signin', (route) => false);
            },
          ),
        ],
      ),
      backgroundColor: bgBlack,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateEvent()),
                );
              },
              child: const Text("Create Event"),
              style: ElevatedButton.styleFrom(
                backgroundColor: mainYellow, // Custom color from colors.dart
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageEvents()),
                );
              },
              child: const Text("Manage Events"),
              style: ElevatedButton.styleFrom(
                backgroundColor: mainYellow, // Custom color from colors.dart
                padding: EdgeInsets.symmetric(vertical: 20.0),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewBookingsAndUsers()),
                );
              },
              child: const Text("View Bookings and Users"),
              style: ElevatedButton.styleFrom(
                backgroundColor: mainYellow, // Custom color from colors.dart
                padding: EdgeInsets.symmetric(vertical: 20.0),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
