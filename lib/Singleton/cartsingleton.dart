import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/Model/cartModel';

import 'package:firebase_auth/firebase_auth.dart';

class CartSingleton {
  static final CartSingleton _instance = CartSingleton._internal();
  factory CartSingleton() => _instance;
  CartSingleton._internal();

  final List<CartItemModel> _cartItems = [];

  List<CartItemModel> get cartItems => _cartItems;

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  CollectionReference get _cartRef => FirebaseFirestore.instance
      .collection('carts')
      .doc(uid)
      .collection('items');
  Future<void> decrementQuantity(String productName) async {
    final docRef = _cartRef.doc(productName);
    final doc = await docRef.get();

    if (doc.exists) {
      final item = CartItemModel.fromJson(doc.data() as Map<String, dynamic>);
      if (item.numberOfItems > 1) {
        final updated = CartItemModel(
          productName: item.productName,
          customerName: item.customerName,
          productPrice: item.productPrice,
          numberOfItems: item.numberOfItems - 1,
        );
        await docRef.set(updated.toJson());
      } else {
        await docRef.delete(); // If quantity goes to 0, remove the item
      }
    }

    await loadCartFromFirestore();
  }

  Future<void> removeItem(String productName) async {
    final docRef = _cartRef.doc(productName);
    await docRef.delete();
    await loadCartFromFirestore();
  }

  Future<void> loadCartFromFirestore() async {
    if (uid.isEmpty) return;

    final snapshot = await _cartRef.get();
    _cartItems.clear();

    for (var doc in snapshot.docs) {
      _cartItems
          .add(CartItemModel.fromJson(doc.data() as Map<String, dynamic>));
    }
  }

  Future<void> addToCart(CartItemModel item) async {
    final docRef = _cartRef.doc(item.productName);
    final doc = await docRef.get();

    if (doc.exists) {
      final existing =
          CartItemModel.fromJson(doc.data() as Map<String, dynamic>);
      final updated = CartItemModel(
        productName: existing.productName,
        customerName: existing.customerName,
        productPrice: existing.productPrice,
        numberOfItems: existing.numberOfItems + item.numberOfItems,
      );
      await docRef.set(updated.toJson());
    } else {
      await docRef.set(item.toJson());
    }

    await loadCartFromFirestore(); // Refresh local cache
  }

  Future<void> incrementQuantity(String productName) async {
    final docRef = _cartRef.doc(productName);
    final doc = await docRef.get();

    if (doc.exists) {
      final item = CartItemModel.fromJson(doc.data() as Map<String, dynamic>);
      final updated = CartItemModel(
        productName: item.productName,
        customerName: item.customerName,
        productPrice: item.productPrice,
        numberOfItems: item.numberOfItems + 1,
      );
      await docRef.set(updated.toJson());
    }

    await loadCartFromFirestore();
  }

  double get totalPrice => _cartItems.fold(
      0.0, (sum, item) => sum + (item.productPrice * item.numberOfItems));

  Future<void> clearCart() async {
    final snapshot = await _cartRef.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
    _cartItems.clear();
  }
}
