import 'package:flutter/material.dart';
import '../../../services/food_detail_service.dart';
import '../../../models/food_detail_post.dart';

class ProductDetailView extends StatefulWidget {
  final int fdcId; // ID của sản phẩm cần hiển thị

  const ProductDetailView({Key? key, required this.fdcId}) : super(key: key);

  @override
  _ProductDetailViewState createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  late Future<FoodDetail?> foodDetailFuture;

  @override
  void initState() {
    super.initState();
    // Fetch chi tiết sản phẩm từ FoodService
    foodDetailFuture = FoodService.fetchFoodDetail(widget.fdcId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Detail"),
        backgroundColor: Colors.blue,
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
            final FoodDetail foodDetail = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ảnh sản phẩm
                  Center(
                    child: Image.network(
                      foodDetail.imageUrl ?? '',
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 100);
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Tên sản phẩm
                  Text(
                    foodDetail.description ?? "No description available",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  // Ngày xuất bản
                  Text(
                    "Publication Date: ${foodDetail.publicationDate ?? 'N/A'}",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),

                  // Mã sản phẩm
                  Text(
                    "Food Code: ${foodDetail.foodCode ?? 'N/A'}",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 16.0),

                  // Nutrients
                  const Text(
                    "Nutrients:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: foodDetail.foodNutrients?.length ?? 0,
                    itemBuilder: (context, index) {
                      final nutrient = foodDetail.foodNutrients![index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          title: Text(
                            nutrient.nutrient?.name ?? "Unknown Nutrient",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              "Amount: ${nutrient.amount?.toStringAsFixed(2) ?? 'N/A'} ${nutrient.nutrient?.unitName ?? ''}"),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("No data available."));
          }
        },
      ),
    );
  }


}
