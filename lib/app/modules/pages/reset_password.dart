// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/reset_pw.dart';
import 'log_in_page.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final resetController = TextEditingController();

  @override
  void dispose() {
    resetController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: resetController.text.trim());
      // ignore: unrelated_type_equality_checks
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                content: Text('Password reset link sent! Check your email'),
              ));
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: Text(e.message.toString()),
                ));
      }
    }
  }

  final formState = GlobalKey<FormState>();
  bool isDataEntered = false;
  bool isDataEntered2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          // Gunakan BoxDecoration untuk menentukan background image
          image: DecorationImage(
            image: AssetImage('assets/background/tema1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom * 0.5),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Form(
                      key: formState,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Reset Password',
                            style: GoogleFonts.merriweather(
                                color: const Color(0xff2C306F),
                                fontSize: 27,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: resetController,
                            validator: validateEmail,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                                labelText: 'Email',
                                filled: true,
                                fillColor: Colors.transparent,
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder()),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (String reset) {
                              getEmailPw(reset);
                              setState(() {
                                isDataEntered = reset.isNotEmpty;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (formState.currentState!.validate()) {
                                passwordReset();
                              } else {}
                            },
                            child: Container(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color(0xff2C306F),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.email, color: Colors.white),
                                  SizedBox(width: 3),
                                  Text(
                                    'RESET PASSWORD',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Back to Login?'),
                              const SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    // Success
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LogInPage()),
                                        (route) => true);
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 112, 193, 186),
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
