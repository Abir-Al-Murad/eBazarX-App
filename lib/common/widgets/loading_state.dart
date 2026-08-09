import 'package:flutter/material.dart';

import '../../app/assets_path.dart';

class LoadingState {
  LoadingState._(); // Prevent instantiation

  static OverlayEntry? _overlayEntry;

  /// Shows a loading overlay with an optional [message].
  /// Calling [show] while already visible updates the message in place.
  static void show(BuildContext context, {String? message}) {
    hide(); // Dismiss any existing overlay before showing a new one

    _overlayEntry = OverlayEntry(
      builder: (_) => _LoadingOverlay(message: message),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  /// Hides the loading overlay if it is currently visible.
  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

// ---------------------------------------------------------------------------
// Private widget — only used by LoadingState
// ---------------------------------------------------------------------------

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Scrim
        const ModalBarrier(
          dismissible: false,
          color: Colors.black38,
        ),

        // Card
        Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppLoadingAnimation(size: 80),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      message!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Slide loading animation using app logo
// ---------------------------------------------------------------------------

class AppLoadingAnimation extends StatefulWidget {
  final double size;
  const AppLoadingAnimation({super.key, this.size = 120});

  @override
  State<AppLoadingAnimation> createState() => _AppLoadingAnimationState();
}

class _AppLoadingAnimationState extends State<AppLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slide;
  late Animation<double> _tilt;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _slide = Tween<double>(begin: -12, end: 12).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _tilt = Tween<double>(begin: -0.03, end: 0.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slide.value, 0),
          child: Transform.rotate(
            angle: _tilt.value,
            child: child,
          ),
        );
      },
      child: Image.asset(
        AssetsPath.logoRaw,
        width: widget.size,
        height: widget.size,
      ),
    );
  }
}