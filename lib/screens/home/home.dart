import 'package:ceylon/constants/colors.dart';
import 'package:ceylon/models/UserModel.dart';
import 'package:ceylon/screens/admin/adminpanel.dart';
import 'package:ceylon/screens/athentication/athenticate.dart';
import 'package:ceylon/screens/home/event_details.dart';
import 'package:flutter/material.dart';
import 'package:ceylon/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      initialData: null,
      value: AuthServices().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: bgBlack,
          scaffoldBackgroundColor: bgBlack,
        ),
        home: Wrapper(),
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    // Return either Authenticate or Home widget based on the user's authentication status
    if (user == null) {
      return Authenticate();
    } else {
      return user.email == "admin@gmail.com" ? AdminPanel() : Home();
    }
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ceylon EventraZ"),
        elevation: 0,
        backgroundColor: bgBlack,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthServices().signOut();
            },
          ),
        ],
      ),
      backgroundColor: bgBlack,
      body: EventList(),
    );
  }
}

class EventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('events').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final events = snapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];

            return Column(
              children: [
                EventCard(
                  eventName: event['eventName'],
                  location: event['location'],
                  date: event['date'],
                  time: event['time'],
                  description: event['description'],
                  imagePath: event['imagePath'],
                ),
                SizedBox(height: 10), // Add gap between event cards
              ],
            );
          },
        );
      },
    );
  }
}

class EventCard extends StatelessWidget {
  final String eventName;
  final String location;
  final String date;
  final String time;
  final String description;
  final String imagePath;

  const EventCard({
    required this.eventName,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetails(
              eventName: eventName,
              location: location,
              date: date,
              time: time,
              description: description,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          imagePath.isEmpty
              ? Container(
                  color: Colors.grey,
                  height: 250,
                  width: double.infinity,
                  child: const Center(
                      child: Text('No image available',
                          style: TextStyle(color: Colors.white))),
                )
              : Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                  height: 250,
                  width: double.infinity,
                ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black54,
              padding: EdgeInsets.all(8.0),
              child: Text(
                eventName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
