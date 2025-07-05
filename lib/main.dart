import 'package:ecommerce/app.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ecommerce/feature/home/data/model/product_model.dart';
import 'package:ecommerce/feature/cart/data/model/cart_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(RatingAdapter());
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(CartModelAdapter());

  runApp(const MyApp());
}
