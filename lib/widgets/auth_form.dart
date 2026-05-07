import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gifts_store/screens/bottombar.dart';

// قالب شكل الفورم حق تسجيل الدخول او انشاء حساب
class AuthForm extends StatefulWidget {
  final bool isLogin;
  final Function(String email, String password, String? username) onSubmit;

  const AuthForm({
    super.key,
    required this.isLogin,
    required this.onSubmit,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Center(
      child: Stack(
        children: [
          // ===== العنوان =====
          Positioned(
            top: height * 0.32,
            left: width * 0.20,
            child: Text(
              widget.isLogin ? "تسجيل الدخول" : "إنشاء حساب جديد",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(221, 61, 33, 71),
              ),
            ),
          ),

          // ===== الفورم =====
          Positioned(
            top: height * 0.4,
            left: width * 0.045,
            child: Container(
              width: width * 0.90,
              height: height * 0.5,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border:
                    Border.all(color: const Color.fromARGB(255, 237, 206, 243)),
              ),
              child: Column(
                children: [
                  // 👇 username فقط في التسجيل
                  if (!widget.isLogin) ...[
                    TextField(
                      controller: usernameController,
                      decoration:
                          _inputDecoration("اسم المستخدم", Icons.person),
                    ),
                    const SizedBox(height: 20),
                  ],

                  TextField(
                    controller: emailController,
                    decoration:
                        _inputDecoration("البريد الإلكتروني", Icons.email),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: _inputDecoration("كلمة المرور", Icons.password),
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: () async {
                      setState(() => isLoading = true);

                      User? result = await widget.onSubmit(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                        widget.isLogin ? null : usernameController.text.trim(),
                      );

                      setState(() => isLoading = false);

                      if (!mounted) return;

                      if (result != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CustomBottomNav()),
                        );
                      }
                    },
//                     onPressed: () async {
//   if (isLoading) return;

//   setState(() => isLoading = true);

//   await widget.onSubmit(
//     emailController.text.trim(),
//     passwordController.text.trim(),
//     widget.isLogin ? null : usernameController.text.trim(),
//   );

//   await Future.delayed(const Duration(milliseconds: 300));

//   if (!mounted) return;

//   setState(() => isLoading = false);

//   final user = FirebaseAuth.instance.currentUser;

//   if (user != null) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => const HomeScreen()),
//     );
//   }
// },
                    child: Text(widget.isLogin ? "دخول" : "حفظ ومتابعة"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🎨 نفصل الديكوريشن هنا (مهم جدًا)
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      floatingLabelStyle: const TextStyle(
        color: Color.fromRGBO(98, 38, 105, 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color.fromRGBO(180, 122, 202, 1),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

//  ازرار صفحة عند الدخول اول مرة للتطبيق
// هنا
class AuthButtons extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  const AuthButtons({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: height * 0.4),
        SizedBox(
          width: 271,
          height: 70,
          child: ElevatedButton(
            onPressed: onLogin,
            child: const Text("لديك حساب"),
          ),
        ),
        const SizedBox(height: 13),
        const Text("او"),
        const SizedBox(height: 10),
        SizedBox(
          width: 271,
          height: 70,
          child: ElevatedButton(
            onPressed: onRegister,
            child: const Text("انشاء حساب جديد"),
          ),
        ),
      ],
    );
  }
}
