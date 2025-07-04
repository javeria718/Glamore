import 'package:ecom_app/view/welcome/welcome.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    splashMethod();
  }

  splashMethod() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return; // <--- ADD THIS
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Glamoré',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.teal,
              ),
            ),
          ),
          SizedBox(height: 20),
          CircularProgressIndicator(
            color: Colors.teal,
          ),
        ],
      ),
    );
  }
}
