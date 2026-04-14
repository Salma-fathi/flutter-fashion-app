import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fashion_app/config/kinetic_theme.dart';

/// KINETIC Premium Home Screen
/// Features: Hero section with 4D product showcase, glassmorphism, neubrutalism styling
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatingController.dispose();
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
            // Hero Section
            _buildHeroSection(),
            const SizedBox(height: 48),

            // Featured Collection
            _buildFeaturedCollection(),
            const SizedBox(height: 48),

            // New Arrivals Grid
            _buildNewArrivals(),
            const SizedBox(height: 48),

            // Newsletter Section
            _buildNewsletterSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Build Premium AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: KineticTheme.surface.withOpacity(0.7),
      elevation: 0,
      centerTitle: true,
      title: Text(
        'KINETIC',
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
            onTap: () {},
            customBorder: const CircleBorder(),
            child: const Icon(Icons.menu, color: KineticTheme.onSurface),
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

  /// Build Hero Section with 4D Floating Product
  Widget _buildHeroSection() {
    return Container(
      height: 600,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            KineticTheme.primary.withOpacity(0.1),
            KineticTheme.primary.withOpacity(0.05),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background Gradients
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: KineticTheme.primary.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: KineticTheme.primary.withOpacity(0.1),
                    blurRadius: 120,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: KineticTheme.secondary.withOpacity(0.08),
                boxShadow: [
                  BoxShadow(
                    color: KineticTheme.secondary.withOpacity(0.08),
                    blurRadius: 100,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Row(
              children: [
                // Left: Text Content
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LIMITLESS SERIES',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: KineticTheme.primary,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'ZERO ONE ALPHA',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: KineticTheme.onSurface,
                          letterSpacing: -0.5,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Experience the future of premium footwear with cutting-edge design and uncompromising comfort.',
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: KineticTheme.onSurfaceVariant,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Text(
                            '\$420.00',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: KineticTheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 24),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: KineticTheme.primary,
                              foregroundColor: KineticTheme.onPrimary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Discover Now',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Right: 4D Floating Product Image
                Expanded(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _floatingAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, -_floatingAnimation.value),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateX(0.1)
                              ..rotateY(-0.15)
                              ..rotateZ(0.05),
                            child: Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 40,
                                    offset: const Offset(0, 20),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  color: KineticTheme.surfaceContainer,
                                  child: const Icon(
                                    Icons.shopping_bag,
                                    size: 100,
                                    color: KineticTheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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

  /// Build Featured Collection Section
  Widget _buildFeaturedCollection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'THE COLLECTION',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: KineticTheme.primary,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'NEW ARRIVALS',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: KineticTheme.onSurface,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: KineticTheme.primary,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: 4,
            itemBuilder: (context, index) => _buildProductCard(index),
          ),
        ],
      ),
    );
  }

  /// Build Product Card with Neubrutalism Style
  Widget _buildProductCard(int index) {
    final titles = [
      'LINEAR COAT',
      'CANARY SHELL',
      'ELITE RUNNER',
      'MINIMAL BAG',
    ];
    final prices = ['\$890', '\$540', '\$420', '\$1,250'];

    return Container(
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
                  Center(
                    child: Icon(
                      Icons.shopping_bag,
                      size: 80,
                      color: KineticTheme.primary.withOpacity(0.3),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: KineticTheme.surfaceContainerLowest,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 20,
                        color: KineticTheme.onSurface,
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
                Text(
                  titles[index],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: KineticTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  prices[index],
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: KineticTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build New Arrivals Section
  Widget _buildNewArrivals() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TRENDING NOW',
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: KineticTheme.primary,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Curated Selection',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: KineticTheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                3,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _buildTrendingItem(index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build Trending Item
  Widget _buildTrendingItem(int index) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: KineticTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            color: KineticTheme.surfaceContainerHigh,
            child: Center(
              child: Icon(
                Icons.shopping_bag,
                size: 60,
                color: KineticTheme.primary.withOpacity(0.3),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Premium Item',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: KineticTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$299.00',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: KineticTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build Newsletter Section
  Widget _buildNewsletterSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: KineticTheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'STAY UPDATED',
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: KineticTheme.onPrimary,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Subscribe to our newsletter',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: KineticTheme.onPrimary,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter your email',
              hintStyle: GoogleFonts.manrope(
                color: KineticTheme.primary.withOpacity(0.5),
              ),
              filled: true,
              fillColor: KineticTheme.onPrimary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            style: GoogleFonts.manrope(
              color: KineticTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: KineticTheme.onPrimary,
                foregroundColor: KineticTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Subscribe',
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
}
