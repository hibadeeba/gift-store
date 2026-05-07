// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:gifts_store/screens/auth_screen.dart';
// import 'package:gifts_store/screens/profile_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: const Color.fromARGB(255, 213, 160, 160),
//         body: Column(
//           children: [
//             Text("hi ggggggggg"),
//             IconButton(
//               onPressed: () async {
//                 await FirebaseAuth.instance.signOut();

//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (_) => const AuthScreen()),
//                   (route) => false,
//                 );
//               },
//               icon: Icon(Icons.logout),
//             ),
//             const ProfileScreen(),
//           ],
//         ));
//   }
// }
import 'package:flutter/material.dart';
import 'package:gifts_store/screens/product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = "الكل";

  /// 📦 بيانات تجريبية
  final List<Map<String, dynamic>> allProducts = [
    {
      "name": "Mystery Box",
      "price": "129",
      "image": "assets/images/gift.png",
      "category": "Mystery",
    },
    {
      "name": "Flower Box",
      "price": "150",
      "image": "assets/images/gift.png",
      "category": "Flowers",
    },
    {
      "name": "Perfume",
      "price": "200",
      "image": "assets/images/gift.png",
      "category": "Perfumes",
    },
    {
      "name": "Sweets Box",
      "price": "99",
      "image": "assets/images/gift.png",
      "category": "Sweets",
    },
  ];

  List<Map<String, dynamic>> get filteredProducts {
    if (selectedCategory == "الكل") return allProducts;
    return allProducts.where((p) => p["category"] == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// 🔥 AppBar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "Mystery Gifts",
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
                    child: const TextField(
                      decoration: InputDecoration(
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

            /// ⭐ الأقسام (ثابتة)
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
                child: ProductsSection(products: filteredProducts),
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
                  "صندوق المفأجات",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "احصل على هدية مفأجاة",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
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
    "عناية": "assets/images/son.png",
    "ورد": "assets/images/fl.png",
    "سناكات": "assets/images/sna.png",
  };

  @override
  Widget build(BuildContext context) {
    final categories = ["الكل", "عناية", "ورد", "سناكات"];

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

/// ================= PRODUCTS =================
class ProductsSection extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const ProductsSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, i) {
        final product = products[i];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailsScreen(product: product),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(blurRadius: 10, color: Colors.grey.withOpacity(0.1)),
              ],
            ),
            child: Column(
              children: [
                Expanded(child: Image.asset(product["image"])),
                Text(product["name"]),
                Text(
                  "${product["price"]} ر.س",
                  style: const TextStyle(color: Color(0xFF7B3FE4)),
                ),
                Text(
                  product["category"],
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// class _CustomBottomNavState extends State<CustomBottomNav> {
//   int index = 0;

//   final List<Widget> pages = [
//     const HomeScreen(),
//     const ShoppingScreen(),
//     const FavoriteScreen(),
//     const ProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: pages[index],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: index,
//         selectedItemColor: const Color.fromARGB(255, 76, 6, 95),
//         unselectedItemColor: Colors.grey,
//         onTap: (i) {
//           setState(() {
//             index = i;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: "الرئيسية",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: "السلة",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             label: "المفضلات",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: "حسابي",
//           ),
//         ],
//       ),
//     );
//   }
// }
