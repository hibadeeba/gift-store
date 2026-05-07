import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      body: Column(
        children: [
          /// 🔥 الصورة + AppBar
          Stack(
            children: [
              Container(
                height: 320,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 226, 214, 226),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Image.asset(product["image"], fit: BoxFit.contain),
              ),

              /// زر الرجوع
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

              /// زر المفضلة
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
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),

          /// 🔽 التفاصيل
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// الاسم
                  Text(
                    product["name"],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// القسم
                  Text(
                    product["category"],
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 10),

                  /// السعر
                  Text(
                    "${product["price"]} ر.س",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFF7B3FE4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 29),

                  /// وصف
                  const Text(
                    "This is a beautiful mystery gift box that contains a surprise item inside. Perfect for gifts and special occasions.",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  /// 🔢 اختيار الكمية
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
                          color: Color.fromARGB(255, 226, 214, 226),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (quantity > 1) {
                                  setState(() => quantity--);
                                }
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            Text(quantity.toString()),
                            IconButton(
                              onPressed: () {
                                setState(() => quantity++);
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  /// 🛒 زر إضافة للسلة
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 64, 8, 89),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        ///  هنا تضيف للسلة مستقبلاً
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("تمت الاضافة للسلة ")),
                        );
                      },
                      child: const Text(
                        "إضافة للسلة",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 248, 223, 249),
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
