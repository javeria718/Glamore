import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/Model/userModel';
import 'package:ecom_app/Singleton/singleton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecom_app/auth/login.dart';
import 'package:ecom_app/widgets/appbar_category.dart';
import 'package:ecom_app/widgets/custombotton.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isEditing = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  void loadProfileData() {
    final userModel = UserSingleton().userModel;
    if (userModel != null) {
      nameController.text = userModel.name;
      phoneController.text = userModel.phoneNumber;
      emailController.text = userModel.email;
    }
  }

  void toggleEditMode() {
    setState(() => isEditing = !isEditing);
  }

  Future<void> updateProfile() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception("No user ID found");
      final updatedUser = UserModel(
        uid: uid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneController.text.trim(),
      );

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(updatedUser.toJson());

      // Update Singleton
      UserSingleton().userModel = updatedUser;

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated!'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() => isEditing = false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> logoutUser() async {
    await FirebaseAuth.instance.signOut();
    UserSingleton().clear();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  Widget buildProfileField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required bool enabled,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(icon, color: Colors.teal),
          labelText: label,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: categoryBar(context, 'Profile'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/panda.jpg'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nameController.text,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            buildProfileField(
              icon: Icons.person,
              label: 'Name',
              controller: nameController,
              enabled: isEditing,
            ),
            buildProfileField(
              icon: Icons.phone,
              label: 'Phone Number',
              controller: phoneController,
              enabled: isEditing,
            ),
            buildProfileField(
              icon: Icons.email,
              label: 'Email',
              controller: emailController,
              enabled: isEditing,
            ),
            const SizedBox(height: 30),
            if (isEditing) ...[
              CustomButton(label: 'Update', onPressed: updateProfile),
              const SizedBox(height: 10),
              CustomButton(label: 'Back', onPressed: toggleEditMode),
            ] else ...[
              CustomButton(label: 'Edit', onPressed: toggleEditMode),
              const SizedBox(height: 10),
              CustomButton(label: 'Logout', onPressed: logoutUser),
            ],
          ],
        ),
      ),
    );
  }
}
