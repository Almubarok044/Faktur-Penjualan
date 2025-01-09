// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/sign_up.dart';
import '../controllers/firebase_auth.dart';
import 'log_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService auth = FirebaseAuthService();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom * 0.5),
                    child: Form(
                      key: formState,
                      child: Column(
                        children: [
                          const SizedBox(height: 23),
                          Column(
                            children: [
                              Text(
                                'Sign Up',
                                style: GoogleFonts.merriweather(
                                    color: const Color(0xff2C306F),
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: usernameController,
                                validator: (username) {
                                  if (username == '') {
                                    return 'Username tidak boleh kosong';
                                  } else if (username!.length > 30) {
                                    return 'Username maksimal 30 karakter';
                                  }
                                  return null;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                    labelText: 'Username',
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    prefixIcon: Icon(Icons.perm_identity),
                                    border: OutlineInputBorder()),
                                onChanged: (String username) {
                                  getUsername(username);
                                  setState(() {
                                    isDataEntered = username.isNotEmpty;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: emailController,
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
                                onChanged: (String email) {
                                  getEmailSignUp(email);
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
                                  getPasswordSignUp(password);
                                  setState(() {
                                    isDataEntered = password.isNotEmpty;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (formState.currentState!.validate()) {
                                    signUp();
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
                                      Icon(Icons.person_add_alt_1,
                                          color: Colors.white),
                                      SizedBox(width: 3),
                                      Text(
                                        'SIGN UP',
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
                                  const Text('Already have an account?'),
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
                                            (route) => false);
                                      },
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 112, 193, 186),
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              )
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
    );
  }

  Future signUp() async {
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    User? user = await auth.signUpWithEmailAndPassword(email, password);

    // Success
    if (user != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LogInPage()),
          (route) => true);
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                content: Text('Register is successfully created'),
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                content: Text('Unable to establish connection on channel.'),
              ));
    }
  }
}
