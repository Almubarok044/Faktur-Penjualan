import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final formState = GlobalKey<FormState>();
final FirebaseFirestore firestore = FirebaseFirestore.instance;

bool isDataEntered = false;
bool isDataEntered2 = false;

// String generateItemId() {
//   const length = 12;
//   const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
//   Random random = Random();
//   return String.fromCharCodes(
//     Iterable.generate(
//       length,
//       (_) => chars.codeUnitAt(random.nextInt(chars.length)),
//     ),
//   );
// }

// Fungsi untuk menghasilkan kode pelanggan acak
String generateItemId(int length) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();
  return List.generate(length, (index) => chars[random.nextInt(chars.length)])
      .join();
}

var itemId;
String? itemName;
String? itemDescription;
var itemWeight;
var itemTotal;
var itemPrice;
