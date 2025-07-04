import 'package:ecom_app/view/categories/bags.dart';
import 'package:ecom_app/view/categories/clothes.dart';
import 'package:ecom_app/view/categories/jewelery.dart';
import 'package:ecom_app/view/categories/shoes.dart';
import 'package:ecom_app/view/categories/watches.dart';
import 'package:ecom_app/view/profile.dart';

import 'package:ecom_app/widgets/custom_categories.dart';
import 'package:ecom_app/widgets/drawer.dart';
import 'package:ecom_app/widgets/products_con.dart';
import 'package:ecom_app/widgets/searchcontainer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> filteredHomeList = [];
  final TextEditingController _searchController = TextEditingController();
  List categoryInfo = [
    {
      'image': 'assets/images/213.jpg',
      'title': 'Dresses',
      'pageBuilder': (BuildContext context) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Clothes()));
      },
    },
    {
      'image': 'assets/images/shoeee.jpeg',
      'title': 'Shoes',
      'pageBuilder': (BuildContext context) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Shoes()));
      },
    },
    {
      'image': 'assets/images/w1.jpeg',
      'title': 'Watches',
      'pageBuilder': (BuildContext context) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Watches()));
      },
    },
    {
      'image': 'assets/images/bags.png',
      'title': 'Bags',
      'pageBuilder': (BuildContext context) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Bags()));
      },
    },
    {
      'image': 'assets/images/j3.jpg',
      'title': 'Jewellery',
      'pageBuilder': (BuildContext context) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Jewelery()));
      },
    },
  ];

  final List<dynamic> homeList = [
    {
      'link': 'assets/images/w3.jpeg',
      'title': 'Girl\'s Watch',
      'price': '\$15.00',
    },
    {
      'link': 'assets/images/5555.jpg',
      'title': 'Blue Long Shirt',
      'price': '\$20.00',
    },
    {
      'link': 'assets/images/westerndress.jpg',
      'title': 'Black Modern Suit',
      'price': '\$22.00',
    },
    {
      'link': 'assets/images/983.jpg',
      'title': 'Dull Gold Suit',
      'price': '\$25.00',
    },
    {
      'link': 'assets/images/swiftbag.jpg',
      'title': 'Swift Bag',
      'price': '\$26.00',
    },
    {
      'link': 'assets/images/w8.jpeg',
      'title': 'Silver Watch',
      'price': '\$29.00',
    },
    {
      'link': 'assets/images/white.jpg',
      'title': 'White Shoes',
      'price': '\$40.00',
    },
  ];
  @override
  void initState() {
    super.initState();
    filteredHomeList = homeList;
  }

  void _filterHomeProducts(String query) {
    final results = homeList.where((item) {
      final title = (item['title'] ?? '').toLowerCase();
      return title.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredHomeList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: appDrawer(context),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        title: const Text('Glamoré'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile()),
              );
            },
            icon: const CircleAvatar(
              radius: 18, // control the size
              backgroundImage: AssetImage('assets/images/panda.jpg'),
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            CustomSearchBar(
              controller: _searchController,
              onChanged: _filterHomeProducts,
              hintText: 'Search Products',
            ),

            // CATEGORIES INFO

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.width *
                    0.33, // based on screen width
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryInfo.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomCategories(
                        image: categoryInfo[index]['image'],
                        title: categoryInfo[index]['title'],
                        onPressed: () {
                          if (categoryInfo[index]['pageBuilder'] != null) {
                            categoryInfo[index]['pageBuilder'](context);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),

            // TRENDING NOW
            Container(
              height: 45,
              width: double.infinity,
              color: Colors.teal,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 19),
                child: Text(
                  'Trending Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

// PRODUCTS
            // Padding(
            //   padding: const EdgeInsets.all(2.0),
            //   child: Wrap(
            //     spacing: 5, // HORIZONTAL SPACE
            //     runSpacing: 5, // VERTICAL SPACE
            //     children: List.generate(homeList.length, (int index) {
            //       String link =
            //           homeList[index]['link'] ?? 'assets/default_image.png';
            //       String title = homeList[index]['title'] ?? 'Unknown';
            //       String price = homeList[index]['price'] ?? 'Not Available';
            //       return ProductInfo(
            //         link: link,
            //         title: title,
            //         price: price,
            //       );
            //     }),
            //   ),
            //  ),

            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), //// So it doesn't scroll inside SingleChildScrollView
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 600 ? 4 : 2,
                  //  On mobile (<600px), it shows 2 items in a row.
//On bigger screens (>600px), it shows 4 items in a row — responsive!
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
// 0.75 keeps card height balanced with width.
                ),
                itemCount: filteredHomeList.length,
                itemBuilder: (context, index) {
                  String link = filteredHomeList[index]['link'] ??
                      'assets/default_image.png';
                  String title = filteredHomeList[index]['title'] ?? 'Unknown';
                  String price =
                      filteredHomeList[index]['price'] ?? 'Not Available';
                  return ProductInfo(
                    link: link,
                    title: title,
                    price: price,
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
