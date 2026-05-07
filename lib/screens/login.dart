import 'package:flutter/material.dart';
import 'package:gifts_store/services/auth_service.dart';
import 'package:gifts_store/widgets/auth_form.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Stack(
          children: [
            //الشعار
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
              isLogin: true,
              onSubmit: (email, password, _) async {
                return await AuthService().signIn(email, password, context);
              },
            )
          ],
        ));
  }
}
