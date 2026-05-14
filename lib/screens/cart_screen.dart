import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gifts_store/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String userName = "";
  String userAddress = "";
  String userPhone = ""; // ================= TOTAL PRICE =================
  double calculateTotal(List<QueryDocumentSnapshot> items) {
    double total = 0;

    for (var item in items) {
      total += (item['price'] ?? 0) * (item['quantity'] ?? 1);
    }

    return total;
  }

  // ================= BUY ORDER =================
  Future<void> checkout(List<QueryDocumentSnapshot> items) async {
    if (items.isEmpty) return;

    await FirebaseFirestore.instance.collection('orders').add({
      "items": items.map((e) => e.data()).toList(),
      "total": calculateTotal(items),
      "status": "pending",

      // 👇 المتغيرات
      "customerName": userName,
      "customerAddress": userAddress,

      "created_at": DateTime.now(),
    });

    for (var item in items) {
      await FirebaseFirestore.instance.collection('cart').doc(item.id).delete();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("تم إرسال الطلب")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            "سلة المشتريات",
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .where(
              'userId',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid,
            )
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!.docs;

          if (items.isEmpty) {
            return const Center(
              child: Text("السلة فارغة"),
            );
          }

          return Column(
            children: [
              // ================= LIST =================
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    int qty = item['quantity'] ?? 1;

                    return Card(
                      margin: const EdgeInsets.all(3),
                      child: ListTile(
                        leading: Image.network(
                          item['image'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),

                        title: Text(item['name']),
                        subtitle: Text(
                          "${item['price']} ريال",
                        ),

                        // ================= QUANTITY CONTROLS =================
                        trailing: FittedBox(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  if (qty > 1) {
                                    await FirebaseFirestore.instance
                                        .collection('cart')
                                        .doc(item.id)
                                        .update({
                                      "quantity": qty - 1,
                                    });
                                  }
                                },
                                icon: const Icon(Icons.remove),
                              ),
                              Text(qty.toString()),
                              IconButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('cart')
                                      .doc(item.id)
                                      .update({
                                    "quantity": qty + 1,
                                  });
                                },
                                icon: const Icon(Icons.add),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('cart')
                                      .doc(item.id)
                                      .delete();
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ================= TOTAL + BUY BUTTON =================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black12,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${calculateTotal(items)} ريال",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 168, 46, 255),
                          ),
                        ),
                        const Text(
                          ":الإجمالي",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "رقم العميل",
                      ),
                      onChanged: (value) {
                        userPhone = value;
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "اسم العميل",
                      ),
                      onChanged: (value) {
                        userName = value;
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "العنوان",
                      ),
                      onChanged: (value) {
                        userAddress = value;
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 178, 172, 197),
                        ),
                        onPressed: () => checkout(items),
                        child: const Text(
                          "شراء الآن",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
