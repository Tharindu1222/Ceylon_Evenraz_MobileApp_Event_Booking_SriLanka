import 'package:ceylon/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TicketBooking extends StatefulWidget {
  final String eventName;

  const TicketBooking({Key? key, required this.eventName}) : super(key: key);

  @override
  _TicketBookingState createState() => _TicketBookingState();
}

class _TicketBookingState extends State<TicketBooking> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _eventData;

  // Track selected ticket counts for each ticket type
  int _selectedNormalTicketCount = 0;
  int _selectedVipTicketCount = 0;
  int _selectedVvipTicketCount = 0;

  // Controllers for user input fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController identityCardController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _eventData = _fetchEventData();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchEventData() async {
    // Fetch event document based on eventName
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('events')
        .where('eventName', isEqualTo: widget.eventName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    } else {
      throw Exception('Event not found');
    }
  }

  String _calculateTotalPrice(double price1, double price2, double price3) {
    double totalPrice = (_selectedNormalTicketCount * price1) +
        (_selectedVipTicketCount * price2) +
        (_selectedVvipTicketCount * price3);
    return totalPrice.toStringAsFixed(2);
  }

  void _confirmBooking(double totalPrice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Booking',
              style: TextStyle(color: Colors.white)),
          backgroundColor: bgBlack,
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Price: \$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'First Name',
                        labelStyle: TextStyle(color: Colors.white)),
                    controller: firstNameController,
                    style: const TextStyle(color: Colors.white),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First Name is required';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: TextStyle(color: Colors.white)),
                    controller: lastNameController,
                    style: const TextStyle(color: Colors.white),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Last Name is required';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'National Identity Card Number',
                        labelStyle: TextStyle(color: Colors.white)),
                    controller: identityCardController,
                    style: const TextStyle(color: Colors.white),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'National Identity Card Number is required';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Address',
                        labelStyle: TextStyle(color: Colors.white)),
                    controller: addressController,
                    style: const TextStyle(color: Colors.white),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'City',
                        labelStyle: TextStyle(color: Colors.white)),
                    controller: cityController,
                    style: const TextStyle(color: Colors.white),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Postal Code',
                        labelStyle: TextStyle(color: Colors.white)),
                    controller: postalCodeController,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveBookingWithUserDetails(totalPrice);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Confirm'),
              style: ElevatedButton.styleFrom(backgroundColor: mainYellow),
            ),
          ],
        );
      },
    );
  }

  void _saveBookingWithUserDetails(double totalPrice) async {
    try {
      await FirebaseFirestore.instance.collection('bookings').add({
        'eventName': widget.eventName,
        'normalTickets': _selectedNormalTicketCount,
        'vipTickets': _selectedVipTicketCount,
        'vvipTickets': _selectedVvipTicketCount,
        'totalPrice': totalPrice,
        'user': '${firstNameController.text} ${lastNameController.text}',
        'userIdentityCard': identityCardController.text,
        'userAddress': addressController.text,
        'userCity': cityController.text,
        'userPostalCode': postalCodeController.text,
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Booking Confirmed!',
                style: TextStyle(color: Colors.white)),
            backgroundColor: bgBlack,
            content: Text('Total Price: \$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Pay Now',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error saving booking: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ticket Booking - ${widget.eventName}"),
        elevation: 0,
        backgroundColor: bgBlack,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: bgBlack,
      body: FutureBuilder(
        future: _eventData,
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.data() == null) {
            return Center(
                child: Text('Event not found',
                    style: const TextStyle(color: Colors.white)));
          } else {
            var eventData = snapshot.data!.data()!;
            var price1 = eventData['price_1'];
            var price2 = eventData['price_2'];
            var price3 = eventData['price_3'];
            var totalPrice = _calculateTotalPrice(price1, price2, price3);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Ticket Prices:",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                          ),
                          padding: EdgeInsets.all(10),
                          child: _buildTicketInfo(
                            "Normal",
                            price1,
                            eventData['availableTickets_1'],
                            _selectedNormalTicketCount,
                            (value) {
                              setState(() {
                                _selectedNormalTicketCount = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                          ),
                          padding:
                              EdgeInsets.all(10), // Adjust padding as needed
                          child: _buildTicketInfo(
                            "VIP",
                            price2,
                            eventData['availableTickets_2'],
                            _selectedVipTicketCount,
                            (value) {
                              setState(() {
                                _selectedVipTicketCount = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                          ),
                          padding: EdgeInsets.all(10),
                          child: _buildTicketInfo(
                            "VVIP",
                            price3,
                            eventData['availableTickets_3'],
                            _selectedVvipTicketCount,
                            (value) {
                              setState(() {
                                _selectedVvipTicketCount = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "Total Price: \$${totalPrice}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () =>
                                _confirmBooking(double.parse(totalPrice)),
                            child: const Text("Confirm Booking"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: mainYellow),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildTicketInfo(String ticketName, double price, int availableTickets,
      int selectedCount, ValueChanged<int?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(ticketName,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Text(
            'Price: \$${price.toStringAsFixed(2)}, Available Tickets: $availableTickets',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Select Ticket Count:",
                style: const TextStyle(color: Colors.white)),
            DropdownButton<int>(
              value: selectedCount,
              dropdownColor: bgBlack,
              items: List.generate(
                availableTickets + 1, // To include 0 in the options
                (index) => DropdownMenuItem(
                  value: index,
                  child: Text(index.toString(),
                      style: const TextStyle(color: Colors.white)),
                ),
              ),
              onChanged: onChanged,
            ),
            Text("Total: \$${(price * selectedCount).toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      ],
    );
  }
}
