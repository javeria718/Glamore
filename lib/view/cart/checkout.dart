import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/Model/orderModel.dart';
import 'package:ecom_app/view/cart/addcart.dart';
import 'package:ecom_app/widgets/cartfields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecom_app/Singleton/cartsingleton.dart';
import 'package:ecom_app/widgets/custombotton.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController appartmentController = TextEditingController();
  String selectedCity = 'Select city';
  String selectedPayment = 'Cash on Delivery';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cart = CartSingleton();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddToCart()));
            },
            icon: const Icon(
              Icons.navigate_before,
              color: Colors.white,
            )),
        backgroundColor: Colors.teal,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Contact",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CartFields(
                label: 'Email or mobile phone number',
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email or phone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text("Delivery",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CartFields(
                label: 'Country/Region',
                keyboardType: TextInputType.text,
                controller: TextEditingController(text: 'Pakistan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Country is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              CartFields(
                label: 'First name',
                keyboardType: TextInputType.name,
                controller: firstNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'First name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CartFields(
                label: 'Last name',
                keyboardType: TextInputType.name,
                controller: lastNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Last name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CartFields(
                label: 'Address',
                keyboardType: TextInputType.streetAddress,
                controller: addressController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CartFields(
                label: 'Apartment, suite, etc. (optional)',
                keyboardType: TextInputType.text,
                controller: appartmentController,
                validator: null,
              ),
              const SizedBox(height: 10),
              CartFields(
                label: 'City',
                keyboardType: TextInputType.text,
                controller: cityController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'City is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CartFields(
                label: 'Phone',
                keyboardType: TextInputType.phone,
                controller: phoneController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text("Shipping method",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Home Delivery", style: TextStyle(fontSize: 12)),
                    Text("\$1.50", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text("Payment",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              RadioListTile(
                title: const Text("Cash on Delivery (COD)",
                    style: TextStyle(fontSize: 12)),
                value: "Cash on Delivery",
                groupValue: selectedPayment,
                onChanged: (val) => setState(() => selectedPayment = val!),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.black),
              const Text("Order Summary",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...cart.cartItems.map((item) => ListTile(
                    title:
                        Text(item.productName, style: TextStyle(fontSize: 12)),
                    subtitle: Text("x${item.numberOfItems}",
                        style: TextStyle(fontSize: 10)),
                    trailing: Text(
                        "\$ ${(item.productPrice * item.numberOfItems).toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 12)),
                  )),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Subtotal:"),
                  Text("\$${cart.totalPrice.toStringAsFixed(2)}"),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Shipping:"),
                  Text("\$1.50"),
                ],
              ),
              const Divider(color: Colors.black),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("\$ ${(cart.totalPrice + 1.50).toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: CustomButton(
                  label: "Place Order",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) return;

                      final items = CartSingleton()
                          .cartItems
                          .map((item) => {
                                'productName': item.productName,
                                'quantity': item.numberOfItems,
                                'price': item.productPrice,
                                'total': item.productPrice * item.numberOfItems,
                              })
                          .toList();

                      final order = OrderModel(
                        userId: user.uid,
                        email: emailController.text,
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        address: addressController.text,
                        phone: phoneController.text,
                        city: selectedCity,
                        country: "Pakistan",
                        paymentMethod: selectedPayment,
                        shippingFee: 1.50,
                        totalAmount: CartSingleton().totalPrice + 1.50,
                        items: items,
                        timestamp: DateTime.now(),
                      );

                      await FirebaseFirestore.instance
                          .collection('orders')
                          .add(order.toJson());
                      await CartSingleton().clearCart();

                      if (!mounted) return;

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.teal[600],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            title: const Text(
                              "Order Placed Successfully!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            content: const Text(
                              "Thanks for shopping at Glamoré.\nYour Order will be delivered soon",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            actionsPadding:
                                const EdgeInsets.only(right: 12, bottom: 8),
                            actions: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.teal[600],
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                        color: Colors.white, width: 1.5),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "OK",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
