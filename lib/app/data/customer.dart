import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final formState = GlobalKey<FormState>();
final FirebaseFirestore firestore = FirebaseFirestore.instance;

bool isDataEntered = false;
bool isDataEntered2 = false;

// String generateCustomerId() {
//   const length = 8;
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
String generateCustomerCode(int length) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();
  return List.generate(length, (index) => chars[random.nextInt(chars.length)])
      .join();
}

// Fungsi validasi email
String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return 'Email tidak boleh kosong';
  }
  RegExp emailRegExp = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
  final isEmailValid = emailRegExp.hasMatch(email);
  if (!isEmailValid) {
    return 'Tolong masukkan email yang benar';
  }
  return null;
}

// Variabel untuk data pelanggan
var customerId;
String? customerName;
dynamic customerAddress;
String? customerCity;
dynamic customerEmail;
int? customerNumberHp;

void getId(id) {
  customerId = id;
}

void getCustomerName(name) {
  customerName = name;
}

void getAddress(address) {
  customerAddress = address;
}

void getCity(city) {
  customerCity = city;
}

void getEmail(email) {
  customerEmail = email;
}

void getNoHp(number) {
  customerNumberHp = int.tryParse(number);
}
