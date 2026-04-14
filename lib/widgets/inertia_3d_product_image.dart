import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashion_app/services/inertia_physics_service.dart';
import 'package:fashion_app/config/theme.dart';

/// Optimized 3D Product Image with Buttery Smooth Inertia Effects
/// 
/// This widget provides:
/// - Velocity-based inertia rotation
/// - Smooth deceleration using Curves.outQuart
/// - Optimized 60fps performance with minimal rebuilds
/// - Perfect perspective at 0.001 Matrix4 depth
class Inertia3DProductImage extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;
  final VoidCallback? onTap;
  final bool enableInertia;

  const Inertia3DProductImage({
    Key? key,
    required this.imageUrl,
    this.width = 300,
    this.height = 350,
    this.onTap,
    this.enableInertia = true,
  }) : super(key: key);

  @override
  State<Inertia3DProductImage> createState() => _Inertia3DProductImageState();
}

class _Inertia3DProductImageState extends State<Inertia3DProductImage>
    with SingleTickerProviderStateMixin {
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

  // Optimization: Only rebuild Transform widget
  late AnimationController _rotationAnimationController;

  @override
  void initState() {
    super.initState();
    _inertiaController = InertiaAnimationController(vsync: this);
    _inertiaController.initialize();

    _rotationAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16), // ~60fps
    );
  }

  @override
  void dispose() {
    _inertiaController.dispose();
    _rotationAnimationController.dispose();
    _velocityTracker.clear();
    super.dispose();
  }

  /// Handle pointer movement for 3D rotation
  void _onPointerMove(PointerMoveEvent event) {
    if (!widget.enableInertia) return;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(event.position);
    final centerX = box.size.width / 2;
    final centerY = box.size.height / 2;

    // Track velocity
    _velocityTracker.recordPosition(localPosition);

    // Calculate rotation based on position
    final newRotationY = (localPosition.dx - centerX) / centerX * 0.3;
    final newRotationX = (localPosition.dy - centerY) / centerY * 0.3;

    // Only update if values changed significantly (reduce rebuilds)
    if ((_rotationX - newRotationX).abs() > 0.001 ||
        (_rotationY - newRotationY).abs() > 0.001) {
      setState(() {
        _rotationX = newRotationX;
        _rotationY = newRotationY;
      });
    }
  }

  /// Handle pointer up - start inertia animation
  void _onPointerUp(PointerUpEvent event) {
    if (!widget.enableInertia || _isDecelerating) return;

    final velocity = _velocityTracker.getVelocity();
    _velocityX = InertiaPhysicsService.clampVelocity(velocity.dx / 1000);
    _velocityY = InertiaPhysicsService.clampVelocity(velocity.dy / 1000);

    // Only start inertia if velocity is significant
    if (InertiaPhysicsService.isVelocitySignificant(_velocityX) ||
        InertiaPhysicsService.isVelocitySignificant(_velocityY)) {
      _startInertiaAnimation();
    }

    _velocityTracker.clear();
  }

  /// Start the inertia deceleration animation
  void _startInertiaAnimation() {
    setState(() => _isDecelerating = true);

    // Use average velocity for animation
    final avgVelocity = (_velocityX.abs() + _velocityY.abs()) / 2;

    _inertiaController.startInertiaAnimation(
      initialVelocity: avgVelocity,
      onUpdate: (currentVelocity) {
        // Apply deceleration to rotation
        final rotationDeltaX = InertiaPhysicsService.calculateRotationDelta(_velocityX * currentVelocity);
        final rotationDeltaY = InertiaPhysicsService.calculateRotationDelta(_velocityY * currentVelocity);

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

  /// Handle pointer exit - stop tracking
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
            // Optimized: Only Transform rebuilds on rotation changes
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
                  child: CircularProgressIndicator(),
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
    );
  }
}

/// Simplified version for product cards
class Inertia3DProductCard extends StatefulWidget {
  final String imageUrl;
  final VoidCallback? onTap;
  final bool enableInertia;

  const Inertia3DProductCard({
    Key? key,
    required this.imageUrl,
    this.onTap,
    this.enableInertia = true,
  }) : super(key: key);

  @override
  State<Inertia3DProductCard> createState() => _Inertia3DProductCardState();
}

class _Inertia3DProductCardState extends State<Inertia3DProductCard>
    with SingleTickerProviderStateMixin {
  double _rotationX = 0;
  double _rotationY = 0;
  final ScrollVelocityTracker _velocityTracker = ScrollVelocityTracker();
  double _velocityX = 0;
  double _velocityY = 0;
  late InertiaAnimationController _inertiaController;
  bool _isDecelerating = false;

  @override
  void initState() {
    super.initState();
    _inertiaController = InertiaAnimationController(vsync: this);
    _inertiaController.initialize();
  }

  @override
  void dispose() {
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

    final newRotationY = (localPosition.dx - centerX) / centerX * 0.25;
    final newRotationX = (localPosition.dy - centerY) / centerY * 0.25;

    if ((_rotationX - newRotationX).abs() > 0.001 ||
        (_rotationY - newRotationY).abs() > 0.001) {
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
        final rotationDeltaX = InertiaPhysicsService.calculateRotationDelta(_velocityX * currentVelocity);
        final rotationDeltaY = InertiaPhysicsService.calculateRotationDelta(_velocityY * currentVelocity);

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
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(_rotationX)
            ..rotateY(_rotationY),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x1A000000),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Container(
                    color: LuxeTheme.softGrey,
                    child: const Center(
                      child: CircularProgressIndicator(),
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
    );
  }
}
