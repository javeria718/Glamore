import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/Model/userModel';
import 'package:ecom_app/Singleton/singleton.dart';
import 'package:ecom_app/auth/login.dart';
import 'package:ecom_app/widgets/custom_textfornfield.dart';
import 'package:ecom_app/widgets/custombotton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

//FUNCTION
  Future<void> signUp(
      String email, String password, String fullName, String mobile) async {
    try {
      setState(() => isLoading = true);

      // Create user in Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // Create user model with UID
      final userModel = UserModel(
        uid: uid,
        name: fullName,
        email: email,
        phoneNumber: mobile,
      );

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(userModel.toJson());

      // Store in Singleton
      UserSingleton().userModel = userModel;

      // Optionally update display name in FirebaseAuth profile
      await userCredential.user?.updateDisplayName(fullName);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signup Successful! Redirecting to Login...'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    } catch (e) {
      if (!mounted) return;
      showError("Signup failed: ${e.toString()}");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void validateAndSignUp() {
    String fullName = fullNameController.text.trim();
    String email = emailController.text.trim();
    String mobile = mobileController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (fullName.isEmpty ||
        email.isEmpty ||
        mobile.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showError("Please fill all fields.");
    } else if (!email.contains("@")) {
      showError("Enter a valid email.");
    } else if (mobile.length < 11) {
      showError("Enter a valid mobile number.");
    } else if (password.length < 8) {
      showError("Password must be at least 6 characters.");
    } else if (password != confirmPassword) {
      showError("Passwords do not match.");
    } else {
      signUp(email, password, fullName, mobile);
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
                const SizedBox(height: 80),
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),

                // Full Name
                CustomTextFormField(
                  controller: fullNameController,
                  label: 'Full Name',
                  icon: Icons.person,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20),

                // Email
                CustomTextFormField(
                  controller: emailController,
                  label: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // Mobile Number
                CustomTextFormField(
                  controller: mobileController,
                  label: 'Mobile Number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
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
                const SizedBox(height: 20),

                // Confirm Password
                CustomTextFormField(
                  controller: confirmPasswordController,
                  label: 'Confirm Password',
                  icon: Icons.lock,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                const SizedBox(height: 30),

                // Sign Up Button
                CustomButton(
                  label: isLoading ? 'Signing Up...' : 'Sign Up',
                  onPressed: validateAndSignUp,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 12, color: Colors.teal),
                      ),
                    )
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
