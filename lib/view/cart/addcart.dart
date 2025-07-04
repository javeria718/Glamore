// ✅ FILE: add_to_cart.dart

import 'package:ecom_app/Model/cartModel';

import 'package:ecom_app/Singleton/cartsingleton.dart';
import 'package:ecom_app/view/cart/checkout.dart';
import 'package:ecom_app/widgets/appbar_category.dart';
import 'package:ecom_app/widgets/cartitems.dart';
import 'package:ecom_app/widgets/custombotton.dart';
import 'package:flutter/material.dart';

class AddToCart extends StatefulWidget {
  const AddToCart({super.key});

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  List<CartItemModel> cartItems = [];

  Future<void> loadCart() async {
    await CartSingleton().loadCartFromFirestore();
    setState(() {
      cartItems = CartSingleton().cartItems;
    });
  }

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BottomAppBar(
          color: const Color.fromARGB(255, 118, 175, 169),
          height: 105,
          child: Column(
            children: [
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Total: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text:
                          '\$${CartSingleton().totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              CustomButton(
                label: 'Check Out',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CheckoutPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: categoryBar(context, 'Cart'),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2),
        child: FutureBuilder<void>(
          future: CartSingleton().loadCartFromFirestore(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final cartItems = CartSingleton().cartItems;

            if (cartItems.isEmpty) {
              return const Center(child: Text("Cart is empty"));
            }

            return ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (BuildContext context, int index) {
                final item = cartItems[index];

                return Column(
                  children: [
                    CartItems(
                      name: item.productName,
                      price: (item.productPrice * item.numberOfItems)
                          .toStringAsFixed(2),
                      image: 'assets/images/iv.jpg',
                      quantity: item.numberOfItems,
                      onIncrement: () async {
                        await CartSingleton()
                            .incrementQuantity(item.productName);
                        setState(() {});
                      },
                      onDecrement: () async {
                        await CartSingleton()
                            .decrementQuantity(item.productName);
                        setState(() {});
                      },
                      onDelete: () async {
                        await CartSingleton().removeItem(item.productName);
                        setState(() {});
                      },
                    ),
                    if (index != cartItems.length - 1)
                      const SizedBox(height: 6),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
