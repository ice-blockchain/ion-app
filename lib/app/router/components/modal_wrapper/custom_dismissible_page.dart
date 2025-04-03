// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomDismissiblePage extends StatefulWidget {
  const CustomDismissiblePage({
    required this.child,
    required this.onDismissed,
    this.isZoomed = false,
    this.dismissThreshold = 0.2,
    this.backgroundColor = Colors.black,
    this.direction = CustomDismissDirection.vertical,
    this.minScale = 0.85,
    this.maxRadius = 30.0,
    this.minRadius = 7.0,
    super.key,
  });

  final VoidCallback onDismissed;
  final bool isZoomed;
  final Widget child;
  final double dismissThreshold;
  final Color backgroundColor;
  final CustomDismissDirection direction;
  final double minScale;
  final double maxRadius;
  final double minRadius;

  @override
  State<CustomDismissiblePage> createState() => _CustomDismissiblePageState();
}

class _CustomDismissiblePageState extends State<CustomDismissiblePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  double _dragOffset = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animationController.addListener(() {
      setState(() {
        _dragOffset = _animationController.value * _dragOffset;
      });

      if (_animationController.isCompleted) {
        _dragOffset = 0;
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double get _radius {
    if (_dragOffset == 0) return widget.minRadius;

    final dragProgress = _dragOffset.abs() / (MediaQuery.of(context).size.height / 2);
    final clampedProgress = dragProgress.clamp(0.0, 1.0);

    return widget.minRadius + (widget.maxRadius - widget.minRadius) * clampedProgress;
  }

  double get _scale {
    if (_dragOffset == 0) return 1;

    final dragProgress = _dragOffset.abs() / (MediaQuery.of(context).size.height / 2);
    final clampedProgress = dragProgress.clamp(0.0, 1.0);

    return 1.0 - (1.0 - widget.minScale) * clampedProgress;
  }

  double get _opacity {
    if (_dragOffset == 0) return 1;

    final dragProgress = _dragOffset.abs() / (MediaQuery.of(context).size.height / 2);
    final clampedProgress = dragProgress.clamp(0.0, 1.0);

    return 1.0 - 0.8 * clampedProgress;
  }

  bool _shouldDismiss() {
    final threshold = MediaQuery.of(context).size.height * widget.dismissThreshold;
    return _dragOffset.abs() > threshold;
  }

  void _handleDragStart(DragStartDetails details) {
    if (widget.isZoomed) return;

    setState(() {
      _dragOffset = 0;
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (widget.isZoomed) return;

    setState(() {
      if (widget.direction == CustomDismissDirection.vertical) {
        _dragOffset += details.delta.dy;
      } else if (widget.direction == CustomDismissDirection.horizontal) {
        _dragOffset += details.delta.dx;
      }
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (widget.isZoomed) return;

    if (_shouldDismiss()) {
      widget.onDismissed();
    } else {
      _animationController
        ..reset()
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        VerticalDragGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
          VerticalDragGestureRecognizer.new,
          (VerticalDragGestureRecognizer instance) {
            instance
              ..onStart = widget.isZoomed ? null : _handleDragStart
              ..onUpdate = widget.isZoomed ? null : _handleDragUpdate
              ..onEnd = widget.isZoomed ? null : _handleDragEnd;
          },
        ),
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        color: widget.backgroundColor.withValues(alpha: _opacity),
        child: Transform.translate(
          offset: Offset(
            widget.direction == CustomDismissDirection.horizontal ? _dragOffset : 0,
            widget.direction == CustomDismissDirection.vertical ? _dragOffset : 0,
          ),
          child: Transform.scale(
            scale: _scale,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_radius),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

enum CustomDismissDirection {
  vertical,
  horizontal,
  none,
}
