import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveBooking({
    required String eventName,
    required int normalTickets,
    required int vipTickets,
    required int vvipTickets,
    required int totalPrice,
    required String user,
    required String userIdentityCard,
    required String userAddress,
    required String userCity,
    required String userPostalCode,
  }) async {
    try {
      await _db.collection('bookings').add({
        'eventName': eventName,
        'normalTickets': normalTickets,
        'vipTickets': vipTickets,
        'vvipTickets': vvipTickets,
        'totalPrice': totalPrice,
        'user': user,
        'userIdentityCard': userIdentityCard,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving booking: $e');
    }
  }
}
