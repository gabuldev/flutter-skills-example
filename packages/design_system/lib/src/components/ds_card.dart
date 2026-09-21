import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_radius.dart';
import '../tokens/ds_spacing.dart';

/// A tappable surface.
///
/// When [onTap] is null this renders as a plain container - it does not
/// pretend to be interactive, which matters for screen readers as much as for
/// the pointer.
class DSCard extends StatelessWidget {
  const DSCard({
    required this.child,
    this.onTap,
    this.semanticLabel,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.all(DSSpacing.md),
      decoration: BoxDecoration(
        color: DSColors.surface,
        borderRadius: DSRadius.allMd,
        border: Border.all(color: DSColors.line),
      ),
      child: child,
    );

    if (onTap == null) return content;

    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: DSRadius.allMd,
        child: content,
      ),
    );
  }
}
