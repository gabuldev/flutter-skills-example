import 'package:app_core/app_core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// One row in the appointment list.
class AppointmentTile extends StatelessWidget {
  const AppointmentTile({
    required this.appointment,
    required this.subtitle,
    this.onTap,
    super.key,
  });

  final Appointment appointment;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return DSCard(
      onTap: onTap,
      semanticLabel:
          '\${appointment.clientName}, \$subtitle, \${appointment.status.name}',
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.clientName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: DSSpacing.xxs),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(width: DSSpacing.sm),
          AppointmentStatusChip(status: appointment.status),
        ],
      ),
    );
  }
}

/// A status pill. Colour carries meaning, so it also carries a text label -
/// colour alone is invisible to a screen reader and to a colour-blind user.
class AppointmentStatusChip extends StatelessWidget {
  const AppointmentStatusChip({required this.status, super.key});

  final AppointmentStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      AppointmentStatus.scheduled => (DSColors.info, 'Scheduled'),
      AppointmentStatus.confirmed => (DSColors.success, 'Confirmed'),
      AppointmentStatus.cancelled => (DSColors.danger, 'Cancelled'),
      AppointmentStatus.done => (DSColors.inkMuted, 'Done'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DSSpacing.sm,
        vertical: DSSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: DSRadius.allSm,
      ),
      child: Text(label, style: DSTypography.label.copyWith(color: color)),
    );
  }
}
