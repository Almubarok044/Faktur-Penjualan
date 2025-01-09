// ignore_for_file: unused_field, deprecated_member_use, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/log_in.dart';
import '../controllers/firebase_auth.dart';
import 'menu_home_page.dart';
import 'reset_password.dart';
import 'sign_up_page.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  DateTime timeBackPressed = DateTime.now();
  final formState = GlobalKey<FormState>();
  bool isDataEntered = false;
  bool isDataEntered2 = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= const Duration(seconds: 2);

        timeBackPressed = DateTime.now();

        if (isExitWarning) {
          const message = 'Press back again to exit';
          Fluttertoast.showToast(msg: message, fontSize: 18);

          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
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
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom:
                              MediaQuery.of(context).viewInsets.bottom * 0.5),
                      child: Form(
                        key: formState,
                        child: Column(
                          children: [
                            const SizedBox(height: 25),
                            Column(
                              children: [
                                Text(
                                  'Login',
                                  style: GoogleFonts.merriweather(
                                      color: const Color(0xff2C306F),
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: emailController,
                                  validator: validateEmail,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: const InputDecoration(
                                      labelText: 'Email',
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      prefixIcon: Icon(
                                        Icons.email,
                                      ),
                                      border: OutlineInputBorder()),
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (String email) {
                                    getEmail(email);
                                    setState(() {
                                      isDataEntered = email.isNotEmpty;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: passwordController,
                                  validator: (password) {
                                    if (password == '') {
                                      return 'Password tidak boleh kosong';
                                    } else if (password!.length < 6 ||
                                        password.length > 20) {
                                      return 'Password harus terdiri dari 6 hingga 20 karakter';
                                    }
                                    return null;
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                      labelText: 'Password',
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      prefixIcon: const Icon(Icons.password),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          isPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          // Toggle keadaan password terlihat atau tidak terlihat
                                          setState(() {
                                            isPasswordVisible =
                                                !isPasswordVisible;
                                          });
                                        },
                                      ),
                                      border: const OutlineInputBorder()),
                                  obscureText: !isPasswordVisible,
                                  onChanged: (String password) {
                                    getPassword(password);
                                    setState(() {
                                      isDataEntered = password.isNotEmpty;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          // Success
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ResetPasswordPage()),
                                              (route) => false);
                                        },
                                        child: const Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor: Color.fromARGB(
                                                  255, 112, 193, 186),
                                              color: Color.fromARGB(
                                                  255, 112, 193, 186),
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (formState.currentState!.validate()) {
                                      signIn();
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.lock_open,
                                              color: Colors.white),
                                          SizedBox(width: 3),
                                          Text(
                                            'LOGIN',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Don't have an account?"),
                                    const SizedBox(width: 5),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUpPage(),
                                          ),
                                          (route) => false,
                                        );
                                      },
                                      child: const Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 112, 193, 186),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
      ),
    );
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      // Success
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MenuHome()),
          (route) => true);
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                content: Text('Login success'),
              ));
    } catch (e) {
      if (kDebugMode) {
        print(e);
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  content: Text(
                      'An internal error has occured. [ INVALID_LOGIN_CREDENTIALS ]'),
                ));
      }
    }
  }
}
