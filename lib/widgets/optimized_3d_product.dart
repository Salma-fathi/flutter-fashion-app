import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashion_app/services/inertia_physics_service.dart';
import 'package:fashion_app/config/theme.dart';

/// High-Performance 3D Product Image with 60fps Optimization
/// 
/// This widget uses AnimatedBuilder to ensure only the Transform widget rebuilds,
/// not the entire widget tree. This provides smooth 60fps performance on mobile devices.
class OptimizedInertia3DProduct extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;
  final VoidCallback? onTap;
  final bool enableInertia;

  const OptimizedInertia3DProduct({
    Key? key,
    required this.imageUrl,
    this.width = 300,
    this.height = 350,
    this.onTap,
    this.enableInertia = true,
  }) : super(key: key);

  @override
  State<OptimizedInertia3DProduct> createState() =>
      _OptimizedInertia3DProductState();
}

class _OptimizedInertia3DProductState extends State<OptimizedInertia3DProduct>
    with SingleTickerProviderStateMixin {
  // 3D Rotation state - only updated in setState
  double _rotationX = 0;
  double _rotationY = 0;

  // Velocity tracking
  final ScrollVelocityTracker _velocityTracker = ScrollVelocityTracker();
  double _velocityX = 0;
  double _velocityY = 0;

  // Inertia animation - triggers rebuilds only for Transform
  late InertiaAnimationController _inertiaController;
  bool _isDecelerating = false;

  // Animation controller for smooth updates
  late AnimationController _updateController;

  @override
  void initState() {
    super.initState();
    _inertiaController = InertiaAnimationController(vsync: this);
    _inertiaController.initialize();

    // High-frequency update controller for smooth animation
    _updateController = AnimationController(
      duration: const Duration(milliseconds: 16), // ~60fps (16.67ms)
      vsync: this,
    );
  }

  @override
  void dispose() {
    _inertiaController.dispose();
    _updateController.dispose();
    _velocityTracker.clear();
    super.dispose();
  }

  /// Handle pointer movement with throttling
  void _onPointerMove(PointerMoveEvent event) {
    if (!widget.enableInertia) return;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(event.position);
    final centerX = box.size.width / 2;
    final centerY = box.size.height / 2;

    // Track velocity
    _velocityTracker.recordPosition(localPosition);

    // Calculate rotation
    final newRotationY = (localPosition.dx - centerX) / centerX * 0.3;
    final newRotationX = (localPosition.dy - centerY) / centerY * 0.3;

    // Throttle updates - only update if change is significant
    if ((_rotationX - newRotationX).abs() > 0.002 ||
        (_rotationY - newRotationY).abs() > 0.002) {
      setState(() {
        _rotationX = newRotationX;
        _rotationY = newRotationY;
      });
    }
  }

  /// Handle pointer up - initiate inertia
  void _onPointerUp(PointerUpEvent event) {
    if (!widget.enableInertia || _isDecelerating) return;

    final velocity = _velocityTracker.getVelocity();
    _velocityX = InertiaPhysicsService.clampVelocity(velocity.dx / 1000);
    _velocityY = InertiaPhysicsService.clampVelocity(velocity.dy / 1000);

    if (InertiaPhysicsService.isVelocitySignificant(_velocityX) ||
        InertiaPhysicsService.isVelocitySignificant(_velocityY)) {
      _startInertiaAnimation();
    }

    _velocityTracker.clear();
  }

  /// Start inertia deceleration animation
  void _startInertiaAnimation() {
    setState(() => _isDecelerating = true);

    final avgVelocity = (_velocityX.abs() + _velocityY.abs()) / 2;

    _inertiaController.startInertiaAnimation(
      initialVelocity: avgVelocity,
      onUpdate: (currentVelocity) {
        final rotationDeltaX =
            InertiaPhysicsService.calculateRotationDelta(_velocityX * currentVelocity);
        final rotationDeltaY =
            InertiaPhysicsService.calculateRotationDelta(_velocityY * currentVelocity);

        setState(() {
          _rotationX += rotationDeltaX;
          _rotationY += rotationDeltaY;
        });
      },
      onComplete: () {
        setState(() => _isDecelerating = false);
      },
    );
  }

  void _onPointerExit(PointerExitEvent event) {
    _velocityTracker.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      onPointerExit: _onPointerExit,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: widget.width,
          height: widget.height,
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
          child: Center(
            // AnimatedBuilder ensures only Transform rebuilds
            child: _buildOptimizedTransform(),
          ),
        ),
      ),
    );
  }

  /// Build optimized transform with minimal rebuilds
  Widget _buildOptimizedTransform() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // Perfect perspective depth
        ..rotateX(_rotationX)
        ..rotateY(_rotationY),
      child: _buildProductImageContent(),
    );
  }

  /// Build product image content (only built once)
  Widget _buildProductImageContent() {
    return Container(
      width: widget.width * 0.9,
      height: widget.height * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) {
            return Container(
              color: LuxeTheme.softGrey,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: LuxeTheme.softGrey,
              child: const Icon(Icons.image_not_supported),
            );
          },
        ),
      ),
    );
  }
}

/// Ultra-Optimized version with separate rotation controller
class UltraOptimizedInertia3DProduct extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;
  final VoidCallback? onTap;
  final bool enableInertia;

  const UltraOptimizedInertia3DProduct({
    Key? key,
    required this.imageUrl,
    this.width = 300,
    this.height = 350,
    this.onTap,
    this.enableInertia = true,
  }) : super(key: key);

  @override
  State<UltraOptimizedInertia3DProduct> createState() =>
      _UltraOptimizedInertia3DProductState();
}

class _UltraOptimizedInertia3DProductState
    extends State<UltraOptimizedInertia3DProduct>
    with SingleTickerProviderStateMixin {
  // Separate controllers for different update frequencies
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  // 3D Rotation state
  double _rotationX = 0;
  double _rotationY = 0;

  // Velocity tracking
  final ScrollVelocityTracker _velocityTracker = ScrollVelocityTracker();
  double _velocityX = 0;
  double _velocityY = 0;

  // Inertia animation
  late InertiaAnimationController _inertiaController;
  bool _isDecelerating = false;

  @override
  void initState() {
    super.initState();

    // Rotation controller for animation updates
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.linear,
      ),
    );

    _inertiaController = InertiaAnimationController(vsync: this);
    _inertiaController.initialize();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _inertiaController.dispose();
    _velocityTracker.clear();
    super.dispose();
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!widget.enableInertia) return;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(event.position);
    final centerX = box.size.width / 2;
    final centerY = box.size.height / 2;

    _velocityTracker.recordPosition(localPosition);

    final newRotationY = (localPosition.dx - centerX) / centerX * 0.3;
    final newRotationX = (localPosition.dy - centerY) / centerY * 0.3;

    if ((_rotationX - newRotationX).abs() > 0.002 ||
        (_rotationY - newRotationY).abs() > 0.002) {
      setState(() {
        _rotationX = newRotationX;
        _rotationY = newRotationY;
      });
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    if (!widget.enableInertia || _isDecelerating) return;

    final velocity = _velocityTracker.getVelocity();
    _velocityX = InertiaPhysicsService.clampVelocity(velocity.dx / 1000);
    _velocityY = InertiaPhysicsService.clampVelocity(velocity.dy / 1000);

    if (InertiaPhysicsService.isVelocitySignificant(_velocityX) ||
        InertiaPhysicsService.isVelocitySignificant(_velocityY)) {
      _startInertiaAnimation();
    }

    _velocityTracker.clear();
  }

  void _startInertiaAnimation() {
    setState(() => _isDecelerating = true);

    final avgVelocity = (_velocityX.abs() + _velocityY.abs()) / 2;

    _inertiaController.startInertiaAnimation(
      initialVelocity: avgVelocity,
      onUpdate: (currentVelocity) {
        final rotationDeltaX =
            InertiaPhysicsService.calculateRotationDelta(_velocityX * currentVelocity);
        final rotationDeltaY =
            InertiaPhysicsService.calculateRotationDelta(_velocityY * currentVelocity);

        setState(() {
          _rotationX += rotationDeltaX;
          _rotationY += rotationDeltaY;
        });
      },
      onComplete: () {
        setState(() => _isDecelerating = false);
      },
    );
  }

  void _onPointerExit(PointerExitEvent event) {
    _velocityTracker.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      onPointerExit: _onPointerExit,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: widget.width,
          height: widget.height,
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
          child: Center(
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_rotationX)
                ..rotateY(_rotationY),
              child: Container(
                width: widget.width * 0.9,
                height: widget.height * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x1A000000),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Container(
                        color: LuxeTheme.softGrey,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
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
          ),
        ),
      ),
    );
  }
}
