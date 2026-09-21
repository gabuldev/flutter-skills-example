import 'package:flutter/material.dart';

import '../tokens/ds_radius.dart';
import '../tokens/ds_spacing.dart';

/// The product's primary action.
///
/// Wraps [FilledButton] so a loading state and the minimum 48dp tap target are
/// decided once, here, instead of in every screen that needs to submit
/// something.
class DSButton extends StatelessWidget {
  const DSButton({
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    // A button that is loading must not also be tappable.
    final effectiveOnPressed = isLoading ? null : onPressed;

    return Semantics(
      button: true,
      enabled: effectiveOnPressed != null,
      label: isLoading ? '\$label, loading' : label,
      child: ExcludeSemantics(
        child: FilledButton(
          onPressed: effectiveOnPressed,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: const RoundedRectangleBorder(borderRadius: DSRadius.allMd),
          ),
          child: isLoading
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 18),
                      const SizedBox(width: DSSpacing.sm),
                    ],
                    Text(label),
                  ],
                ),
        ),
      ),
    );
  }
}
