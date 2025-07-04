import 'package:ecom_app/widgets/custom_textfornfield.dart';
import 'package:ecom_app/widgets/custombotton.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Forgotpass extends StatefulWidget {
  const Forgotpass({super.key});

  @override
  State<Forgotpass> createState() => _ForgotpassState();
}

class _ForgotpassState extends State<Forgotpass> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  void showMessage(String message, {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> validateAndSendReset() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showMessage('Please enter your email.');
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      showMessage('Please enter a valid email address.');
      return;
    }

    try {
      setState(() => isLoading = true);

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (!mounted) return;

      showMessage('Password reset email sent!', color: Colors.green);

      // Optional: Wait a moment and go back to login
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String error = 'Something went wrong.';
      if (e.code == 'user-not-found') {
        error = 'No user found with that email.';
      } else if (e.code == 'invalid-email') {
        error = 'The email format is invalid.';
      }
      showMessage(error);
    } catch (e) {
      showMessage('An unexpected error occurred.');
    } finally {
      if (mounted) setState(() => isLoading = false);
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
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 90),

                // Email input
                CustomTextFormField(
                  label: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                ),
                const SizedBox(height: 40),

                // Send button
                CustomButton(
                  label: isLoading ? 'Sending...' : 'Send',
                  onPressed: isLoading ? null : validateAndSendReset,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
