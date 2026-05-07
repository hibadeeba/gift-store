import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(email);
  }

  // =================  انشاء حساب بالايميل و كلمة المرور  =================
  Future<User?> signUp(
    String email,
    String password,
    String username,
    BuildContext context,
  ) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("الإيميل او كلمة المرور خالية")),
        );
        return null;
      }

      if (!isValidEmail(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("إيميل غير صحيح")),
        );
        return null;
      }

      if (password.length < 8) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("كلمة المرور أقل من 8")),
        );
        return null;
      }

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user == null) {
        return null;
      }

      // 🔥 Firestore بشكل آمن
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "username": username,
        "email": email,
      });

      return user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Auth Error")),
      );
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
      return null;
    }
  }

  // ================= تسجيل الدخول =================
  Future<User?> signIn(
      String email, String password, BuildContext context) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("الإيميل او كلمة المرور خالية")));
        return null;
      }
      if (!isValidEmail(email)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("اإيميل غير متوفر")));
        return null;
      }

      if (password.length < 8) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("كلمة المرور يجب ان تكون على الاقل ثمانية ارقام")));
        return null;
      }
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(" لا يوجد حساب بهذا الايميل")));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(" كلمة المرور خطأ")));
        print("Wrong password");
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
      }
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error:$e")));
      return null;
    }
  }

  //======تسجيل الدخول بقوقل=====
  Future<User?> signinWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return null; // المستخدم لغى الدخول
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print("Google Sign-In Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("فشل تسجيل الدخول بجوجل"),
        ),
      );

      return null;
    }
  }

  //=========تسجيل الخروج========
  Future<void> logout() async {
    await auth.signOut();
  }

  Future<void> deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    // 1. حذف من Firestore
    await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();

    // 2. حذف من Authentication
    await user.delete();
  }
}
