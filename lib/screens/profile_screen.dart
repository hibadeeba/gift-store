import 'package:flutter/material.dart';
import 'package:gifts_store/widgets/profile_form.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Stack(
          children: [
            Positioned(
              top: 90,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 150,
                ),
              ),
            ),
            const ProfileAppBar(),
            const ProfilePage(),
          ],
        ));
  }
}
