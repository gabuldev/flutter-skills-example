import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_spacing.dart';
import '../tokens/ds_typography.dart';

/// Shown when a list has nothing in it, or when loading failed.
///
/// An empty list and a failed load are different situations and deserve
/// different copy - that is why [message] and [action] are required to be
/// supplied by the caller rather than defaulted here.
class DSEmptyState extends StatelessWidget {
  const DSEmptyState({
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
    super.key,
  });

  final String title;
  final String message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DSSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: DSColors.inkMuted),
            const SizedBox(height: DSSpacing.md),
            Text(
              title,
              style: DSTypography.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DSSpacing.xs),
            Text(
              message,
              style: DSTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: DSSpacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
