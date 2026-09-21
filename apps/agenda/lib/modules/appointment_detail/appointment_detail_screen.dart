import 'package:app_core/app_core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_route_names.dart';
import '../../shared/formatters.dart';
import '../appointments/widgets/appointment_tile.dart';
import 'appointment_detail_controller.dart';
import 'appointment_detail_status.dart';

class AppointmentDetailScreen extends StatelessWidget {
  const AppointmentDetailScreen({super.key});

  Future<void> _cancel(BuildContext context) async {
    final controller = context.read<AppointmentDetailController>();
    final messenger = ScaffoldMessenger.of(context);

    final ok = await controller.cancel();
    if (!context.mounted) return;

    messenger.showSnackBar(
      SnackBar(
        content: Text(ok ? 'Appointment cancelled.' : 'Could not cancel.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointment')),
      body: BlocBuilder<AppointmentDetailController, AppointmentDetailStatus>(
        builder: (context, status) {
          return switch (status) {
            AppointmentDetailStatusLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            AppointmentDetailStatusError(:final message) => DSEmptyState(
              title: 'Could not load',
              message: message,
              icon: Icons.cloud_off_outlined,
            ),
            AppointmentDetailStatusSuccess(
              :final appointment,
              :final isCancelling,
            ) =>
              _DetailBody(appointment: appointment, isCancelling: isCancelling),
          };
        },
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.appointment, required this.isCancelling});

  final Appointment appointment;
  final bool isCancelling;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(DSSpacing.md),
      children: [
        DSCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      appointment.clientName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  AppointmentStatusChip(status: appointment.status),
                ],
              ),
              const SizedBox(height: DSSpacing.md),
              _DetailRow(
                icon: Icons.event_outlined,
                label: 'When',
                value: Formatters.dateTime(appointment.scheduledAt),
              ),
              _DetailRow(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: appointment.clientPhone.isEmpty
                    ? 'Not provided'
                    : appointment.clientPhone,
              ),
              if (appointment.notes != null && appointment.notes!.isNotEmpty)
                _DetailRow(
                  icon: Icons.notes_outlined,
                  label: 'Notes',
                  value: appointment.notes!,
                ),
            ],
          ),
        ),
        const SizedBox(height: DSSpacing.lg),
        DSButton(
          label: 'Edit',
          icon: Icons.edit_outlined,
          onPressed: () => Navigator.of(
            context,
          ).pushNamed(AppRouteNames.appointmentForm, arguments: appointment),
        ),
        if (appointment.isCancellable) ...[
          const SizedBox(height: DSSpacing.sm),
          TextButton(
            onPressed: isCancelling
                ? null
                : () => const AppointmentDetailScreen()._cancel(context),
            child: Text(
              isCancelling ? 'Cancelling…' : 'Cancel appointment',
              style: const TextStyle(color: DSColors.danger),
            ),
          ),
        ],
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    // Icon + text read as one thing to a screen reader.
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.only(bottom: DSSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: DSColors.inkMuted),
            const SizedBox(width: DSSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: DSTypography.label),
                  Text(value, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
