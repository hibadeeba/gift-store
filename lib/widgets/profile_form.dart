import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gifts_store/services/db_service.dart';
import 'package:gifts_store/screens/auth_screen.dart';
import 'package:gifts_store/screens/favorite_screen.dart';
import 'package:gifts_store/screens/shopping_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ProfileAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // طلباتي
            profileItem(
              icon: Icons.shopping_bag_outlined,
              title: "طلباتي",
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ShoppingScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // المفضلة
            profileItem(
              icon: Icons.favorite_border,
              title: "المفضلة",
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoriteScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // الإعدادات
            profileItem(
              icon: Icons.settings_outlined,
              title: "الإعدادات",
              onTap: () {},
            ),

            const SizedBox(height: 20),

            // تسجيل الخروج
            profileItem(
              icon: Icons.logout,
              title: "تسجيل الخروج",
              color: const Color.fromARGB(255, 32, 27, 27),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget profileItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: const Color(0xffF5F5F5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final db = DbFirestore();

    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      toolbarHeight: 170,
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      automaticallyImplyLeading: true,
      title: Column(
        children: [
          // صورة المستخدم
          const CircleAvatar(
            radius: 38,
            backgroundColor: Color.fromARGB(
              255,
              223,
              196,
              240,
            ),
            child: Icon(
              Icons.person,
              size: 45,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          // اسم المستخدم
          FutureBuilder<Map<String, dynamic>?>(
            future: db.getUserData(user!.uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text(
                  "...",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                );
              }

              final data = snapshot.data!;

              return Text(
                data["username"] ?? "اسم المستخدم",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              );
            },
          ),

          const SizedBox(height: 5),

          // الايميل
          Text(
            user.email ?? "",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(170);
}
