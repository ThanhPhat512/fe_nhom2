import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/food_detail_service.dart';
import '../../../models/food_detail_post.dart';
import '../../../theme/home_app_theme.dart';

class ProductDetailView extends StatefulWidget {
  final int fdcId;

  const ProductDetailView({Key? key, required this.fdcId}) : super(key: key);

  @override
  _ProductDetailViewState createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  late Future<FoodDetail?> foodDetailFuture;

  @override
  void initState() {
    super.initState();
    foodDetailFuture = FoodService.fetchFoodDetail(widget.fdcId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FitnessAppTheme.background,
      appBar: AppBar(
        backgroundColor: FitnessAppTheme.nearlyWhite,
        title: const Text(
          'Chi Tiết Sản Phẩm',
          style: TextStyle(
            fontFamily: FitnessAppTheme.fontName,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: FitnessAppTheme.darkerText,
          ),
        ),
        iconTheme: const IconThemeData(color: FitnessAppTheme.darkerText),
        elevation: 0.0,
      ),
      body: FutureBuilder<FoodDetail?>(
        future: foodDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            return _buildDetailContent(snapshot.data!);
          } else {
            return const Center(child: Text("No data available."));
          }
        },
      ),
    );
  }

  Widget _buildDetailContent(FoodDetail foodDetail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  foodDetail.imageUrl ?? '',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 100);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),

          // Product description
          Text(
            foodDetail.description ?? "No description available",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
              color: FitnessAppTheme.darkerText,
            ),
          ),
          const SizedBox(height: 8.0),

          // Publication date
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
              const SizedBox(width: 8.0),
              Text(
                "Publication Date: ${foodDetail.publicationDate ?? 'N/A'}",
                style: const TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          // Food code
          Row(
            children: [
              const Icon(Icons.qr_code, size: 20, color: Colors.grey),
              const SizedBox(width: 8.0),
              Text(
                "Food Code: ${foodDetail.foodCode ?? 'N/A'}",
                style: const TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Nutrients section
          const Text(
            "Nutrients:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: FitnessAppTheme.darkerText,
            ),
          ),
          const SizedBox(height: 8.0),

          // Nutrients list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: foodDetail.foodNutrients?.length ?? 0,
            itemBuilder: (context, index) {
              final nutrient = foodDetail.foodNutrients![index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3,
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: FitnessAppTheme.nearlyBlue,
                    child: Icon(Icons.food_bank, color: Colors.white),
                  ),
                  title: Text(
                    nutrient.nutrient?.name ?? "Unknown Nutrient",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  subtitle: Text(
                    "Amount: ${nutrient.amount?.toStringAsFixed(2) ?? 'N/A'} ${nutrient.nutrient?.unitName ?? ''}",
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
