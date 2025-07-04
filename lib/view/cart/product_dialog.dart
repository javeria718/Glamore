import 'package:ecom_app/Model/cartModel';

import 'package:ecom_app/Singleton/cartsingleton.dart';
import 'package:ecom_app/Singleton/singleton.dart';
import 'package:flutter/material.dart';

class ProductDialog extends StatefulWidget {
  final String image;
  final String title;
  final double price;

  const ProductDialog({
    super.key,
    required this.image,
    required this.title,
    required this.price,
  });

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  int quantity = 1;

  void increment() => setState(() => quantity++);
  void decrement() => setState(() {
        if (quantity > 1) quantity--;
      });

  @override
  Widget build(BuildContext context) {
    double total = widget.price * quantity;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    widget.image,
                    width: 100,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),

                // Product Title
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                // Price (in $)
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),

                const SizedBox(height: 12),

                // Quantity Control + Add Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: decrement,
                    ),
                    Text(
                      quantity.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: increment,
                    ),
                    const SizedBox(width: 12),

                    // Add to Cart Button
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 30),
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final userName =
                              UserSingleton().userModel?.name ?? "Guest";

                          final cartItem = CartItemModel(
                            productName: widget.title,
                            customerName: userName,
                            productPrice: widget.price,
                            numberOfItems: quantity,
                          );

                          await CartSingleton().addToCart(cartItem);
                          await CartSingleton().loadCartFromFirestore();

                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${widget.title} added to cart!'),
                                backgroundColor: Colors.teal,
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Add To Cart",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Close Button
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
