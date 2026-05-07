import 'package:cloud_firestore/cloud_firestore.dart';

class DbFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection("users").doc(uid).get();

      if (doc.exists) {
        return doc.data();
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting user data: $e");
      return null;
    }
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.rating,
  });
}
