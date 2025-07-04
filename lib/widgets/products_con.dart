import 'package:ecom_app/view/cart/product_dialog.dart';
import 'package:flutter/material.dart';

class ProductInfo extends StatelessWidget {
  final String link;
  final String title;
  final String price;

  const ProductInfo({
    super.key,
    required this.link,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Font and icon scaling based on screen width
    final fontSize = screenWidth * 0.027; // slight increase for readability
    final iconSize = screenWidth * 0.035;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Take width of the Grid item from LayoutBuilder
        final itemWidth = constraints.maxWidth;
        final imageHeight = itemWidth; // maintain square image

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Responsive image container
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: SizedBox(
                  height: imageHeight,
                  width: double.infinity,
                  child: Image.asset(
                    link,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: itemWidth * 0.05,
                  vertical: itemWidth * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          price,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize,
                            color: Colors.teal,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            final parsedPrice = double.tryParse(
                                    price.replaceAll(RegExp(r'[^0-9.]'), '')) ??
                                0.0;

                            showDialog(
                              context: context,
                              builder: (_) => ProductDialog(
                                image: link,
                                title: title,
                                price: parsedPrice,
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: EdgeInsets.all(itemWidth * 0.03),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              size: iconSize,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
