import 'dart:convert';
import 'package:flutter/material.dart';
import 'core/controllers/api_controller.dart';
import 'core/constants/burger_model.dart';
import 'core/services/store_catalog_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Search query controller & state
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  // Cart / Order state
  final List<Map<String, dynamic>> _cartItems = [];
  double _subtotal = 0.0;

  final ApiController _apiController = ApiController();
  final StoreCatalogService _catalogService = const StoreCatalogService();
  late Future<List<Map<String, dynamic>>> _futureApiData;

  @override
  void initState() {
    super.initState();
    _futureApiData = _apiController.getPosts();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addToOrder(Burger burger) {
    setState(() {
      _cartItems.add({'title': burger.title, 'price': burger.price});
      // Clean price string to double for calculation
      double cleanPrice = double.parse(burger.price.replaceAll('\$', ''));
      _subtotal += cleanPrice;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${burger.title} added to order!'), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Burger Station Dashboard'),
        backgroundColor: Colors.deepPurple[100],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Welcome Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              color: Colors.grey[100],
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome to Dashboard!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Authentication successful. Swipe right or tap top-left menu to open the Navigation Drawer.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 2. Rewards Status Bar
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.deepPurple[100]!),
              ),
              child: const Row(
                children: [
                  Icon(Icons.star, color: Colors.deepPurple),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rewards Status', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('500 Loyalty Points Available', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Section Title
            const Text('Create Order & Browse Burgers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Service Catalog', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),

            FutureBuilder<List<Map<String, dynamic>>>(
              future: _futureApiData,
              builder: (context, snapshot) {
                final responseText = snapshot.hasData
                    ? const JsonEncoder.withIndent('  ').convert(snapshot.data)
                    : snapshot.hasError
                        ? 'Unable to load JSON: ${snapshot.error}'
                        : 'Loading JSON response...';

                return Card(
                  margin: EdgeInsets.zero,
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: const Text('API JSON Response'),
                    subtitle: const Text('GET /posts?_limit=5'),
                    children: [
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxHeight: 220),
                        padding: const EdgeInsets.all(12),
                        color: Colors.black87,
                        child: SingleChildScrollView(
                          child: SelectableText(
                            responseText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // 4. Search Bar & Filter Chips (Lab Criterion: Search View Filtering)
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search for a burger...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 3,
                  child: Wrap(
                    spacing: 4,
                    children: ['All', 'Beef', 'Chicken', 'Veggie'].map((category) {
                      return ChoiceChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 5. Dynamic Burger Cards Presentation (Lab Criterion: FutureBuilder & Dynamic GridView)
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _futureApiData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text('Error loading catalog: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No burgers available in catalog.'));
                }

                final burgers = _catalogService.getCatalog(apiItems: snapshot.data!);

                // Filter burgers based on search text and category chips
                List<Burger> filteredBurgers = burgers.where((burger) {
                  bool matchesSearch = burger.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      burger.description.toLowerCase().contains(_searchQuery.toLowerCase());
                  bool matchesCategory = _selectedCategory == 'All' || burger.category == _selectedCategory;
                  return matchesSearch && matchesCategory;
                }).toList();

                if (filteredBurgers.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Center(child: Text('No matching burgers found.')),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.95,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: filteredBurgers.length,
                  itemBuilder: (context, index) {
                    final burger = filteredBurgers[index];
                    return _buildBurgerCard(
                      title: burger.title,
                      description: burger.description,
                      price: burger.price,
                      imageUrl: burger.imageUrl,
                      onAddPressed: () => _addToOrder(burger),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // 6. Current Order Summary Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple[100]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Current Order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Subtotal: \$${_subtotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const Divider(),
                  if (_cartItems.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Your order is empty. Click "Add" on any burger above!', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    )
                  else
                    ..._cartItems.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text('• ${item['title']} (${item['price']})'),
                        )),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                      onPressed: _cartItems.isEmpty
                          ? null
                          : () {
                              showDialog(
                                context: dialogContext = context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Order Placed Successfully!'),
                                  content: Text('Your total is \$${_subtotal.toStringAsFixed(2)}. Thank you!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        setState(() {
                                          _cartItems.clear();
                                          _subtotal = 0.0;
                                        });
                                      },
                                      child: const Text('OK'),
                                    )
                                  ],
                                ),
                              );
                            },
                      child: const Text('Checkout', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for individual burger cards with images & functioning Add button
  Widget _buildBurgerCard({
    required String title,
    required String description,
    required String price,
    required String imageUrl,
    required VoidCallback onAddPressed,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.asset(
              imageUrl,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 110,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.fastfood, size: 40, color: Colors.grey)),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 2),
                      Text(description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                          minimumSize: const Size(40, 22),
                          backgroundColor: Colors.deepPurple[100],
                        ),
                        onPressed: onAddPressed,
                        child: const Text('Add', style: TextStyle(fontSize: 10)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Reference for dialog context safely
  late BuildContext dialogContext;
}