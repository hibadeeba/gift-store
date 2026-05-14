import 'package:flutter/material.dart';
import 'package:gifts_store/screens/product_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = "الكل";
  final TextEditingController searchController = TextEditingController();
  String searchText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ///  AppBar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "Hafora Gifts",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  /// 🔍 Search
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(250, 235, 250, 1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchText = value.toLowerCase();
                        });
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "بحث...",
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// 🎁 Banner
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: BannerWidget(),
            ),

            const SizedBox(height: 30),

            ///  الأقسام (ثابتة)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CategoriesSection(
                selected: selectedCategory,
                onSelect: (cat) {
                  setState(() {
                    selectedCategory = cat;
                  });
                },
              ),
            ),

            const SizedBox(height: 10),

            /// 🛍 المنتجات (هي فقط اللي تسكرول)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ProductsSection(
                  category: selectedCategory,
                  searchText: searchText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= BANNER =================
class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 81, 15, 101), Color(0xFF9C6BFF)],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            left: 16,
            top: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "مكانك لتختار ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  " افضل الهدايا  ",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            //https://i.imgur.com/l817Fvr.jpeg

            child: Image.asset("assets/images/gift.png", height: 140),
          ),
        ],
      ),
    );
  }
}

/// ================= CATEGORIES =================
class CategoriesSection extends StatelessWidget {
  final String selected;
  final Function(String) onSelect;

  const CategoriesSection({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final Map<String, String> categoryImages = const {
    "الكل": "assets/images/gift.png",
    "عناية": "assets/images/skin.png",
    " باقةورد": "assets/images/fl.png",
    "سناك": "assets/images/snak.png",
  };

  @override
  Widget build(BuildContext context) {
    final categories = ["الكل", "عناية", "باقة ورد", "سناك"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((cat) {
        final isSelected = selected == cat;

        return GestureDetector(
          onTap: () => onSelect(cat),
          child: Column(
            children: [
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF7B3FE4).withOpacity(0.2)
                      : const Color.fromARGB(255, 244, 234, 245),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    categoryImages[cat] ?? "assets/images/gift.png",
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                cat,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? const Color(0xFF7B3FE4) : Colors.black,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class ProductsSection extends StatelessWidget {
  final String category;
  final String searchText;

  const ProductsSection({
    super.key,
    required this.category,
    required this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = snapshot.data!.docs;

        // 🔥 نفس فلترة التصنيفات بدون تغيير
        final filteredByCategory = category == "الكل"
            ? products
            : products.where((doc) => doc['category'] == category).toList();

        // 🔥 إضافة البحث فقط فوق الموجود
        final filtered = searchText.isEmpty
            ? filteredByCategory
            : filteredByCategory.where((doc) {
                final name = doc['name'].toString().toLowerCase();
                return name.contains(searchText);
              }).toList();

        return GridView.builder(
          itemCount: filtered.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (_, i) {
            final product = filtered[i];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsScreen(
                      product: product.data(),
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.grey.withOpacity(0.1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        product['image'] ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                    Text(product['name']),
                    Text(
                      "${product['price']}ر.ي",
                      style: const TextStyle(color: Color(0xFF7B3FE4)),
                    ),
                    Text(
                      product['category'],
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
