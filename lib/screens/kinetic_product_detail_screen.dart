import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fashion_app/config/kinetic_theme.dart';

/// KINETIC Product Detail Screen
/// Features: 4D product visualization, glassmorphism, interactive animations
class KineticProductDetailScreen extends StatefulWidget {
  final String productName;
  final String productPrice;
  final String productDescription;

  const KineticProductDetailScreen({
    Key? key,
    required this.productName,
    required this.productPrice,
    required this.productDescription,
  }) : super(key: key);

  @override
  State<KineticProductDetailScreen> createState() =>
      _KineticProductDetailScreenState();
}

class _KineticProductDetailScreenState extends State<KineticProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  double _rotationX = 0;
  double _rotationY = 0;
  int _selectedSize = 1;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 6.28).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _onProductImageDrag(DragUpdateDetails details) {
    setState(() {
      _rotationY += details.delta.dx * 0.01;
      _rotationX -= details.delta.dy * 0.01;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KineticTheme.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 4D Product Image Section
            _build4DProductImage(),
            const SizedBox(height: 32),

            // Product Info Section
            _buildProductInfo(),
            const SizedBox(height: 32),

            // Size Selection
            _buildSizeSelection(),
            const SizedBox(height: 32),

            // Quantity & Add to Cart
            _buildQuantityAndCart(),
            const SizedBox(height: 32),

            // Description Section
            _buildDescriptionSection(),
            const SizedBox(height: 32),

            // Reviews Section
            _buildReviewsSection(),
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
              child: const Icon(Icons.favorite_border,
                  color: KineticTheme.onSurface),
            ),
          ),
        ),
      ],
    );
  }

  /// Build 4D Product Image with Interactive Rotation
  Widget _build4DProductImage() {
    return Container(
      height: 500,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: KineticTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: KineticTheme.primary.withOpacity(0.15),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: GestureDetector(
        onPanUpdate: _onProductImageDrag,
        child: MouseRegion(
          onHover: (event) {
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
            final localPosition = renderBox.globalToLocal(event.position);
            setState(() {
              _rotationY = (localPosition.dx / renderBox.size.width - 0.5) * 0.3;
              _rotationX = (localPosition.dy / renderBox.size.height - 0.5) * 0.3;
            });
          },
          onExit: (_) {
            setState(() {
              _rotationX = 0;
              _rotationY = 0;
            });
          },
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
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              // 4D Rotating Product
              Center(
                child: AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateX(_rotationX)
                        ..rotateY(_rotationY + _rotationAnimation.value)
                        ..rotateZ(0.05),
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              KineticTheme.primary,
                              KineticTheme.primary.withOpacity(0.7),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: KineticTheme.primary.withOpacity(0.3),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.shopping_bag,
                          size: 120,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Shadow Below Product
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 200,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.ellipse,
                      color: Colors.black.withOpacity(0.1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Drag Hint
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Drag to rotate',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: KineticTheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build Product Info
  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          Text(
            widget.productName,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: KineticTheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Rating & Reviews
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  Icons.star,
                  size: 16,
                  color: index < 4
                      ? KineticTheme.primary
                      : KineticTheme.outlineVariant,
                );
              }),
              const SizedBox(width: 8),
              Text(
                '(128 reviews)',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: KineticTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Price
          Text(
            widget.productPrice,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: KineticTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// Build Size Selection
  Widget _buildSizeSelection() {
    final sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SELECT SIZE',
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: KineticTheme.onSurfaceVariant,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              sizes.length,
              (index) => GestureDetector(
                onTap: () => setState(() => _selectedSize = index),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _selectedSize == index
                        ? KineticTheme.primary
                        : KineticTheme.surfaceContainer,
                    border: Border.all(
                      color: _selectedSize == index
                          ? KineticTheme.primary
                          : KineticTheme.outlineVariant,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      sizes[index],
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _selectedSize == index
                            ? KineticTheme.onPrimary
                            : KineticTheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build Quantity & Add to Cart
  Widget _buildQuantityAndCart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Quantity Selector
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: KineticTheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_quantity > 1) setState(() => _quantity--);
                      },
                      icon: const Icon(Icons.remove,
                          size: 20, color: KineticTheme.onSurface),
                    ),
                    SizedBox(
                      width: 40,
                      child: Center(
                        child: Text(
                          _quantity.toString(),
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: KineticTheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _quantity++),
                      icon: const Icon(Icons.add,
                          size: 20, color: KineticTheme.onSurface),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KineticTheme.primary,
                    foregroundColor: KineticTheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'ADD TO CART',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: KineticTheme.primary,
                side: const BorderSide(color: KineticTheme.primary),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'BUY NOW',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build Description Section
  Widget _buildDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DESCRIPTION',
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: KineticTheme.onSurfaceVariant,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.productDescription,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: KineticTheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: KineticTheme.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Key Features',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: KineticTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                ...[
                  'Premium materials',
                  'Sustainable production',
                  'Lifetime warranty',
                  'Free shipping worldwide',
                ].map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            size: 16, color: KineticTheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          feature,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: KineticTheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build Reviews Section
  Widget _buildReviewsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CUSTOMER REVIEWS',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: KineticTheme.onSurfaceVariant,
                  letterSpacing: 0.2,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: KineticTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: KineticTheme.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sarah Johnson',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: KineticTheme.onSurface,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          size: 14,
                          color: index < 5
                              ? KineticTheme.primary
                              : KineticTheme.outlineVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Absolutely stunning product! The quality is exceptional and the design is timeless.',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: KineticTheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
