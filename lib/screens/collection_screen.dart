import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fashion_app/config/kinetic_theme.dart';

/// KINETIC Collection Screen
/// Features: Product grid, filters, neubrutalism styling, search
class CollectionScreen extends StatefulWidget {
  const CollectionScreen({Key? key}) : super(key: key);

  @override
  State<CollectionScreen> createState() =>
      _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedSort = 'Latest';
  bool _showFilters = false;

  final categories = ['All', 'Footwear', 'Apparel', 'Accessories', 'Bags'];
  final sortOptions = ['Latest', 'Price: Low to High', 'Price: High to Low', 'Most Popular'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KineticTheme.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Bar
            _buildSearchBar(),
            const SizedBox(height: 16),

            // Category Filter
            _buildCategoryFilter(),
            const SizedBox(height: 16),

            // Sort & Filter Options
            _buildSortAndFilter(),
            const SizedBox(height: 24),

            // Products Grid
            _buildProductsGrid(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Build App Bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: KineticTheme.surface.withOpacity(0.7),
      elevation: 0,
      centerTitle: true,
      title: Text(
        'COLLECTION',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: KineticTheme.primary,
          letterSpacing: 0.2,
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: KineticTheme.surfaceContainer,
          shape: BoxShape.circle,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            customBorder: const CircleBorder(),
            child: const Icon(Icons.arrow_back, color: KineticTheme.onSurface),
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: KineticTheme.surfaceContainer,
            shape: BoxShape.circle,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              customBorder: const CircleBorder(),
              child: const Icon(Icons.shopping_bag,
                  color: KineticTheme.onSurface),
            ),
          ),
        ),
      ],
    );
  }

  /// Build Search Bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: KineticTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: KineticTheme.outlineVariant),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: KineticTheme.onSurfaceVariant.withOpacity(0.5),
            ),
            prefixIcon: const Icon(Icons.search,
                color: KineticTheme.onSurfaceVariant),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear,
                        color: KineticTheme.onSurfaceVariant),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: KineticTheme.onSurface,
          ),
          onChanged: (value) => setState(() {}),
        ),
      ),
    );
  }

  /// Build Category Filter
  Widget _buildCategoryFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) {
            final isSelected = _selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedCategory = category),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? KineticTheme.primary
                        : KineticTheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? KineticTheme.primary
                          : KineticTheme.outlineVariant,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    category,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? KineticTheme.onPrimary
                          : KineticTheme.onSurface,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Build Sort & Filter Options
  Widget _buildSortAndFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Sort Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: KineticTheme.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: KineticTheme.outlineVariant),
            ),
            child: DropdownButton<String>(
              value: _selectedSort,
              underline: const SizedBox(),
              items: sortOptions.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(
                    option,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: KineticTheme.onSurface,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedSort = value);
              },
              icon: const Icon(Icons.arrow_drop_down,
                  color: KineticTheme.onSurface),
            ),
          ),

          // Filter Button
          GestureDetector(
            onTap: () => setState(() => _showFilters = !_showFilters),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _showFilters
                    ? KineticTheme.primary.withOpacity(0.1)
                    : KineticTheme.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _showFilters
                      ? KineticTheme.primary
                      : KineticTheme.outlineVariant,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.tune, size: 18, color: KineticTheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    'Filters',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: KineticTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build Products Grid
  Widget _buildProductsGrid() {
    final products = List.generate(12, (index) {
      return {
        'id': index,
        'name': [
          'Premium Sneaker',
          'Luxury Coat',
          'Designer Bag',
          'Elegant Watch',
          'Silk Scarf',
          'Leather Belt',
          'Athletic Shoe',
          'Wool Sweater',
          'Denim Jacket',
          'Casual Shirt',
          'Formal Pants',
          'Summer Dress',
        ][index],
        'price': [
          '\$420',
          '\$890',
          '\$1,250',
          '\$2,500',
          '\$180',
          '\$320',
          '\$350',
          '\$280',
          '\$450',
          '\$120',
          '\$200',
          '\$380',
        ][index],
        'rating': 4 + (index % 2),
      };
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) =>
            _buildProductCard(products[index]),
      ),
    );
  }

  /// Build Product Card with Neubrutalism
  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        // Navigate to product detail
      },
      child: Container(
        decoration: BoxDecoration(
          color: KineticTheme.surfaceContainerLowest,
          boxShadow: [
            BoxShadow(
              color: KineticTheme.primary.withOpacity(0.15),
              blurRadius: 0,
              offset: const Offset(8, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: Container(
                color: KineticTheme.surfaceContainer,
                child: Stack(
                  children: [
                    // Gradient Background
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            KineticTheme.primary.withOpacity(0.05),
                            KineticTheme.secondary.withOpacity(0.05),
                          ],
                        ),
                      ),
                    ),

                    // Product Icon
                    Center(
                      child: Icon(
                        Icons.shopping_bag,
                        size: 80,
                        color: KineticTheme.primary.withOpacity(0.3),
                      ),
                    ),

                    // Favorite Button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: KineticTheme.surfaceContainerLowest,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          size: 18,
                          color: KineticTheme.primary,
                        ),
                      ),
                    ),

                    // Badge
                    if (product['id'] % 3 == 0)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: KineticTheme.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'NEW',
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: KineticTheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product['name'],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: KineticTheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Rating
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          size: 12,
                          color: index < product['rating']
                              ? KineticTheme.primary
                              : KineticTheme.outlineVariant,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${product['rating']})',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: KineticTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Price
                  Text(
                    product['price'],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: KineticTheme.primary,
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
