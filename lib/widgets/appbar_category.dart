import 'package:ecom_app/view/cart/addcart.dart';
import 'package:ecom_app/view/home.dart';
import 'package:flutter/material.dart';

@override
PreferredSizeWidget categoryBar(BuildContext context, String barTitle,
    [IconData? iconn]) {
  return AppBar(
    leading: IconButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        },
        icon: const Icon(
          Icons.navigate_before,
          color: Colors.white,
        )),
    backgroundColor: Colors.teal,
    titleTextStyle: const TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    title: Text(barTitle),
    centerTitle: true,
    actions: [
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddToCart()),
          );
        },
        icon: Icon(
          iconn,
          color: Colors.white,
        ),
      ),
    ],
  );
}
