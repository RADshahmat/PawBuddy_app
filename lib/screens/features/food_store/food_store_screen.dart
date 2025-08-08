import 'package:flutter/material.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/glass_container.dart';
import '../../../widgets/animated_card.dart';
import '../../../utils/app_colors.dart';
import '../../checkout/checkout.dart';

class FoodStoreScreen extends StatefulWidget {
  @override
  State<FoodStoreScreen> createState() => _FoodStoreScreenState();
}

class _FoodStoreScreenState extends State<FoodStoreScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _cart = [];
  String _selectedCategory = 'All';
  
  final List<String> _categories = ['All', 'Medicine','Dog Food', 'Cat Food', 'Bird Food', 'Accessories'];
  
  final List<Map<String, dynamic>> _products = [
    {
      'id': '1',
      'name': 'Premium Dog Food',
      'category': 'Dog Food',
      'price': 850.0,
      'originalPrice': 1000.0,
      'description': 'High-quality nutrition for adult dogs with real chicken',
      'weight': '5kg',
      'brand': 'PetNutrition',
      'rating': 4.8,
      'inStock': true,
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSv0Yf0d4Ch64D4BuwqUmy10RWuLBgtzTs0Yg&s',
      'features': ['High Protein', 'No Artificial Colors', 'Digestive Health'],
    },
    {
      'id': '2',
      'name': 'Cat Medicine',
      'category': 'Medicine',
      'price': 650.0,
      'originalPrice': 750.0,
      'description': 'Complete nutrition for cats with salmon and tuna',
      'weight': '3kg',
      'brand': 'FelineChoice',
      'rating': 4.6,
      'inStock': true,
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ7Ncv6bN5cFcuym0fW8Z0-zDmnaCcM3IoHrg&s',
      'features': ['Omega-3', 'Hairball Control', 'Indoor Formula'],
    },
    {
      'id': '3',
      'name': 'Bird Seed Mix',
      'category': 'Bird Food',
      'price': 320.0,
      'originalPrice': 380.0,
      'description': 'Nutritious seed mix for all types of birds',
      'weight': '2kg',
      'brand': 'BirdLife',
      'rating': 4.4,
      'inStock': true,
      'image':
          'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8cGV0JTIwZm9vZHxlbnwwfHwwfHx8MA%3D%3D',
      'features': ['Vitamin Enriched', 'Natural Seeds', 'Energy Boost'],
    },
    {
      'id': '4',
      'name': 'Fish Food Flakes',
      'category': 'Fish Food',
      'price': 180.0,
      'originalPrice': 220.0,
      'description': 'Tropical fish flakes for vibrant colors',
      'weight': '500g',
      'brand': 'AquaLife',
      'rating': 4.3,
      'inStock': false,
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTx1lLu6zKgT6jUrhPhvNAfTVC4MjUtCjp8ig&s',
      'features': ['Color Enhancement', 'Easy Digestion', 'Floating Formula'],
    },
    {
      'id': '5',
      'name': 'Rabbit Pellets',
      'category': 'Rabbit Food',
      'price': 420.0,
      'originalPrice': 480.0,
      'description': 'High-fiber pellets for healthy rabbits',
      'weight': '2.5kg',
      'brand': 'BunnyBest',
      'rating': 4.7,
      'inStock': true,
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrRudrYTdy4L8FJyvCqNNspuPOK2UiSD-USw&s',
      'features': ['High Fiber', 'Timothy Hay', 'Dental Health'],
    },
    {
      'id': '6',
      'name': 'Pet Water Bowl',
      'category': 'Accessories',
      'price': 250.0,
      'originalPrice': 300.0,
      'description': 'Stainless steel water bowl for pets',
      'weight': '300g',
      'brand': 'PetEssentials',
      'rating': 4.5,
      'inStock': true,
      'image':
          'https://www.shutterstock.com/image-photo/pet-supplies-on-white-background-260nw-1364257328.jpg',
      'features': ['Stainless Steel', 'Non-Slip Base', 'Easy Clean'],
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    if (_selectedCategory == 'All') return _products;
    return _products
        .where((product) => product['category'] == _selectedCategory)
        .toList();
  }

  double get _totalPrice {
    return _cart.fold(
      0.0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal Food Store'),
        backgroundColor: Colors.transparent,
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: _showCart,
                icon: const Icon(Icons.shopping_cart_rounded),
              ),
              if (_cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${_cart.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: GradientBackground(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Category Filter
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category;

                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: AnimatedCard(
                        onTap: () =>
                            setState(() => _selectedCategory = category),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? LinearGradient(
                                    colors: [
                                      AppColors.primary,
                                      AppColors.primaryLight,
                                    ],
                                  )
                                : null,
                            color: isSelected
                                ? null
                                : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : AppColors.glassBorder,
                            ),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Products Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    childAspectRatio: 0.55,
                  ),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index];
                    return _buildProductCard(product);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _cart.isNotEmpty ? _buildBottomBar() : null,
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final isInStock = product['inStock'] as bool;

    return AnimatedCard(
      onTap: () => _showProductDetails(product),
      child: GlassContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primary.withOpacity(0.1),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Image.network(
                        product['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.pets_rounded,
                            size: 40,
                            color: AppColors.primary,
                          );
                        },
                      ),
                    ),
                    if (!isInStock)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'OUT OF STOCK',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${product['rating']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Product Info
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product['weight']} • ${product['brand']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '৳${product['price'].toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (product['originalPrice'] != product['price'])
                        Text(
                          '৳${product['originalPrice'].toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isInStock ? () => _addToCart(product) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isInStock
                            ? AppColors.primary
                            : AppColors.textLight,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        isInStock ? 'Add to Cart' : 'Out of Stock',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_cart.length} items',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '৳${_totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                proceedToCheckout(
                  context,
                  totalPrice: _totalPrice,
                  clearCart: () => setState(() => _cart.clear()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetails(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primary.withOpacity(0.1),
                ),
                child: Image.network(
                  product['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.pets_rounded,
                      size: 60,
                      color: AppColors.primary,
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              Text(
                product['name'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                product['description'],
                style: const TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Text(
                    '৳${product['price'].toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (product['originalPrice'] != product['price'])
                    Text(
                      '৳${product['originalPrice'].toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              const Text(
                'Features:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (product['features'] as List<String>)
                    .map(
                      (feature) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          feature,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: product['inStock']
                          ? () {
                              Navigator.pop(context);
                              _addToCart(product);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Add to Cart'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToCart(Map<String, dynamic> product) {
    final existingIndex = _cart.indexWhere(
      (item) => item['id'] == product['id'],
    );

    if (existingIndex >= 0) {
      setState(() {
        _cart[existingIndex]['quantity']++;
      });
    } else {
      setState(() {
        _cart.add({...product, 'quantity': 1});
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showCart() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Text(
                    'Shopping Cart',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => setState(() => _cart.clear()),
                    child: const Text('Clear All'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _cart.length,
                itemBuilder: (context, index) {
                  final item = _cart[index];
                  return ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                      child: Icon(Icons.pets_rounded, color: AppColors.primary),
                    ),
                    title: Text(item['name']),
                    subtitle: Text(
                      '৳${item['price'].toStringAsFixed(0)} x ${item['quantity']}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (item['quantity'] > 1) {
                                item['quantity']--;
                              } else {
                                _cart.removeAt(index);
                              }
                            });
                          },
                          icon: const Icon(Icons.remove_rounded),
                        ),
                        Text('${item['quantity']}'),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              item['quantity']++;
                            });
                          },
                          icon: const Icon(Icons.add_rounded),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Total: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '৳${_totalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        proceedToCheckout(
                          context,
                          totalPrice: _totalPrice,
                          clearCart: () => setState(() => _cart.clear()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Proceed to Checkout'),
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
}
