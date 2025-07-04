import 'package:ecom_app/widgets/appbar_category.dart';
import 'package:ecom_app/widgets/drawer.dart';
import 'package:ecom_app/widgets/products_con.dart';
import 'package:ecom_app/widgets/searchcontainer.dart';
import 'package:flutter/material.dart';

class Clothes extends StatefulWidget {
  Clothes({super.key});

  @override
  State<Clothes> createState() => _ClothesState();
}

class _ClothesState extends State<Clothes> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> productList = [
    {
      'link': 'assets/images/5555.jpg',
      'title': 'Blue Long Shirt',
      'price': '\$20.00'
    },
    {
      'link': 'assets/images/westerndress.jpg',
      'title': 'Black Modern Suit',
      'price': '\$22.00'
    },
    {
      'link': 'assets/images/983.jpg',
      'title': 'Dull Gold Suit',
      'price': '\$25.00',
    },
    {
      'link': 'assets/images/222.jpg',
      'title': 'White Shirt',
      'price': '\$29.00',
    },
    {
      'link': 'assets/images/123.jpg',
      'title': 'Red Top',
      'price': '\$40.00',
    },
    {
      'link': 'assets/images/565.jpg',
      'title': 'Light Purple Dress',
      'price': '\$10.00',
    },
    {
      'link': 'assets/images/96.jpg',
      'title': 'White JumpSuit',
      'price': '\$23.00',
    },
    {
      'link': 'assets/images/6666.jpg',
      'title': 'Jumpsuit',
      'price': '\$20.00',
    },
    {
      'link': 'assets/images/w2.jpg',
      'title': 'Formal dress',
      'price': '\$15.00',
    },
    {
      'link': 'assets/images/dress.webp',
      'title': 'Red dress',
      'price': '\$20.00',
    },
    {
      'link': 'assets/images/122.jpg',
      'title': 'Golden dress',
      'price': '\$24.00',
    },
    {
      'link': 'assets/images/213.jpg',
      'title': 'Black dress',
      'price': '\$24.00',
    },
  ];

  List<Map<String, String>> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = productList; // Initialize with all items
  }

  void _filterProducts(String query) {
    final results = productList.where((item) {
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
      appBar: categoryBar(context, 'Clothes', Icons.shopping_cart_outlined),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomSearchBar(
              controller: _searchController,
              onChanged: _filterProducts,
              hintText: 'Search Clothes',
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 600 ? 4 : 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final item = filteredList[index];
                  return ProductInfo(
                    link: item['link']!,
                    title: item['title']!,
                    price: item['price']!,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
