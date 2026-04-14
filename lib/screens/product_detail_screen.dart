import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fashion_app/models/product.dart';
import 'package:fashion_app/providers/product_provider.dart';
import 'package:fashion_app/providers/cart_provider.dart';
import 'package:fashion_app/providers/auth_provider.dart';
import 'package:fashion_app/config/theme.dart';
import 'package:fashion_app/widgets/optimized_3d_product.dart';

/// Product detail screen with 3D effects and animations
class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String? _selectedSize;
  String? _selectedColor;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
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
    final productProvider = context.watch<ProductProvider>();
    final cartProvider = context.watch<CartProvider>();
    final authProvider = context.watch<AuthProvider>();

    final product = productProvider.getProductById(widget.productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: Text('Product not found')),
      );
    }

    final isFavorite = authProvider.currentUser != null &&
        authProvider.isFavorite(product.id);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: LuxeTheme.luxeWhite,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: LuxeTheme.softGrey,
            shape: BoxShape.circle,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.pop(),
              customBorder: const CircleBorder(),
              child: Icon(
                Icons.arrow_back,
                color: LuxeTheme.darkCharcoal,
              ),
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: LuxeTheme.softGrey,
              shape: BoxShape.circle,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (authProvider.isAuthenticated) {
                    if (isFavorite) {
                      authProvider.removeFromFavorites(product.id);
                    } else {
                      authProvider.addToFavorites(product.id);
                    }
                  } else {
                    context.push('/login');
                  }
                },
                customBorder: const CircleBorder(),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite
                      ? LuxeTheme.primaryGold
                      : LuxeTheme.darkCharcoal,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image with Dynamic Gradient
                _buildProductImagePremium(product),

                const SizedBox(height: 24),

                // Product Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: LuxeTheme.primaryGold.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          product.category,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: LuxeTheme.primaryGold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Title and Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: LuxeTheme.darkCharcoal,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '${product.price.toStringAsFixed(0)} ريال',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: LuxeTheme.darkCharcoal,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              ...List.generate(
                                5,
                                (index) => Icon(
                                  index < product.rating.toInt()
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  size: 16,
                                  color: LuxeTheme.primaryGold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${product.rating} (${product.reviewCount} تقييم)',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: LuxeTheme.textGrey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Divider
                      const SizedBox(height: 24),
                      Container(
                        height: 1,
                        color: LuxeTheme.borderGrey,
                      ),
                      const SizedBox(height: 24),

                      // Description
                      Text(
                        'الوصف',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: LuxeTheme.darkCharcoal,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        product.description,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: LuxeTheme.textGrey,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Size Selection
                      const SizedBox(height: 24),
                      if (product.sizes.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الحجم',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: LuxeTheme.darkCharcoal,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: product.sizes
                                  .map(
                                    (size) => GestureDetector(
                                      onTap: () {
                                        setState(() => _selectedSize = size);
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: _selectedSize == size
                                              ? LuxeTheme.darkCharcoal
                                              : LuxeTheme.softGrey,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: _selectedSize == size
                                                ? LuxeTheme.darkCharcoal
                                                : LuxeTheme.borderGrey,
                                            width: 2,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            size,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: _selectedSize == size
                                                  ? LuxeTheme.luxeWhite
                                                  : LuxeTheme.darkCharcoal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),

                      // Color Selection
                      if (product.colors.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'اللون',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: LuxeTheme.darkCharcoal,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: product.colors
                                  .map(
                                    (color) => GestureDetector(
                                      onTap: () {
                                        setState(() => _selectedColor = color);
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _parseColor(color),
                                          border: Border.all(
                                            color: _selectedColor == color
                                                ? LuxeTheme.darkCharcoal
                                                : Colors.transparent,
                                            width: 3,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: _parseColor(color)
                                                  .withOpacity(0.3),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),

                      // Quantity
                      Row(
                        children: [
                          const Text(
                            'Quantity:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: _quantity > 1
                                      ? () {
                                          setState(() => _quantity--);
                                        }
                                      : null,
                                ),
                                Text(
                                  '$_quantity',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    setState(() => _quantity++);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Add to Cart Button
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  if (_selectedSize == null || _selectedColor == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('الرجاء اختيار الحجم واللون'),
                                      ),
                                    );
                                    return;
                                  }

                                  cartProvider.addToCart(
                                    product: product,
                                    quantity: _quantity,
                                    selectedSize: _selectedSize!,
                                    selectedColor: _selectedColor!,
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('تمت الإضافة للسلة!'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: LuxeTheme.darkCharcoal,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: LuxeTheme.darkCharcoal
                                            .withOpacity(0.2),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'أضف للسلة',
                                      style: GoogleFonts.playfairDisplay(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: LuxeTheme.luxeWhite,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: LuxeTheme.softGrey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  if (authProvider.isAuthenticated) {
                                    if (isFavorite) {
                                      authProvider.removeFromFavorites(product.id);
                                    } else {
                                      authProvider.addToFavorites(product.id);
                                    }
                                  } else {
                                    context.push('/login');
                                  }
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite
                                      ? LuxeTheme.primaryGold
                                      : LuxeTheme.darkCharcoal,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImagePremium(Product product) {
    return Column(
      children: [
        Container(
          height: 350,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                LuxeTheme.primaryGold.withOpacity(0.1),
                LuxeTheme.primaryGold.withOpacity(0.05),
              ],
            ),
          ),
          child: Hero(
            tag: 'product-${product.id}',
            child: Center(
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => Container(
                  color: LuxeTheme.softGrey,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: LuxeTheme.softGrey,
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == 0
                      ? LuxeTheme.darkCharcoal
                      : LuxeTheme.borderGrey,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductImage(Product product) {
    return Container(
      height: 400,
      color: Colors.grey[100],
      child: Stack(
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
          // Stock Badge
          if (product.stock < 10)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Only ${product.stock} left',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _parseColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'orange':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
