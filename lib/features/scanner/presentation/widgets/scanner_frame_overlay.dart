import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Corner-bracket viewfinder with an animated scanning line, shown while
/// the camera frame is centered on food.
class ScannerFrameOverlay extends StatefulWidget {
  const ScannerFrameOverlay({super.key, this.animate = true});

  final bool animate;

  @override
  State<ScannerFrameOverlay> createState() => _ScannerFrameOverlayState();
}

class _ScannerFrameOverlayState extends State<ScannerFrameOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animate) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant ScannerFrameOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _controller.repeat(reverse: true);
    } else if (!widget.animate && oldWidget.animate) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFF006D37);
    const cornerSize = 48.0;
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          _corner(alignment: Alignment.topLeft, borderColor: borderColor, size: cornerSize),
          _corner(alignment: Alignment.topRight, borderColor: borderColor, size: cornerSize),
          _corner(alignment: Alignment.bottomLeft, borderColor: borderColor, size: cornerSize),
          _corner(alignment: Alignment.bottomRight, borderColor: borderColor, size: cornerSize),
          if (widget.animate)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => Align(
                alignment: Alignment(0, -1 + 2 * _controller.value),
                child: Container(
                  height: 2.h,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6BFE9C),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6BFE9C).withValues(alpha: 0.8),
                        blurRadius: 15.r,
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

  Widget _corner({
    required Alignment alignment,
    required Color borderColor,
    required double size,
  }) {
    final isTop = alignment.y < 0;
    final isLeft = alignment.x < 0;
    return Align(
      alignment: alignment,
      child: Container(
        width: size.r,
        height: size.r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: isTop && isLeft ? Radius.circular(24.r) : Radius.zero,
            topRight: isTop && !isLeft ? Radius.circular(24.r) : Radius.zero,
            bottomLeft: !isTop && isLeft ? Radius.circular(24.r) : Radius.zero,
            bottomRight: !isTop && !isLeft ? Radius.circular(24.r) : Radius.zero,
          ),
          border: Border(
            top: isTop ? BorderSide(color: borderColor, width: 4.w) : BorderSide.none,
            bottom: !isTop ? BorderSide(color: borderColor, width: 4.w) : BorderSide.none,
            left: isLeft ? BorderSide(color: borderColor, width: 4.w) : BorderSide.none,
            right: !isLeft ? BorderSide(color: borderColor, width: 4.w) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
