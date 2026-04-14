import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fashion_app/config/kinetic_theme.dart';
import 'package:fashion_app/screens/kinetic_home_screen.dart';
import 'package:fashion_app/screens/kinetic_collection_screen.dart';

/// KINETIC Main Screen with Navigation
/// Features: Bottom navigation bar, screen switching, premium styling
class KineticMainScreen extends StatefulWidget {
  const KineticMainScreen({Key? key}) : super(key: key);

  @override
  State<KineticMainScreen> createState() => _KineticMainScreenState();
}

class _KineticMainScreenState extends State<KineticMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const KineticHomeScreen(),
    const KineticCollectionScreen(),
    const _WishlistScreen(),
    const _AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// Build Premium Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    final navItems = [
      {'icon': Icons.home, 'label': 'Home'},
      {'icon': Icons.shopping_bag, 'label': 'Shop'},
      {'icon': Icons.favorite, 'label': 'Wishlist'},
      {'icon': Icons.person, 'label': 'Account'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: KineticTheme.surface,
        border: Border(
          top: BorderSide(
            color: KineticTheme.outlineVariant.withOpacity(0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              navItems.length,
              (index) => _buildNavItem(
                index,
                navItems[index]['icon'] as IconData,
                navItems[index]['label'] as String,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build Navigation Item
  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? KineticTheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? KineticTheme.primary
                  : KineticTheme.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? KineticTheme.primary
                    : KineticTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Wishlist Screen Placeholder
class _WishlistScreen extends StatelessWidget {
  const _WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KineticTheme.background,
      appBar: AppBar(
        backgroundColor: KineticTheme.surface.withOpacity(0.7),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'WISHLIST',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: KineticTheme.primary,
            letterSpacing: 0.2,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite,
              size: 80,
              color: KineticTheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Your Wishlist is Empty',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: KineticTheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add items to your wishlist to save them for later',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: KineticTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Account Screen Placeholder
class _AccountScreen extends StatelessWidget {
  const _AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KineticTheme.background,
      appBar: AppBar(
        backgroundColor: KineticTheme.surface.withOpacity(0.7),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'ACCOUNT',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: KineticTheme.primary,
            letterSpacing: 0.2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),

            // Profile Header
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: KineticTheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: KineticTheme.primary,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: KineticTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to KINETIC',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: KineticTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to access your account',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: KineticTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Account Menu Items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildAccountMenuItem(
                    icon: Icons.person_outline,
                    title: 'My Profile',
                    subtitle: 'View and edit your profile',
                  ),
                  const SizedBox(height: 12),
                  _buildAccountMenuItem(
                    icon: Icons.shopping_bag_outlined,
                    title: 'My Orders',
                    subtitle: 'View your order history',
                  ),
                  const SizedBox(height: 12),
                  _buildAccountMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Addresses',
                    subtitle: 'Manage your addresses',
                  ),
                  const SizedBox(height: 12),
                  _buildAccountMenuItem(
                    icon: Icons.payment_outlined,
                    title: 'Payment Methods',
                    subtitle: 'Manage your payment methods',
                  ),
                  const SizedBox(height: 12),
                  _buildAccountMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    subtitle: 'App settings and preferences',
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
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
                        'Sign In',
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
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Build Account Menu Item
  Widget _buildAccountMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KineticTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KineticTheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: KineticTheme.primary,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: KineticTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: KineticTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: KineticTheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
