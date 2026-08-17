import 'dart:math' as math;

import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/app/assets_path.dart';
import 'package:ebazarx/common/utils/user_based_login.dart';
import 'package:ebazarx/core/services/auth_storage.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/auth/presentation/providers/auth_provider.dart';
import 'package:ebazarx/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum _SplashDestination { userBased, widgetTree }

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Logo: 0 -> 0.65 of the timeline (scale + fade in)
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;

  // Tagline: starts at 0.45, finishes at 0.85 (fade + slight upward slide)
  late final Animation<double> _taglineFade;
  late final Animation<Offset> _taglineSlide;

  // Loader: fades in last, then pulses continuously
  late final Animation<double> _loaderFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _logoScale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
      ),
    );

    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.85, curve: Curves.easeOut),
      ),
    );

    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _loaderFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    _initialData();
  }

  /// Runs the entrance animation and the auth/profile check in parallel,
  /// but only navigates once BOTH are finished — so navigation never
  /// happens mid-animation, even if the auth check resolves faster.
  Future<void> _initialData() async {
    final results = await Future.wait<dynamic>([
      _controller.forward(),
      _resolveDestination(),
    ]);

    if (!mounted) return;

    final destination = results[1] as _SplashDestination;
    switch (destination) {
      case _SplashDestination.userBased:
        await ref.read(registerFcmTokenUseCaseProvider).call();
        await userBasedNavigation(ref, context);
        break;
      case _SplashDestination.widgetTree:
        context.pushReplacementNamed(AppRoutesName.widgetTree);
        break;
    }
  }

  /// Decides where the user should end up, WITHOUT navigating yet.
  Future<_SplashDestination> _resolveDestination() async {
    final token = await AuthStorage.instance.getAccessToken();
    if (token != null) {
      await ref.read(profileNotifierProvider.notifier).fetchProfile();
      return _SplashDestination.userBased;
    }
    return _SplashDestination.widgetTree;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final logoWidth = context.responsive<double>(
      mobile: context.screenWidth * 0.55,
      tablet: context.screenWidth * 0.35,
      desktop: context.screenWidth * 0.22,
    );

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Soft abstract gradient background
          _AnimatedBackground(controller: _controller),

          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo: scale + fade
                  ScaleTransition(
                    scale: _logoScale,
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: Image.asset(
                        AssetsPath.logoHorizontal,
                        width: logoWidth,
                      ),
                    ),
                  ),

                  Transform.translate(
                    offset: const Offset(0, -45),
                    child: SlideTransition(
                      position: _taglineSlide,
                      child: FadeTransition(
                        opacity: _taglineFade,
                        child: Text(
                          'Everything you need, delivered.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color:
                            colorScheme.onSurface.withValues(alpha: 0.65),
                            letterSpacing: 0.3,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: context.responsive<double>(
                      mobile: 10,
                      tablet: 28,
                      desktop: 36,
                    ),
                  ),

                  // Loader: fades in, then pulses continuously
                  FadeTransition(
                    opacity: _loaderFade,
                    child: const _PulsingLoader(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Subtle animated abstract gradient shapes in the background.
/// Reuses the same controller (no extra AnimationController needed) —
/// shapes softly drift/scale in sync with the entrance animation, then hold.
class _AnimatedBackground extends StatelessWidget {
  const _AnimatedBackground({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = Curves.easeOut.transform(controller.value);
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface,
                colorScheme.primary.withValues(alpha: 0.05 + (0.03 * t)),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -80,
                right: -60,
                child: Transform.scale(
                  scale: 0.9 + (0.1 * t),
                  child: _blob(
                    color: colorScheme.primary.withValues(alpha: 0.10),
                    size: 260,
                  ),
                ),
              ),
              Positioned(
                bottom: -100,
                left: -70,
                child: Transform.scale(
                  scale: 0.85 + (0.15 * t),
                  child: _blob(
                    color: colorScheme.secondary.withValues(alpha: 0.08),
                    size: 300,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _blob({required Color color, required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

/// Small, continuously pulsing loading indicator (independent looping
/// animation, separate from the one-shot entrance controller).
class _PulsingLoader extends StatefulWidget {
  const _PulsingLoader();

  @override
  State<_PulsingLoader> createState() => _PulsingLoaderState();
}

class _PulsingLoaderState extends State<_PulsingLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, _) {
        final value = _pulseController.value;
        final scale = 0.85 + (0.15 * math.sin(value * math.pi));
        return Transform.scale(
          scale: scale,
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
        );
      },
    );
  }
}