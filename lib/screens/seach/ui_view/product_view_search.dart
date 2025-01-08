import 'package:fe_nhom2/screens/Product/ui_view/product_detail_view.dart';
import 'package:flutter/material.dart';
import '../../../services/seach_product_service.dart';

class SeachProductView extends StatefulWidget {
  const SeachProductView({
    Key? key,
    this.mainScreenAnimationController,
    this.mainScreenAnimation,
  }) : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _SeachProductViewState createState() => _SeachProductViewState();
}

class _SeachProductViewState extends State<SeachProductView> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Future<List<Map<String, dynamic>>> productDataFuture;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    // Fetch product data on initialization
    productDataFuture = fetchProductData();
  }

  Future<List<Map<String, dynamic>>> fetchProductData() async {
    try {
      return await SearchProductService.searchProducts('apple'); // Hardcoded query
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: productDataFuture,
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
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final areaListData = snapshot.data!;
                  return AspectRatio(
                    aspectRatio: 1.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16.0),
                        physics: const BouncingScrollPhysics(),
                        itemCount: areaListData.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 24.0,
                          crossAxisSpacing: 24.0,
                          childAspectRatio: 1.0,
                        ),
                        itemBuilder: (context, index) {
                          final data = areaListData[index];
                          final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animationController!,
                              curve: Interval(
                                  (1 / areaListData.length) * index,
                                  1.0,
                                  curve: Curves.fastOutSlowIn),
                            ),
                          );
                          animationController?.forward();
                          return AreaView(
                            imagepath: data['imageUrl'] ?? '',
                            description: data['description'] ?? '',
                            fdcId: data['fdcId'], // Pass the fdcId as int
                            animation: animation,
                            animationController: animationController!,
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('No data available.'));
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class AreaView extends StatelessWidget {
  const AreaView({
    Key? key,
    required this.imagepath,
    required this.description,
    required this.fdcId,
    required this.animationController,
    required this.animation,
  }) : super(key: key);

  final String imagepath;
  final String description;
  final int fdcId; // Ensure fdcId is passed as int
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(1.1, 1.1),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  splashColor: Colors.blue.withOpacity(0.2),
                  onTap: () {
                    // Navigate to ProductDetailView and pass the fdcId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailView(fdcId: fdcId),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),


                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0), // Rounded corners
                          child: SizedBox(
                            width: 200, // Set the desired width
                            height: 145, // Set the desired height
                            child: Image.network(
                              imagepath,
                              fit: BoxFit.cover, // Ensure the image covers the container
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ?? 1)
                                          : null,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),

                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          description,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
