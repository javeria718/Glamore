import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/Model/userModel';
import 'package:ecom_app/Singleton/singleton.dart';
import 'package:ecom_app/auth/forgotpass.dart';
import 'package:ecom_app/auth/signup.dart';
import 'package:ecom_app/view/home.dart';
import 'package:ecom_app/widgets/custom_textfornfield.dart';
import 'package:ecom_app/widgets/custombotton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> login(String email, String password) async {
    try {
      setState(() => isLoading = true);

      // Sign in with Firebase Auth
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = credential.user?.uid;
      if (uid == null) throw Exception("User ID is null");

      // Fetch user model from Firestore
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (!doc.exists) throw Exception("User data not found in Firestore");

      final userModel = UserModel.fromJson(doc.data()!);

      // Store user model in singleton
      UserSingleton().userModel = userModel;

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      if (!mounted) return;
      showError("Login failed: ${e.toString()}");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void validateAndLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showError("Please fill all fields.");
    } else if (!email.contains("@")) {
      showError("Enter a valid email.");
    } else if (password.length < 8) {
      showError("Password must be at least 8 characters.");
    } else {
      login(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                const SizedBox(height: 140),
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),

                // Email
                CustomTextFormField(
                  controller: emailController,
                  label: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // Password
                CustomTextFormField(
                  controller: passwordController,
                  label: 'Password',
                  icon: Icons.lock,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                const SizedBox(height: 1),

                // Forgot password
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Forgotpass()),
                    );
                  },
                  child: const Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.teal,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                // Login Button
                CustomButton(
                  label: isLoading ? 'Logging In...' : 'Login',
                  onPressed: validateAndLogin,
                ),

                // Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'New User?',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
