// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:ecom_app/widgets/appbar_category.dart';
import 'package:ecom_app/widgets/drawer.dart';
import 'package:ecom_app/widgets/products_con.dart';
import 'package:ecom_app/widgets/searchcontainer.dart';
import 'package:flutter/material.dart';

class Shoes extends StatefulWidget {
  Shoes({super.key});

  @override
  State<Shoes> createState() => _ShoesState();
}

class _ShoesState extends State<Shoes> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> shoeList = [
    {
      'link': 'assets/images/s4.jpeg',
      'title': 'Nike Shoes',
      'price': '\$15.00',
    },
    {
      'link': 'assets/images/s2.jpeg',
      'title': 'Nike Shoes',
      'price': '\$20.00',
    },
    {
      'link': 'assets/images/s1.jpeg',
      'title': 'Nike Shoes',
      'price': '\$15.00',
    },
    {
      'link': 'assets/images/s7.jpeg',
      'title': 'Nike Shoes',
      'price': '\$20.00',
    },
    {
      'link': 'assets/images/s3.jpeg',
      'title': 'Nike Shoes',
      'price': '\$20.00',
    },
    {
      'link': 'assets/images/s5.jpeg',
      'title': 'Nike Shoes',
      'price': '\$20.00',
    },
    {
      'link': 'assets/images/s8.jpeg',
      'title': 'Nike Shoes',
      'price': '\$20.00',
    },
    {
      'link': 'assets/images/s6.jpeg',
      'title': 'Nike Shoes',
      'price': '\$20.00',
    },
  ];

  List<Map<String, String>> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = shoeList;
  }

  void _filterProducts(String query) {
    final results = shoeList.where((item) {
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
        appBar: categoryBar(context, 'Shoes', Icons.shopping_cart_outlined),
        body: SingleChildScrollView(
            child: Column(children: [
          CustomSearchBar(
            controller: _searchController,
            onChanged: _filterProducts,
            hintText: 'Search Shoes',
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
              itemCount: shoeList.length,
              itemBuilder: (context, index) {
                String link =
                    shoeList[index]['link'] ?? 'assets/default_image.png';
                String title = shoeList[index]['title'] ?? 'Unknown';
                String price = shoeList[index]['price'] ?? 'Not Available';
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
