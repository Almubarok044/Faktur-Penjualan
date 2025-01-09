// ignore_for_file: use_build_context_synchronously, unused_field

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';

class QRImage extends StatefulWidget {
  const QRImage({Key? key}) : super(key: key);

  @override
  State<QRImage> createState() => _QRImageState();
}

class _QRImageState extends State<QRImage> with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool isScanCodeActive = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (tabController.index == 1) {
        setState(() {
          isScanCodeActive = true;
        });
        scanQR(context);
      } else {
        setState(() {
          isScanCodeActive = false;
        });
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> scanQR(BuildContext context) async {
    try {
      String qrResult = (await BarcodeScanner.scan()) as String;
      // Handle QR scan result
      if (kDebugMode) {
        print('Scanned QR code result: $qrResult');
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('QR Code Result'),
            content: Text(qrResult),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        // Handle camera permission denied
        if (kDebugMode) {
          print('Camera permission denied');
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Camera permission denied'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Handle other exceptions
        if (kDebugMode) {
          print('Error: $e');
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Error: $e'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle other exceptions
      if (kDebugMode) {
        print('Error: $e');
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Error: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Short link QR'),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromARGB(255, 112, 193, 186),
                Color(0xff2C306F)
              ], begin: Alignment.bottomRight, end: Alignment.topLeft)),
            ),
            bottom: TabBar(
                controller: tabController,
                indicatorColor: Colors.white,
                indicatorWeight: 2,
                tabs: const [
                  Tab(icon: Icon(Icons.qr_code_2), text: 'My code'),
                  Tab(icon: Icon(Icons.barcode_reader), text: 'Scan code'),
                ]),
          ),
          body: TabBarView(children: [myCode('My code'), scanCode(context)])),
    );
  }

  Widget scanCode(BuildContext context) => Center(
        child: ElevatedButton(
          onPressed: () => scanQR(context),
          child: const Text('Scan QR Code'),
        ),
      );

  Widget myCode(String text) => Center(
        child: QrImageView(
          data:
              'https://drive.google.com/file/d/1ACtjZJxGVTwJdGkr-2BvSdZZsvbqgaXW/view?usp=sharing',
          size: 280,
          // You can include embeddedImageStyle Property if you
          //wanna embed an image from your Asset folder
          embeddedImageStyle: const QrEmbeddedImageStyle(
            size: Size(
              100,
              100,
            ),
          ),
        ),
      );
}
