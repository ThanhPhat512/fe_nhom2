import 'package:flutter/material.dart';
import 'package:fe_nhom2/components/buy_full_ui_kit.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BuyFullKit(images: [
      "assets/screens/reviews.png",
      "assets/screens/Add review rate.png"
    ]);
  }
}
