import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ceylon/constants/colors.dart'; // Import your custom colors

class ViewBookingsAndUsers extends StatelessWidget {
  const ViewBookingsAndUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        backgroundColor: bgBlack, // Using bgBlack from your custom colors
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: bgBlack, // Using bgBlack from your custom colors
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var event = snapshot.data!.docs[index];
              var data = event.data() as Map<String, dynamic>;
              String eventName = data.containsKey('eventName')
                  ? data['eventName']
                  : 'Unknown Event';

              return ListTile(
                title: Text(
                  eventName,
                  style: const TextStyle(color: Colors.white), // Text color
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventBookings(eventName: eventName),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class EventBookings extends StatelessWidget {
  final String eventName;

  const EventBookings({Key? key, required this.eventName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$eventName - Bookings",
          style: const TextStyle(color: Colors.white), // Text color
        ),
        backgroundColor: bgBlack,
        iconTheme: const IconThemeData(
            color: Colors.white), // Using bgBlack from your custom colors
      ),
      backgroundColor: bgBlack, // Using bgBlack from your custom colors
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('eventName', isEqualTo: eventName)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var booking = snapshot.data!.docs[index];
              var data = booking.data() as Map<String, dynamic>;

              String user =
                  data.containsKey('user') ? data['user'] : 'Unknown User';
              String tickets = '';

              if (data.containsKey('normalTickets')) {
                tickets += '${data['normalTickets']} Normal, ';
              }
              if (data.containsKey('vipTickets')) {
                tickets += '${data['vipTickets']} VIP, ';
              }
              if (data.containsKey('vvipTickets')) {
                tickets += '${data['vvipTickets']} VVIP';
              }

              // Additional user details
              String nationalIdentityCard = data.containsKey('userIdentityCard')
                  ? data['userIdentityCard']
                  : 'Unknown';

              return ListTile(
                title: Text(
                  user,
                  style: const TextStyle(color: Colors.white), // Text color
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tickets: $tickets',
                      style:
                          const TextStyle(color: Colors.white70), // Text color
                    ),
                    Text(
                      'National Identity Card: $nationalIdentityCard',
                      style:
                          const TextStyle(color: Colors.white70), // Text color
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
