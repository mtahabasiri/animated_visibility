library animated_visibility;

import 'package:flutter/material.dart';

enum FadeMode {
  vertical,
  horizontal,
  both,
}

class AnimatedVisibility extends StatefulWidget {
  final bool isVisible;
  final Duration duration;
  final Widget child;
  final Curve curve;
  final FadeMode fadeMode;

  const AnimatedVisibility({
    Key? key,
    required this.isVisible,
    required this.duration,
    required this.child,
    this.fadeMode = FadeMode.both,
    this.curve = Curves.easeIn,
  }) : super(key: key);

  @override
  _AnimatedVisibilityState createState() => _AnimatedVisibilityState();
}

class _AnimatedVisibilityState extends State<AnimatedVisibility>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sizeController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _runSizeCheck();
  }

  void _setupAnimation() {
    _sizeController =
        AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(
      parent: _sizeController,
      curve: widget.curve,
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedVisibility oldWidget) {
    _runSizeCheck();
    super.didUpdateWidget(oldWidget);
  }

  void _runSizeCheck() {
    if (widget.isVisible) {
      _sizeController.forward();
    } else {
      _sizeController.reverse();
    }
  }

  @override
  void dispose() {
    _sizeController.dispose();
    super.dispose();
  }

  bool get _isVertical =>
      widget.fadeMode == FadeMode.vertical || widget.fadeMode == FadeMode.both;
  bool get _isHorizontal =>
      widget.fadeMode == FadeMode.horizontal ||
      widget.fadeMode == FadeMode.both;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) => Align(
        heightFactor: _isVertical ? null : _animation.value,
        widthFactor: _isHorizontal ? null : _animation.value,
        child: Opacity(opacity: _animation.value, child: child),
      ),
    );
  }
}
