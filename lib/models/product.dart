import 'package:flutter/material.dart';

class Product {
  final String name;
  final double price;
  final Color color;

  const Product({
    required this.name,
    required this.price,
    required this.color,
  });
}

const List<Product> products = [
  Product(name: 'Burger', price: 5.0, color: Colors.amber),
  Product(name: 'Pizza', price: 8.0, color: Colors.redAccent),
  Product(name: 'Fries', price: 3.0, color: Colors.orange),
  Product(name: 'Hotdog', price: 4.0, color: Colors.green),
];
