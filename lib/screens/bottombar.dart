// import 'package:flutter/material.dart';
// import 'package:gifts_store/screens/favorite_screen.dart';
// import 'package:gifts_store/screens/shopping_screen.dart';
// import 'package:gifts_store/screens/profile_screen.dart';
// import 'package:gifts_store/screens/home_screen.dart';

// // ================= BOTTOM NAV =================
// class CustomBottomNav extends StatefulWidget {
//   const CustomBottomNav({super.key});

//   @override
//   State<CustomBottomNav> createState() => _CustomBottomNavState();
// }

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
//     return BottomNavigationBar(
//       currentIndex: index,
//       selectedItemColor: const Color.fromARGB(255, 76, 6, 95),
//       unselectedItemColor: Colors.grey,
//       onTap: (i) => setState(() => index = i),
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.shopping_cart),
//           label: "السلة",
//         ),
//         BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "المفضلات"),
//         BottomNavigationBarItem(icon: Icon(Icons.person), label: "حسابي"),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';

import 'package:gifts_store/screens/home_screen.dart';
import 'package:gifts_store/screens/shopping_screen.dart';
import 'package:gifts_store/screens/favorite_screen.dart';
import 'package:gifts_store/screens/profile_screen.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int index = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    const ShoppingScreen(),
    const FavoriteScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: const Color.fromARGB(255, 76, 6, 95),
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          setState(() {
            index = i;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "الرئيسية",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "السلة",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "المفضلات",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "حسابي",
          ),
        ],
      ),
    );
  }
}
