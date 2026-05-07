import 'package:flutter/material.dart';
import 'package:gifts_store/services/auth_service.dart';
import 'package:gifts_store/widgets/auth_form.dart';

class Logup extends StatefulWidget {
  const Logup({super.key});

  @override
  State<Logup> createState() => _LogupState();
}

class _LogupState extends State<Logup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Stack(
          children: [
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
            AuthForm(
              isLogin: false,
              onSubmit: (email, password, username) async {
                return await AuthService()
                    .signUp(email, password, username ?? "", context);
              },
            )
          ],
        ));
  }
}
