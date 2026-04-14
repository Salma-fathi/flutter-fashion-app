import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Interactive 3D Product Visualization with Rotation and Parallax Effects
class Interactive3DProduct extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;
  final VoidCallback? onTap;
  final bool enableParallax;
  final bool enableRotation;

  const Interactive3DProduct({
    Key? key,
    required this.imageUrl,
    this.width = 200,
    this.height = 200,
    this.onTap,
    this.enableParallax = true,
    this.enableRotation = true,
  }) : super(key: key);

  @override
  State<Interactive3DProduct> createState() => _Interactive3DProductState();
}

class _Interactive3DProductState extends State<Interactive3DProduct>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  Offset _mousePosition = Offset.zero;
  double _rotationX = 0;
  double _rotationY = 0;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    // Auto-rotate if enabled
    if (widget.enableRotation) {
      _rotationController.repeat();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  /// Handle mouse/touch movement for 3D rotation
  void _onPointerMove(PointerMoveEvent event) {
    if (!widget.enableRotation) return;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(event.position);
    final centerX = box.size.width / 2;
    final centerY = box.size.height / 2;

    setState(() {
      _mousePosition = localPosition;
      _rotationY = (localPosition.dx - centerX) / centerX * 0.5;
      _rotationX = (localPosition.dy - centerY) / centerY * 0.5;
      _scale = 1.05;
    });
  }

  /// Handle pointer exit
  void _onPointerExit(PointerExitEvent event) {
    setState(() {
      _rotationX = 0;
      _rotationY = 0;
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: _onPointerMove,
      onPointerExit: _onPointerExit,
      child: GestureDetector(
        onTap: widget.onTap,
        child: MouseRegion(
          onEnter: (_) {
            if (widget.enableRotation) {
              _rotationController.forward();
            }
          },
          onExit: (_) {
            if (widget.enableRotation) {
              _rotationController.stop();
            }
          },
          child: AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(_rotationX)
                  ..rotateY(_rotationY + _rotationController.value * 6.28)
                  ..scale(_scale),
                child: Container(
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x1A000000),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        /// Product Image
                        CachedNetworkImage(
                          imageUrl: widget.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.image_not_supported),
                            );
                          },
                        ),

                        /// Parallax Overlay (if enabled)
                        if (widget.enableParallax)
                          _buildParallaxOverlay(),
                      ],
                    ),
                  );
                );
              );
            },
          );
        ),
      );
    );
  }

  /// Build parallax overlay effect
  Widget _buildParallaxOverlay() {
    return Positioned(
      left: _mousePosition.dx * 0.1,
      top: _mousePosition.dy * 0.1,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.transparent,
            ],
          ),
        ),
      );
    );
  }
}

/// Parallax Scroll Effect Widget
class ParallaxProductImage extends StatefulWidget {
  final String imageUrl;
  final ScrollController scrollController;
  final double height;

  const ParallaxProductImage({
    Key? key,
    required this.imageUrl,
    required this.scrollController,
    this.height = 300,
  }) : super(key: key);

  @override
  State<ParallaxProductImage> createState() => _ParallaxProductImageState();
}

class _ParallaxProductImageState extends State<ParallaxProductImage> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final offset = widget.scrollController.hasClients
        ? widget.scrollController.offset
        : 0.0;

    return Container(
      height: widget.height,
      overflow: Overflow.hidden,
      child: Stack(
        children: [
          /// Parallax Background
          Transform.translate(
            offset: Offset(0, offset * 0.5),
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              fit: BoxFit.cover,
              height: widget.height + 100,
              placeholder: (context, url) {
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),

          /// Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
              ),
            ),
          ),
        ],
      );
    );
  }
}

/// Tilt Effect Widget for Product Cards
class TiltProductCard extends StatefulWidget {
  final Widget child;
  final double maxTilt;
  final Duration duration;

  const TiltProductCard({
    Key? key,
    required this.child,
    this.maxTilt = 0.05,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<TiltProductCard> createState() => _TiltProductCardState();
}

class _TiltProductCardState extends State<TiltProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _tiltX = 0;
  double _tiltY = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPointerMove(PointerMoveEvent event) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(event.position);
    final centerX = box.size.width / 2;
    final centerY = box.size.height / 2;

    setState(() {
      _tiltY = (localPosition.dx - centerX) / centerX * widget.maxTilt;
      _tiltX = (localPosition.dy - centerY) / centerY * widget.maxTilt;
    });
  }

  void _onPointerExit(PointerExitEvent event) {
    setState(() {
      _tiltX = 0;
      _tiltY = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: _onPointerMove,
      onPointerExit: _onPointerExit,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(_tiltX)
          ..rotateY(_tiltY),
        child: widget.child,
      );
    );
  }
}
