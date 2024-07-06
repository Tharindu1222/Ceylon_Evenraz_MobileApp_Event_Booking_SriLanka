import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:ceylon/constants/colors.dart';

class EditEvent extends StatefulWidget {
  final DocumentSnapshot event;

  const EditEvent({Key? key, required this.event}) : super(key: key);

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _eventNameController;
  late TextEditingController _locationController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _descriptionController;
  late List<TextEditingController> _priceControllers;
  late List<TextEditingController> _availableTicketsControllers;
  File? _image;
  String? _imagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _eventNameController =
        TextEditingController(text: widget.event['eventName']);
    _locationController = TextEditingController(text: widget.event['location']);
    _dateController = TextEditingController(text: widget.event['date']);
    _timeController = TextEditingController(text: widget.event['time']);
    _descriptionController =
        TextEditingController(text: widget.event['description']);
    _priceControllers = List.generate(
      3,
      (index) => TextEditingController(
          text: widget.event['price_${index + 1}'].toString()),
    );
    _availableTicketsControllers = List.generate(
      3,
      (index) => TextEditingController(
          text: widget.event['availableTickets_${index + 1}'].toString()),
    );
    _imagePath = widget.event['imagePath'];
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final storageReference = FirebaseStorage.instance
          .ref()
          .child('event_images/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageReference.putFile(image);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      String? Function(String?)? validator,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      validator: validator,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
    );
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    _priceControllers.forEach((controller) => controller.dispose());
    _availableTicketsControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Event"),
        elevation: 0,
        backgroundColor: bgBlack,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: bgBlack,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(_eventNameController, "Event Name", (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the event name";
                  }
                  return null;
                }),
                _buildTextField(_locationController, "Location", (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the location";
                  }
                  return null;
                }),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: "Date",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  readOnly: true,
                  onTap: _selectDate,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the date";
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.white),
                ),
                TextFormField(
                  controller: _timeController,
                  decoration: const InputDecoration(
                    labelText: "Time",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  readOnly: true,
                  onTap: _selectTime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the time";
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.white),
                ),
                _buildTextField(_descriptionController, "Description", (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the description";
                  }
                  return null;
                }),
                _buildTextField(
                  _priceControllers[0],
                  "Normal Ticket Price",
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the ticket price";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  _availableTicketsControllers[0],
                  "Available Normal Tickets",
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the number of available tickets";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  _priceControllers[1],
                  "VIP Ticket Price",
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the ticket price";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  _availableTicketsControllers[1],
                  "Available VIP Tickets",
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the number of available tickets";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  _priceControllers[2],
                  "VVIP Ticket Price",
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the ticket price";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  _availableTicketsControllers[2],
                  "Available VVIP Tickets",
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the number of available tickets";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                _image == null
                    ? _imagePath == null
                        ? Image.asset(
                            'assets/images/man.png',
                            height: 150,
                          )
                        : Image.network(_imagePath!, height: 150)
                    : Image.file(_image!, height: 150),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Pick Image'),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });

                            String? imageUrl;
                            if (_image != null) {
                              imageUrl = await _uploadImage(_image!);
                            }

                            FirebaseFirestore.instance
                                .collection('events')
                                .doc(widget.event.id)
                                .update({
                              'eventName': _eventNameController.text,
                              'location': _locationController.text,
                              'date': _dateController.text,
                              'time': _timeController.text,
                              'description': _descriptionController.text,
                              'price_1':
                                  double.parse(_priceControllers[0].text),
                              'availableTickets_1': int.parse(
                                  _availableTicketsControllers[0].text),
                              'price_2':
                                  double.parse(_priceControllers[1].text),
                              'availableTickets_2': int.parse(
                                  _availableTicketsControllers[1].text),
                              'price_3':
                                  double.parse(_priceControllers[2].text),
                              'availableTickets_3': int.parse(
                                  _availableTicketsControllers[2].text),
                              'imagePath': imageUrl ?? _imagePath,
                            }).then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Event Updated')),
                              );
                              Navigator.pop(context);
                            }).catchError((error) {
                              print('Error updating event: $error');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Failed to update event')),
                              );
                            }).whenComplete(() {
                              setState(() {
                                _isLoading = false;
                              });
                            });
                          }
                        },
                        child: const Text("Update Event"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
