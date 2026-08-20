import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// The core glassmorphism building block — a frosted, translucent
/// panel with a soft border, meant to be used EVERYWHERE a Card
/// would previously have been used (dashboard tiles, chat bubbles,
/// the bottom nav bar, form containers, etc).
///
/// How the "glass" effect actually works, mechanically:
///   1. BackdropFilter blurs whatever is drawn BEHIND this widget
///      (the gradient background, or content scrolling underneath it)
///   2. A semi-transparent white fill sits on top of that blur
///   3. A subtle 1px light border traces the edge, which is what
///      sells the "glass pane catching light" illusion
///
/// Usage:
///   GlassCard(
///     child: Text('Hello'),
///   )
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius,
    this.blurSigma,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? borderRadius;
  final double? blurSigma;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppTheme.glassRadius;

    // ClipRRect is REQUIRED here — without it, the blur applied by
    // BackdropFilter would blur a rectangular area, ignoring the
    // rounded corners entirely, and the effect would look broken
    // at the edges.
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        // ImageFilter.blur is what actually samples and blurs
        // whatever is rendered behind this widget in the tree.
        filter: ImageFilter.blur(
          sigmaX: blurSigma ?? AppTheme.glassBlur,
          sigmaY: blurSigma ?? AppTheme.glassBlur,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: AppTheme.glassFill,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: AppTheme.glassBorder,
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}