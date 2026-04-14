import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fashion_app/providers/product_provider.dart';
import 'package:fashion_app/providers/auth_provider.dart';
import 'package:fashion_app/providers/cart_provider.dart';
import 'package:fashion_app/widgets/advanced_product_card.dart';
import 'package:fashion_app/widgets/custom_app_bar.dart';
import 'package:fashion_app/config/theme.dart';

/// Premium Home Screen with Luxury Design and Advanced Product Cards
class PremiumHomeScreen extends StatefulWidget {
  const PremiumHomeScreen({Key? key}) : super(key: key);

  @override
  State<PremiumHomeScreen> createState() => _PremiumHomeScreenState();
}

class _PremiumHomeScreenState extends State<PremiumHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
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

    // Load featured products
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadFeaturedProducts();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final authProvider = context.watch<AuthProvider>();
    final cartProvider = context.watch<CartProvider>();
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: LuxeTheme.luxeWhite,
      appBar: CustomAppBar(
        title: 'LUXE',
        showSearch: true,
        onSearch: (query) {
          productProvider.searchProducts(query);
        },
        onCartTap: () => context.push('/cart'),
        cartItemCount: cartProvider.itemCount,
        onProfileTap: () {
          if (authProvider.isAuthenticated) {
            context.push('/profile');
          } else {
            context.push('/login');
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Hero Section with Premium Design
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildPremiumHeroSection(context, isArabic),
              ),
            ),

            const SizedBox(height: 48),

            /// Categories Section
            _buildCategoriesSection(context, isArabic),

            const SizedBox(height: 48),

            /// Featured Products Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isArabic ? 'المنتجات المميزة' : 'Featured Products',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: LuxeTheme.darkCharcoal,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/products'),
                        child: Text(
                          isArabic ? 'عرض الكل' : 'View All',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: LuxeTheme.primaryGold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  /// Products Grid
                  if (productProvider.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (productProvider.featuredProducts.isEmpty)
                    Center(
                      child: Text(
                        isArabic ? 'لا توجد منتجات مميزة' : 'No featured products',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: LuxeTheme.textGrey,
                        ),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: productProvider.featuredProducts.length,
                      itemBuilder: (context, index) {
                        final product =
                            productProvider.featuredProducts[index];
                        final isFavorite =
                            authProvider.currentUser != null &&
                                authProvider.isFavorite(product.id);

                        return AdvancedProductCard(
                          product: product,
                          isFavorite: isFavorite,
                          onTap: () => context.push('/product/${product.id}'),
                          onFavorite: () {
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
                          onAddToCart: () {
                            cartProvider.addToCart(
                              product: product,
                              quantity: 1,
                              selectedSize: product.sizes.isNotEmpty
                                  ? product.sizes[0]
                                  : 'M',
                              selectedColor: product.colors.isNotEmpty
                                  ? product.colors[0]
                                  : 'Black',
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isArabic
                                      ? 'تمت الإضافة للسلة'
                                      : 'Added to cart!',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            /// Newsletter Section
            _buildNewsletterSection(context, isArabic),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  /// Build premium hero section with luxury design
  Widget _buildPremiumHeroSection(BuildContext context, bool isArabic) {
    return Container(
      height: 420,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            LuxeTheme.primaryGold.withOpacity(0.15),
            LuxeTheme.primaryGold.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(LuxeTheme.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: LuxeTheme.primaryGold.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          /// Background Pattern
          Positioned(
            right: isArabic ? null : -80,
            left: isArabic ? -80 : null,
            top: -40,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: LuxeTheme.primaryGold.withOpacity(0.08),
              ),
            ),
          ),

          /// Content
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: isArabic
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Subtitle
                Text(
                  isArabic ? 'مجموعة جديدة' : 'New Collection',
                  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: LuxeTheme.primaryGold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),

                /// Title
                Text(
                  isArabic ? 'تصاميم فاخرة' : 'Premium Designs',
                  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: LuxeTheme.darkCharcoal,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 16),

                /// Description
                Text(
                  isArabic
                      ? 'اكتشفي أحدث المنتجات الفاخرة المصممة بعناية'
                      : 'Discover the latest luxury products',
                  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: LuxeTheme.textGrey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),

                /// CTA Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => context.push('/products'),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: LuxeTheme.darkCharcoal,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isArabic ? 'تسوقي الآن' : 'Shop Now',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: LuxeTheme.luxeWhite,
                          letterSpacing: 0.5,
                        ),
                      ),
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

  /// Build categories section
  Widget _buildCategoriesSection(BuildContext context, bool isArabic) {
    final categories = [
      {'name': isArabic ? 'أحذية' : 'Shoes', 'icon': '👟'},
      {'name': isArabic ? 'ملابس' : 'Clothing', 'icon': '👗'},
      {'name': isArabic ? 'إكسسوارات' : 'Accessories', 'icon': '💍'},
      {'name': isArabic ? 'حقائب' : 'Bags', 'icon': '👜'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'الفئات' : 'Categories',
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: LuxeTheme.darkCharcoal,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Container(
                  width: 90,
                  margin: EdgeInsets.only(
                    right: isArabic ? 0 : 12,
                    left: isArabic ? 12 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: LuxeTheme.softGrey,
                    borderRadius: BorderRadius.circular(LuxeTheme.radiusMedium),
                    border: Border.all(
                      color: LuxeTheme.borderGrey,
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      borderRadius:
                          BorderRadius.circular(LuxeTheme.radiusMedium),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            category['icon']!,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category['name']!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: LuxeTheme.darkCharcoal,
                            ),
                          ),
                        ],
                      );
                    ),
                  );
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Build newsletter section
  Widget _buildNewsletterSection(BuildContext context, bool isArabic) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: LuxeTheme.darkCharcoal,
        borderRadius: BorderRadius.circular(LuxeTheme.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'اشتركي في النشرة البريدية' : 'Subscribe to Newsletter',
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: LuxeTheme.luxeWhite,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isArabic
                ? 'احصلي على أحدث العروض والمنتجات الجديدة'
                : 'Get the latest offers and new products',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: LuxeTheme.luxeWhite.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: LuxeTheme.luxeWhite,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: isArabic ? 'بريدك الإلكتروني' : 'Your email',
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.poppins(
                        color: LuxeTheme.textGrey,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: LuxeTheme.primaryGold,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isArabic ? 'اشترك' : 'Subscribe',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: LuxeTheme.darkCharcoal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
