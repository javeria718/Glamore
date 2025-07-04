// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:ecom_app/widgets/appbar_category.dart';
import 'package:ecom_app/widgets/drawer.dart';
import 'package:ecom_app/widgets/products_con.dart';
import 'package:ecom_app/widgets/searchcontainer.dart';
import 'package:flutter/material.dart';

class Jewelery extends StatefulWidget {
  Jewelery({super.key});

  @override
  State<Jewelery> createState() => _JeweleryState();
}

class _JeweleryState extends State<Jewelery> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> jeweleryList = [
    {
      'link': 'assets/images/j1.jpg',
      'title': 'Gold Bracelet',
      'price': '\$6.00',
    },
    {
      'link': 'assets/images/j4.jpg',
      'title': 'Platinum Earings',
      'price': '\$5.00',
    },
    {
      'link': 'assets/images/j6.jpg',
      'title': 'Butterfly Necklace',
      'price': '\$9.50',
    },
    {
      'link': 'assets/images/j8.jpg',
      'title': 'Necklace',
      'price': '\$8.20',
    },
    {
      'link': 'assets/images/j3.jpg',
      'title': 'Set of Rings',
      'price': '\$4.90',
    },
    {
      'link': 'assets/images/j7.jpg',
      'title': 'Set of 3 pendants',
      'price': '\$20.00',
    },
    {
      'link': 'assets/images/j5.jpg',
      'title': 'Golden Jhumka',
      'price': '\$5.50',
    },
    {
      'link': 'assets/images/j2.jpg',
      'title': 'Bracelet',
      'price': '\$4.50',
    },
  ];

  List<Map<String, String>> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = jeweleryList;
  }

  void _filterProducts(String query) {
    final results = jeweleryList.where((item) {
      final title = item['title']?.toLowerCase() ?? '';
      return title.contains(query.toLowerCase());
    }).toList();
    setState(() {
      filteredList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: Drawer(child: appDrawer(context)),
        appBar: categoryBar(context, 'Jewellery', Icons.shopping_cart_outlined),
        body: SingleChildScrollView(
            child: Column(children: [
          CustomSearchBar(
            controller: _searchController,
            onChanged: _filterProducts,
            hintText: 'Search Jewellery',
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), //// So it doesn't scroll inside SingleChildScrollView
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                //  On mobile (<600px), it shows 2 items in a row.
//On bigger screens (>600px), it shows 4 items in a row — responsive!
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
// 0.75 keeps card height balanced with width.
              ),
              itemCount: jeweleryList.length,
              itemBuilder: (context, index) {
                String link =
                    jeweleryList[index]['link'] ?? 'assets/default_image.png';
                String title = jeweleryList[index]['title'] ?? 'Unknown';
                String price = jeweleryList[index]['price'] ?? 'Not Available';
                return ProductInfo(
                  link: link,
                  title: title,
                  price: price,
                );
              },
            ),
          )
        ])));
  }
}
