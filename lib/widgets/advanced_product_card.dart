import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palette_generator/palette_generator.dart';
import '../config/theme.dart';
import '../models/product.dart';
import '../services/gradient_service.dart';

/// Advanced Product Card with Premium Styling, Dynamic Gradients, and 3D Effects
class AdvancedProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback onFavorite;
  final bool isFavorite;
  final VoidCallback onTap;

  const AdvancedProductCard({
    Key? key,
    required this.product,
    required this.onAddToCart,
    required this.onFavorite,
    required this.isFavorite,
    required this.onTap,
  }) : super(key: key);

  @override
  State<AdvancedProductCard> createState() => _AdvancedProductCardState();
}

class _AdvancedProductCardState extends State<AdvancedProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  
  Color? _dominantColor;
  bool _isHovering = false;
  Offset _dragOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 0.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _extractDominantColor();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Extract dominant color from product image for dynamic gradient
  Future<void> _extractDominantColor() async {
    final color = await GradientService.extractDominantColor(
      widget.product.imageUrl,
      fallbackColor: LuxeTheme.primaryGold,
    );
    setState(() {
      _dominantColor = color;
    });
  }

  /// Build dynamic gradient background based on dominant color
  LinearGradient _buildDynamicGradient() {
    final baseColor = _dominantColor ?? LuxeTheme.primaryGold;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        baseColor.withOpacity(0.15),
        baseColor.withOpacity(0.05),
      ],
    );
  }

  /// Build advanced gradient with multiple colors
  Future<LinearGradient> _buildAdvancedGradient() async {
    return await GradientService.generateAdvancedGradient(
      widget.product.imageUrl,
      fallbackGradient: _buildDynamicGradient(),
    );
  }

  /// Handle 3D rotation on drag
  void _onPointerMove(PointerMoveEvent event) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(event.position);
    final centerX = box.size.width / 2;
    final centerY = box.size.height / 2;

    setState(() {
      _dragOffset = Offset(
        (localPosition.dx - centerX) / centerX * 0.1,
        (localPosition.dy - centerY) / centerY * 0.1,
      );
    });
  }

  void _onPointerExit(PointerExitEvent event) {
    setState(() {
      _dragOffset = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return GestureDetector(
      onTap: widget.onTap,
      onPointerEnter: (_) {
        setState(() => _isHovering = true);
        _animationController.forward();
      },
      onPointerExit: (_) {
        setState(() => _isHovering = false);
        _animationController.reverse();
      },
      child: Listener(
        onPointerMove: _onPointerMove,
        onPointerExit: _onPointerExit,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value + _dragOffset.dx,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(LuxeTheme.radiusLarge),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x0D000000),
                        blurRadius: _isHovering ? 30 : 15,
                        offset: Offset(0, _isHovering ? 12 : 4),
                        spreadRadius: _isHovering ? 2 : 0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(LuxeTheme.radiusLarge),
                    child: Material(
                      color: LuxeTheme.luxeWhite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Product Image with Dynamic Gradient Background
                          _buildProductImageSection(isArabic),

                          /// Product Details Section
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  /// Category Tag
                                  _buildCategoryTag(),

                                  /// Product Name
                                  _buildProductName(isArabic),

                                  /// Rating and Price Row
                                  _buildRatingAndPrice(isArabic),

                                  /// Action Buttons
                                  _buildActionButtons(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            );
          },
        ),
      ),
    );
  }

  /// Build product image section with dynamic gradient
  Widget _buildProductImageSection(bool isArabic) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: _buildDynamicGradient(),
      ),
      child: Stack(
        children: [
          /// Product Image with Hero Animation
          Hero(
            tag: 'product-${widget.product.id}',
            child: Center(
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_dragOffset.dx)
                  ..rotateX(_dragOffset.dy),
                child: Image.network(
                  widget.product.imageUrl,
                  fit: BoxFit.contain,
                  width: 140,
                  height: 140,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: LuxeTheme.softGrey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              );
            ),
          ),

          /// Favorite Button (Top Right)
          Positioned(
            top: 12,
            right: isArabic ? null : 12,
            left: isArabic ? 12 : null,
            child: _buildFavoriteButton(),
          ),

          /// 3D Rotation Indicator
          if (_isHovering)
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: LuxeTheme.darkCharcoal.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'اسحب للدوران',
                    style: GoogleFonts.poppins(
                      color: LuxeTheme.luxeWhite,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            ),
        ],
      ),
    );
  }

  /// Build category tag
  Widget _buildCategoryTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: (_dominantColor ?? LuxeTheme.primaryGold).withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        widget.product.category,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _dominantColor ?? LuxeTheme.primaryGold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// Build product name with refined typography
  Widget _buildProductName(bool isArabic) {
    return Text(
      widget.product.name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      style: GoogleFonts.playfairDisplay(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: LuxeTheme.darkCharcoal,
        height: 1.3,
      ),
    );
  }

  /// Build rating and price display
  Widget _buildRatingAndPrice(bool isArabic) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Star Rating
        Row(
          children: [
            ...List.generate(
              5,
              (index) => Icon(
                index < widget.product.rating.toInt()
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                size: 14,
                color: _dominantColor ?? LuxeTheme.primaryGold,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '(${widget.product.reviews})',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: LuxeTheme.textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        /// Price
        Text(
          '${widget.product.price} ريال',
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          style: GoogleFonts.playfairDisplay(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: LuxeTheme.darkCharcoal,
          ),
        ),
      ],
    );
  }

  /// Build action buttons (Add to Cart + Favorite)
  Widget _buildActionButtons() {
    return Row(
      children: [
        /// Add to Cart Button
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onAddToCart,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: LuxeTheme.darkCharcoal,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'أضف للسلة',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: LuxeTheme.luxeWhite,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              );
            ),
          ),
        ),
        const SizedBox(width: 10),

        /// Favorite Button
        _buildFavoriteButtonSmall(),
      ],
    );
  }

  /// Build favorite button (large)
  Widget _buildFavoriteButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onFavorite,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: LuxeTheme.luxeWhite,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0x1A000000),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            widget.isFavorite ? Icons.favorite : Icons.favorite_border,
            size: 18,
            color: widget.isFavorite
                ? (_dominantColor ?? LuxeTheme.primaryGold)
                : LuxeTheme.darkCharcoal,
          ),
        ),
      );
    );
  }

  /// Build favorite button (small)
  Widget _buildFavoriteButtonSmall() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onFavorite,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: LuxeTheme.softGrey,
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.isFavorite ? Icons.favorite : Icons.favorite_border,
            size: 16,
            color: widget.isFavorite
                ? (_dominantColor ?? LuxeTheme.primaryGold)
                : LuxeTheme.darkCharcoal,
          ),
        ),
      );
    );
  }
}
