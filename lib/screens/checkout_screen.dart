import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fashion_app/config/kinetic_theme.dart';

/// KINETIC Checkout Screen
/// Features: Step progress, order summary, payment form, neubrutalism styling
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  String _selectedPaymentMethod = 'credit_card';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _emailController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
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
            // Step Progress Indicator
            _buildStepProgress(),
            const SizedBox(height: 32),

            // Main Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: Form
                  Expanded(
                    flex: 7,
                    child: _buildFormSection(),
                  ),
                  const SizedBox(width: 24),

                  // Right: Order Summary (Sticky)
                  Expanded(
                    flex: 5,
                    child: _buildOrderSummary(),
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

  /// Build App Bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: KineticTheme.surface.withOpacity(0.7),
      elevation: 0,
      centerTitle: true,
      title: Text(
        'CHECKOUT',
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
    );
  }

  /// Build Step Progress Indicator
  Widget _buildStepProgress() {
    final steps = ['Shipping', 'Payment', 'Review'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: List.generate(
              steps.length,
              (index) => Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Step Circle
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: index <= _currentStep
                                ? KineticTheme.primary
                                : KineticTheme.surfaceContainer,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: index <= _currentStep
                                  ? KineticTheme.primary
                                  : KineticTheme.outlineVariant,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: index < _currentStep
                                ? const Icon(Icons.check,
                                    color: KineticTheme.onPrimary, size: 20)
                                : Text(
                                    '${index + 1}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: index <= _currentStep
                                          ? KineticTheme.onPrimary
                                          : KineticTheme.onSurfaceVariant,
                                    ),
                                  ),
                          ),
                        ),
                        // Connector Line
                        if (index < steps.length - 1)
                          Expanded(
                            child: Container(
                              height: 2,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              color: index < _currentStep
                                  ? KineticTheme.primary
                                  : KineticTheme.outlineVariant,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      steps[index],
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: index <= _currentStep
                            ? KineticTheme.primary
                            : KineticTheme.onSurfaceVariant,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build Form Section
  Widget _buildFormSection() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_currentStep == 0) ...[
            // Shipping Form
            _buildSectionTitle('Shipping Details'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'First Name',
                    controller: _firstNameController,
                    placeholder: 'JULIAN',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    label: 'Last Name',
                    controller: _lastNameController,
                    placeholder: 'VOSS',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Delivery Address',
              controller: _addressController,
              placeholder: '124 ARCHITECTURAL PLAZA, LEVEL 4',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'City',
                    controller: _cityController,
                    placeholder: 'BERLIN',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    label: 'Postal Code',
                    controller: _postalCodeController,
                    placeholder: '10115',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Contact Email',
              controller: _emailController,
              placeholder: 'CURATED@KINETIC.COM',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => setState(() => _currentStep = 1),
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
                  'Continue to Payment',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ] else if (_currentStep == 1) ...[
            // Payment Form
            _buildSectionTitle('Payment Method'),
            const SizedBox(height: 20),
            _buildPaymentMethodSelector(),
            const SizedBox(height: 24),
            _buildSectionTitle('Card Details'),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Card Number',
              controller: _cardNumberController,
              placeholder: '1234 5678 9012 3456',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Expiry Date',
                    controller: _expiryController,
                    placeholder: 'MM/YY',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    label: 'CVV',
                    controller: _cvvController,
                    placeholder: '123',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _currentStep = 0),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: KineticTheme.primary,
                      side: const BorderSide(color: KineticTheme.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Back',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _currentStep = 2),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KineticTheme.primary,
                      foregroundColor: KineticTheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Review Order',
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
          ] else if (_currentStep == 2) ...[
            // Review Form
            _buildSectionTitle('Order Review'),
            const SizedBox(height: 20),
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
                    'Shipping Address',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: KineticTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_firstNameController.text} ${_lastNameController.text}',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: KineticTheme.onSurface,
                    ),
                  ),
                  Text(
                    _addressController.text,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: KineticTheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '${_cityController.text}, ${_postalCodeController.text}',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: KineticTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order placed successfully!'),
                      backgroundColor: KineticTheme.primary,
                    ),
                  );
                },
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
                  'Confirm Order',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build Payment Method Selector
  Widget _buildPaymentMethodSelector() {
    final methods = [
      {'id': 'credit_card', 'label': 'Credit Card', 'icon': Icons.credit_card},
      {'id': 'paypal', 'label': 'PayPal', 'icon': Icons.payment},
      {'id': 'apple_pay', 'label': 'Apple Pay', 'icon': Icons.apple},
    ];

    return Column(
      children: methods.map((method) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () =>
                setState(() => _selectedPaymentMethod = method['id'] as String),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _selectedPaymentMethod == method['id']
                    ? KineticTheme.primary.withOpacity(0.1)
                    : KineticTheme.surfaceContainer,
                border: Border.all(
                  color: _selectedPaymentMethod == method['id']
                      ? KineticTheme.primary
                      : KineticTheme.outlineVariant,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    method['icon'] as IconData,
                    color: _selectedPaymentMethod == method['id']
                        ? KineticTheme.primary
                        : KineticTheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    method['label'] as String,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _selectedPaymentMethod == method['id']
                          ? KineticTheme.primary
                          : KineticTheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedPaymentMethod == method['id']
                            ? KineticTheme.primary
                            : KineticTheme.outlineVariant,
                        width: 2,
                      ),
                    ),
                    child: _selectedPaymentMethod == method['id']
                        ? Center(
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: KineticTheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Build Order Summary (Sticky)
  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: KineticTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ORDER SUMMARY',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: KineticTheme.onSurface,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 16),

          // Cart Items
          Column(
            children: [
              _buildOrderItem('Structured Wool Atelier Overcoat', '\$1,240.00'),
              const SizedBox(height: 12),
              _buildOrderItem('Kinetic Volt Technical Runner', '\$480.00'),
            ],
          ),
          const SizedBox(height: 16),

          // Divider
          Container(
            height: 1,
            color: KineticTheme.outlineVariant.withOpacity(0.3),
          ),
          const SizedBox(height: 16),

          // Totals
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: KineticTheme.onSurfaceVariant,
                ),
              ),
              Text(
                '\$1,720.00',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: KineticTheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shipping (Express)',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: KineticTheme.onSurfaceVariant,
                ),
              ),
              Text(
                '\$45.00',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: KineticTheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: KineticTheme.onSurface,
                  letterSpacing: 0.1,
                ),
              ),
              Text(
                '\$1,765.00',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: KineticTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Security Badge
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: KineticTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user,
                    size: 16, color: KineticTheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'SSL encrypted payment via Kinetic secure vault',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: KineticTheme.primary,
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

  /// Build Order Item
  Widget _buildOrderItem(String title, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: KineticTheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          price,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: KineticTheme.onSurface,
          ),
        ),
      ],
    );
  }

  /// Build Section Title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: KineticTheme.onSurface,
        letterSpacing: -0.3,
      ),
    );
  }

  /// Build Text Field
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: KineticTheme.onSurfaceVariant,
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: KineticTheme.onSurfaceVariant.withOpacity(0.5),
            ),
            filled: true,
            fillColor: KineticTheme.surfaceContainer,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: KineticTheme.outlineVariant,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: KineticTheme.outlineVariant,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: KineticTheme.primary,
                width: 2,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: KineticTheme.onSurface,
          ),
        ),
      ],
    );
  }
}
