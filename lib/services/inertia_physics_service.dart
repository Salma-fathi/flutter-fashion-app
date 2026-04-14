import 'package:flutter/material.dart';

/// Advanced Inertia Physics Service for Buttery Smooth 3D Rotation
/// 
/// This service handles velocity-based inertia effects with natural deceleration,
/// providing a premium, physically reactive feel to product interactions.
class InertiaPhysicsService {
  /// Friction coefficient (0.0 - 1.0) that determines deceleration rate
  /// Higher values = faster deceleration
  static const double frictionCoefficient = 0.95;

  /// Minimum velocity threshold below which inertia stops
  static const double velocityThreshold = 0.001;

  /// Maximum rotation velocity to prevent excessive spinning
  static const double maxVelocity = 0.15;

  /// Calculates the next velocity based on friction
  static double calculateNextVelocity(double currentVelocity) {
    return currentVelocity * frictionCoefficient;
  }

  /// Calculates rotation delta from velocity
  static double calculateRotationDelta(double velocity) {
    return velocity * 0.05; // Scale factor for rotation
  }

  /// Checks if velocity is significant enough to continue inertia
  static bool isVelocitySignificant(double velocity) {
    return velocity.abs() > velocityThreshold;
  }

  /// Clamps velocity to maximum allowed value
  static double clampVelocity(double velocity) {
    return velocity.clamp(-maxVelocity, maxVelocity);
  }

  /// Calculates the total rotation that will occur during inertia decay
  /// This is useful for predicting final rotation position
  static double calculateTotalInertiaRotation(double initialVelocity) {
    double totalRotation = 0;
    double velocity = initialVelocity;

    while (isVelocitySignificant(velocity)) {
      totalRotation += calculateRotationDelta(velocity);
      velocity = calculateNextVelocity(velocity);
    }

    return totalRotation;
  }

  /// Gets the appropriate curve for inertia deceleration
  /// Curves.outQuart provides smooth, elegant deceleration
  static Curve getInertiaDecelerationCurve() {
    return Curves.outQuart;
  }

  /// Calculates animation duration based on initial velocity
  /// Higher velocity = longer animation duration
  static Duration calculateAnimationDuration(double initialVelocity) {
    final normalizedVelocity = initialVelocity.abs() / maxVelocity;
    final baseDuration = 600; // milliseconds
    final durationMs = (baseDuration * normalizedVelocity).clamp(200, 1200).toInt();
    return Duration(milliseconds: durationMs);
  }
}

/// Inertia State Model for tracking rotation state
class InertiaState {
  final double rotationX;
  final double rotationY;
  final double velocityX;
  final double velocityY;
  final bool isDecelerating;

  InertiaState({
    required this.rotationX,
    required this.rotationY,
    required this.velocityX,
    required this.velocityY,
    required this.isDecelerating,
  });

  /// Create a copy with modified fields
  InertiaState copyWith({
    double? rotationX,
    double? rotationY,
    double? velocityX,
    double? velocityY,
    bool? isDecelerating,
  }) {
    return InertiaState(
      rotationX: rotationX ?? this.rotationX,
      rotationY: rotationY ?? this.rotationY,
      velocityX: velocityX ?? this.velocityX,
      velocityY: velocityY ?? this.velocityY,
      isDecelerating: isDecelerating ?? this.isDecelerating,
    );
  }

  @override
  String toString() {
    return 'InertiaState(rotX: $rotationX, rotY: $rotationY, velX: $velocityX, velY: $velocityY, decel: $isDecelerating)';
  }
}

/// Inertia Scroll Velocity Tracker
/// Tracks scroll velocity for inertia calculations
class ScrollVelocityTracker {
  final List<_VelocityPoint> _points = [];
  static const int _maxPoints = 10;
  static const Duration _velocityWindow = Duration(milliseconds: 100);

  /// Record a scroll position at current time
  void recordPosition(Offset position) {
    final now = DateTime.now();
    _points.add(_VelocityPoint(position, now));

    // Remove old points outside the velocity window
    _points.removeWhere(
      (point) => now.difference(point.timestamp).inMilliseconds > _velocityWindow.inMilliseconds,
    );

    // Keep only recent points
    if (_points.length > _maxPoints) {
      _points.removeAt(0);
    }
  }

  /// Calculate average velocity from recorded points
  Offset getVelocity() {
    if (_points.length < 2) {
      return Offset.zero;
    }

    final oldest = _points.first;
    final newest = _points.last;

    final timeDiff = newest.timestamp.difference(oldest.timestamp).inMilliseconds / 1000;
    if (timeDiff == 0) {
      return Offset.zero;
    }

    final dx = (newest.position.dx - oldest.position.dx) / timeDiff;
    final dy = (newest.position.dy - oldest.position.dy) / timeDiff;

    return Offset(dx, dy);
  }

  /// Clear all recorded points
  void clear() {
    _points.clear();
  }

  /// Get the number of recorded points
  int get pointCount => _points.length;
}

/// Internal class for storing velocity points
class _VelocityPoint {
  final Offset position;
  final DateTime timestamp;

  _VelocityPoint(this.position, this.timestamp);
}

/// Inertia Animation Controller
/// Manages the animation of inertia effects
class InertiaAnimationController {
  late AnimationController _controller;
  late Animation<double> _animation;
  final TickerProvider vsync;

  InertiaAnimationController({required this.vsync});

  /// Initialize the animation controller
  void initialize() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: vsync,
    );
  }

  /// Start inertia animation with given velocity
  void startInertiaAnimation({
    required double initialVelocity,
    required Function(double) onUpdate,
    required VoidCallback onComplete,
  }) {
    // Calculate animation duration based on velocity
    final duration = InertiaPhysicsService.calculateAnimationDuration(initialVelocity);
    _controller.duration = duration;

    // Create animation with outQuart curve
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: InertiaPhysicsService.getInertiaDecelerationCurve(),
      ),
    );

    // Listen to animation updates
    _animation.addListener(() {
      final progress = _animation.value;
      final currentVelocity = initialVelocity * (1 - progress);
      onUpdate(currentVelocity);
    });

    // Listen to animation completion
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        onComplete();
      }
    });

    // Start the animation
    _controller.forward(from: 0);
  }

  /// Stop the current animation
  void stop() {
    _controller.stop();
  }

  /// Dispose resources
  void dispose() {
    _controller.dispose();
  }

  /// Check if animation is running
  bool get isAnimating => _controller.isAnimating;
}
