import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

final class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({
    this.width = double.infinity,
    this.height = 16,
    super.key,
  });

  final double width;
  final double height;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

final class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.45, end: 1).animate(_controller),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: context.colors.skeleton,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
