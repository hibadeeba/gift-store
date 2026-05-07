import 'package:flutter/material.dart';
import 'package:gifts_store/screens/login.dart';
import 'package:gifts_store/screens/logup.dart';
import 'package:gifts_store/widgets/auth_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    //final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          // الشعار في الأعلى
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                "assets/images/logo.png",
                width: 150,
              ),
            ),
          ),

          // الأزرار في الوسط/الأسفل
          Align(
            alignment: Alignment.center,
            child: AuthButtons(
              onLogin: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Login()));
              },
              onRegister: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Logup()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
