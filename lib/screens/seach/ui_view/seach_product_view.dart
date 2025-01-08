import 'package:flutter/material.dart';
import '../../../services/seach_product_service.dart';

class ProductSearch extends StatefulWidget {
  const ProductSearch({
    Key? key,
    this.mainScreenAnimationController,
    this.mainScreenAnimation,
  }) : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _ProductSearchState createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  final TextEditingController _searchController = TextEditingController();
  String _statusMessage = '';
  List<Map<String, dynamic>> _searchResults = []; // List to store search results

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _statusMessage = 'Please enter a search term.';
        _searchResults.clear(); // Clear previous results
      });
      return;
    }

    setState(() {
      _statusMessage = 'Searching...';
    });

    try {
      // Call API with the query
      final results = await SearchProductService.searchProducts(query);

      setState(() {
        _searchResults = results; // Update results
        _statusMessage = 'Search completed. Found ${results.length} items.';
      });
    } catch (error) {
      setState(() {
        _statusMessage = 'Error: $error';
        _searchResults.clear(); // Clear results on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Search'),
      ),
      body: AnimatedBuilder(
        animation: widget.mainScreenAnimationController!,
        builder: (BuildContext context, Widget? child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Input
                TextField(
                  controller: _searchController,
                  onSubmitted: _performSearch, // Call _performSearch when Enter is pressed
                  decoration: InputDecoration(
                    hintText: 'Enter product name...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                // Status Message
                Text(
                  _statusMessage,
                  style: TextStyle(
                    color: _statusMessage.startsWith('Error') ? Colors.red : Colors.black,
                  ),
                ),
                const SizedBox(height: 16.0),
                // Search Results
                Expanded(
                  child: _searchResults.isNotEmpty
                      ? ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final item = _searchResults[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: Image.network(
                            item['imageUrl'] ?? '',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image),
                          ),
                          title: Text(item['description'] ?? 'No description'),
                          subtitle: Text('FDC ID: ${item['fdcId']}'),
                        ),
                      );
                    },
                  )
                      : Center(
                    child: Text(
                      'No results found.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
