// lib/widgets/app_top_bar.dart
import 'package:flutter/material.dart';
import 'package:ebazarx/common/utils/styles.dart';
import 'package:ebazarx/core/utils/responsive.dart';

/// A clean, solid-first app bar. Two behaviors:
///
/// 1. Static mode (default) — a plain solid bar with a soft elevation
///    shadow and bottom divider. Use this everywhere except screens that
///    open on a full-bleed hero image.
///
/// 2. Scroll-reactive mode — pass a [scrollController] and it starts
///    fully transparent (so a hero image shows edge-to-edge behind it),
///    then crossfades to the solid bar as soon as the user scrolls past
///    [scrollThreshold]. Icon buttons stay legible the whole time because
///    they carry their own solid circular backing, not glass.
class AppTopBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double toolbarHeight;
  final bool centerTitle;
  final ScrollController? scrollController;
  final double scrollThreshold;

  const AppTopBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.bottom,
    this.toolbarHeight = kToolbarHeight,
    this.centerTitle = true,
    this.scrollController,
    this.scrollThreshold = 80,
  });

  @override
  State<AppTopBar> createState() => _AppTopBarState();

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0));
}

class _AppTopBarState extends State<AppTopBar> {
  double _progress = 0; // 0 = transparent, 1 = fully solid

  bool get _isReactive => widget.scrollController != null;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final offset = widget.scrollController!.offset.clamp(0, widget.scrollThreshold);
    final next = offset / widget.scrollThreshold;
    if (next != _progress) setState(() => _progress = next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final canPop = Navigator.of(context).canPop();

    final progress = _isReactive ? _progress : 1.0;

    // ── Responsive spacers and padding ──
    final double spacer = context.isMobile ? 4.0 : 8.0;
    final double horizontalPadding = context.isMobile ? 8.0 : 16.0;

    Widget? leadingWidget = widget.leading;
    if (leadingWidget == null && widget.automaticallyImplyLeading && canPop) {
      leadingWidget = _TopBarIconButton(
        icon: Icons.arrow_back_ios_new_rounded,
        onTap: () => Navigator.of(context).maybePop(),
        showBacking: progress < 1,
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor.withOpacity(progress),
        boxShadow: progress > 0.6
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ]
            : null,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withOpacity(progress),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child:
            SizedBox(
              height: widget.toolbarHeight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Row(
                  children: [
                    if (leadingWidget != null) ...[
                      leadingWidget,
                      SizedBox(width: spacer),
                    ],
                    Expanded(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 150),
                        opacity: _isReactive ? progress : 1,
                        child: widget.centerTitle
                            ? Center(child: _buildTitle(context, colors))
                            : Align(
                          alignment: Alignment.centerLeft,
                          child: _buildTitle(context, colors),
                        ),
                      ),
                    ),
                    if (widget.actions != null) ...[
                      SizedBox(width: spacer),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.actions!.map((action) {
                          return Padding(
                            padding: EdgeInsets.only(left: spacer / 2),
                            child: action,
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // if (widget.bottom != null) widget.bottom!,
      ),
    );
  }

  Widget _buildTitle(BuildContext context, ColorScheme colors) {
    if (widget.titleWidget != null) return widget.titleWidget!;
    if (widget.title != null) {
      return Text(
        widget.title!,
        style: context.bold.copyWith(
          fontSize: context.fontSizeLarge,
          color: colors.onSurface,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    return const SizedBox.shrink();
  }
}

/// Circular icon button for app bar actions. Carries a solid theme-color
/// backing only when [showBacking] is true (i.e. floating over content
/// rather than sitting on an already-solid bar) — so it's always legible
/// without depending on blur or transparency tricks.
class _TopBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool showBacking;
  final double size;

  const _TopBarIconButton({
    required this.icon,
    required this.onTap,
    this.showBacking = true,
    this.size = 38,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: showBacking
            ? (isDark ? Colors.black.withOpacity(0.45) : Colors.white.withOpacity(0.9))
            : Colors.transparent,
        boxShadow: showBacking
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Icon(
            icon,
            size: size * 0.45,
            color: showBacking
                ? (isDark ? Colors.white : Colors.black87)
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

/// Public export so screens can reuse the same icon button style for
/// custom actions (favorite, share, filter) that need the same
/// "solid backing over hero content" behavior.
class TopBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool showBacking;
  final double size;

  const TopBarIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.showBacking = true,
    this.size = 38,
  });

  @override
  Widget build(BuildContext context) {
    return _TopBarIconButton(
      icon: icon,
      onTap: onTap,
      showBacking: showBacking,
      size: size,
    );
  }
}