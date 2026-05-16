import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;

  bool isFavorite = false;

  String favoriteId = '';

  // ================= CHECK FAVORITE =================
  Future<void> checkFavorite() async {
    final user = FirebaseAuth.instance.currentUser;

    final query = await FirebaseFirestore.instance
        .collection('favorites')
        .where("name", isEqualTo: widget.product["name"])
        .where("userId", isEqualTo: user!.uid)
        .get();

    if (query.docs.isNotEmpty) {
      setState(() {
        isFavorite = true;
        favoriteId = query.docs.first.id;
      });
    }
  }

  // ================= ADD TO CART =================
  Future<void> addToCart() async {
    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('cart').add({
      "name": widget.product["name"],
      "price": widget.product["price"],
      "image": widget.product["image"],
      "category": widget.product["category"],
      "quantity": quantity,
      "status": "قيد المراجعة",
      "userId": user!.uid,
      "created_at": DateTime.now(),
    });

    print(user.uid);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("تمت الإضافة للسلة"),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkFavorite();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      body: Column(
        children: [
          /// ================= IMAGE =================
          Stack(
            children: [
              Container(
                height: 320,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 226, 214, 226),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: CachedNetworkImage(
                  imageUrl: product["image"] ?? '',
                  fit: BoxFit.contain,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.image_not_supported,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
              ),

              /// ================= BACK =================
              Positioned(
                top: 40,
                left: 8,
                child: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 244, 225, 243),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              /// ================= FAVORITE =================
              Positioned(
                top: 40,
                right: 16,
                child: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 240, 223, 243),
                  child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: const Color.fromARGB(255, 130, 6, 161),
                      ),
                      onPressed: () async {
                        final user = FirebaseAuth.instance.currentUser;

                        if (user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("يجب تسجيل الدخول أولاً")),
                          );
                          return;
                        }

                        if (!isFavorite) {
                          final doc = await FirebaseFirestore.instance
                              .collection('favorites')
                              .add({
                            "name": product["name"],
                            "price": product["price"],
                            "image": product["image"],
                            "category": product["category"],
                            "description": product["description"],
                            "userId": user.uid, // 🔥 الآن مضمون
                            "created_at": DateTime.now(),
                          });

                          setState(() {
                            isFavorite = true;
                            favoriteId = doc.id;
                          });
                        } else {
                          await FirebaseFirestore.instance
                              .collection('favorites')
                              .doc(favoriteId)
                              .delete();

                          setState(() {
                            isFavorite = false;
                            favoriteId = '';
                          });
                        }
                      }),
                ),
              ),
            ],
          ),

          /// ================= DETAILS =================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ================= NAME =================
                  Text(
                    product["name"] ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// ================= CATEGORY =================
                  Text(
                    product["category"] ?? '',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// ================= PRICE =================
                  Text(
                    "${product["price"] ?? 0} ر.ي",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFF7B3FE4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ================= DESCRIPTION =================
                  Text(
                    product["description"] ?? '',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ================= QUANTITY =================
                  Row(
                    children: [
                      const Text(
                        "الكمية",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color.fromARGB(255, 226, 214, 226),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (quantity > 1) {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            Text(quantity.toString()),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  /// ================= ADD TO CART =================
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 178, 172, 197),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: addToCart,
                      child: const Text(
                        "إضافة للسلة",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 2, 2, 2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
