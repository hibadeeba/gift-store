import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            " حالة الطلب",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Colors.black.withOpacity(0.3), // تغميق للصورة
          ),
        ),
      ),
      // body: StreamBuilder(
      //   stream: FirebaseFirestore.instance.collection('orders').snapshots(),
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) {
      //       return const Center(child: CircularProgressIndicator());
      //     }

      //     final orders = snapshot.data!.docs;

      //     return ListView.builder(
      //       itemCount: orders.length,
      //       itemBuilder: (context, index) {
      //         final order = orders[index];

      //         String status = order['status'];

      //         Color color;
      //         if (status == "accepted") {
      //           color = Colors.green;
      //         } else if (status == "rejected") {
      //           color = Colors.red;
      //         } else {
      //           color = Colors.orange;
      //         }

      //         return Card(
      //           margin: const EdgeInsets.all(10),
      //           child: ListTile(
      //             title: Text("طلب رقم ${order.id}"),
      //             subtitle: Text(
      //               status == "pending"
      //                   ? "قيد المراجعة"
      //                   : status == "accepted"
      //                       ? "تم القبول"
      //                       : "تم الرفض",
      //               style: TextStyle(color: color),
      //             ),
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where(
              'userId',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              String status = order['status'];

              Color color;
              if (status == "accepted") {
                color = Colors.green;
              } else if (status == "rejected") {
                color = Colors.red;
              } else {
                color = Colors.orange;
              }

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text("طلب رقم ${order.id}"),
                  subtitle: Text(
                    status == "pending"
                        ? "قيد المراجعة"
                        : status == "accepted"
                            ? "تم القبول"
                            : "تم الرفض",
                    style: TextStyle(color: color),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
