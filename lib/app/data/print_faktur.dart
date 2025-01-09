import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final formState = GlobalKey<FormState>();
final FirebaseFirestore firestore = FirebaseFirestore.instance;
dynamic dateSelected = DateTime.now();

bool isDataEntered = false;
bool isDataEntered2 = false;

// Fungsi untuk menghasilkan kode pelanggan acak
String generateFakturId(int length) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();
  return List.generate(length, (index) => chars[random.nextInt(chars.length)])
      .join();
}

var fakturId;
var idFaktur;
String? typeOfPayment;

void checkPDFToast() => Fluttertoast.showToast(
    msg: 'Tidak dapat membuka PDF, ID $fakturId tidak ditemukan.',
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    fontSize: 16.0);

void pdfToast() => Fluttertoast.showToast(
    msg: 'Berhasil membuka PDF dengan ID $fakturId.',
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 2,
    backgroundColor: Colors.indigo,
    textColor: Colors.white,
    fontSize: 16.0);
