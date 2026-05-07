//import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:gifts_store/screens/auth_screen.dart';
//import 'package:gifts_store/screens/home_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // حركة الشفافية (Fade)
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 3),
//     );

//     _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);

//     _controller.forward();

//     // الانتقال بعد 3 ثواني
//     Timer(const Duration(seconds: 5), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           // الخلفية
//           Image.asset(
//             "assets/images/background.jpg",
//             fit: BoxFit.cover,
//           ),

//           // طبقة تغميق بسيطة (اختياري)
//           Container(
//             color: Colors.black.withOpacity(0.3),
//           ),

//           // الشعار المتلاشي
//           Center(
//             child: FadeTransition(
//               opacity: _fadeAnimation,
//               child: Image.asset(
//                 "assets/images/logo.png",
//                 width: 180,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();

    // ❌ لا يوجد Navigator هنا نهائياً
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/background.jpg",
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                "assets/images/logo.png",
                width: 180,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
