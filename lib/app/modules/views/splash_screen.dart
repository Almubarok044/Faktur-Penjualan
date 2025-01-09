import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => widget.child!),
          (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                Image.asset('assets/flutter/icon_flutter/icon_flutter.png',
                    height: 180, width: 150),
                const SizedBox(height: 15),
              ],
            ),
            Container(height: 140),
            Column(
              children: [
                Image.asset(
                    'assets/flutter/lockup_built-w-flutter/lockup_built-w-flutter.png',
                    height: 200,
                    width: 150),
              ],
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
