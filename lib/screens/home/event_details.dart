import 'package:flutter/material.dart';
import 'package:ceylon/constants/colors.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ticket_booking.dart';

class EventDetails extends StatefulWidget {
  final String eventName;
  final String location;
  final String date;
  final String time;
  final String description;

  const EventDetails({
    Key? key,
    required this.eventName,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
  }) : super(key: key);

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  String review = ''; // State variable to store the user's review

  // Controller for review input
  final writereviewController = TextEditingController();

  // Function to handle submitting review
  void submitReview() {
    String trimmedReview = review.trim();
    if (trimmedReview.isNotEmpty) {
      // Firestore operation to add review
      CollectionReference collRef =
          FirebaseFirestore.instance.collection('review');
      collRef.add({'reviews': trimmedReview});

      // Clear review text field and reset state
      writereviewController.clear();
      setState(() {
        review = '';
      });

      // Show confirmation or success message (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review submitted successfully!'),
        ),
      );
    } else {
      // Show error message if review is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write a review before submitting.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventName),
        elevation: 0,
        backgroundColor: bgBlack,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: bgBlack,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.eventName,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text("Location: ${widget.location}",
                    style: const TextStyle(color: Colors.white, fontSize: 20)),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text("Date: ${widget.date}",
                    style: const TextStyle(color: Colors.white, fontSize: 20)),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text("Time: ${widget.time}",
                    style: const TextStyle(color: Colors.white, fontSize: 20)),
              ),
              const SizedBox(height: 20),
              Text(
                widget.description,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TicketBooking(
                          eventName: widget.eventName,
                        ),
                      ),
                    );
                  },
                  child: const Text("Book Tickets"),
                  style: ElevatedButton.styleFrom(backgroundColor: mainYellow),
                ),
              ),
              const SizedBox(height: 100),
              TextField(
                controller: writereviewController,
                onChanged: (value) {
                  setState(() {
                    review = value;
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Write your review...',
                  hintStyle: TextStyle(color: Colors.white54),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    submitReview();
                  },
                  child: const Text("Submit Review"),
                  style: ElevatedButton.styleFrom(backgroundColor: mainYellow),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Share.share(
                        'Check out this event: ${widget.eventName}\nLocation: ${widget.location}\nDate: ${widget.date}\nTime: ${widget.time}\nDescription: ${widget.description}',
                      );
                    },
                    icon: Icon(Icons.share),
                    color: Colors.green,
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () {
                      final String eventLink =
                          'example.com/event/${widget.eventName.replaceAll(' ', '-')}';
                      Clipboard.setData(ClipboardData(text: eventLink));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Event link copied to clipboard'),
                        ),
                      );
                    },
                    icon: Icon(Icons.link),
                    color: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
