import 'package:app_core/app_core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/formatters.dart';
import 'appointment_form_controller.dart';
import 'appointment_form_status.dart';

class AppointmentFormScreen extends StatefulWidget {
  const AppointmentFormScreen({this.appointment, super.key});

  final Appointment? appointment;

  @override
  State<AppointmentFormScreen> createState() => _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends State<AppointmentFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _notesController;
  late DateTime _scheduledAt;

  bool get _isEditing => widget.appointment != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.appointment;
    _nameController = TextEditingController(text: existing?.clientName ?? '');
    _phoneController = TextEditingController(text: existing?.clientPhone ?? '');
    _notesController = TextEditingController(text: existing?.notes ?? '');
    _scheduledAt =
        existing?.scheduledAt ?? DateTime.now().add(const Duration(hours: 1));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (!mounted || date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledAt),
    );
    if (!mounted || time == null) return;

    setState(() {
      _scheduledAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _submit() {
    context.read<AppointmentFormController>().save(
      Appointment(
        id: widget.appointment?.id ?? '',
        clientName: _nameController.text.trim(),
        clientPhone: Formatters.unmaskPhone(_phoneController.text),
        scheduledAt: _scheduledAt,
        status: widget.appointment?.status ?? AppointmentStatus.scheduled,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppointmentFormController, AppointmentFormStatus>(
      listener: (context, status) {
        switch (status) {
          case AppointmentFormStatusSaved():
            Navigator.of(context).pop(true);
          case AppointmentFormStatusError(:final message):
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          case AppointmentFormStatusEditing():
          case AppointmentFormStatusSaving():
            break;
        }
      },
      builder: (context, status) {
        final errors = status is AppointmentFormStatusEditing
            ? status.fieldErrors
            : const <String, String>{};
        final isSaving = status is AppointmentFormStatusSaving;

        return Scaffold(
          appBar: AppBar(
            title: Text(_isEditing ? 'Edit appointment' : 'New appointment'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(DSSpacing.md),
            children: [
              DSTextField(
                label: 'Client name',
                controller: _nameController,
                errorText: errors['clientName'],
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: DSSpacing.md),
              DSTextField(
                label: 'Phone',
                controller: _phoneController,
                hint: '(11) 91234-5678',
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  PhoneInputFormatter(),
                ],
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: DSSpacing.md),
              _DateTimeField(
                value: _scheduledAt,
                errorText: errors['scheduledAt'],
                onTap: _pickDateTime,
              ),
              const SizedBox(height: DSSpacing.md),
              DSTextField(
                label: 'Notes',
                controller: _notesController,
                maxLines: 3,
              ),
              const SizedBox(height: DSSpacing.xl),
              DSButton(
                label: _isEditing ? 'Save changes' : 'Create appointment',
                isLoading: isSaving,
                onPressed: _submit,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DateTimeField extends StatelessWidget {
  const _DateTimeField({
    required this.value,
    required this.onTap,
    this.errorText,
  });

  final DateTime value;
  final VoidCallback onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'When, \${Formatters.dateTime(value)}. Double tap to change.',
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          borderRadius: DSRadius.allSm,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'When',
              errorText: errorText,
              border: const OutlineInputBorder(borderRadius: DSRadius.allSm),
            ),
            child: Row(
              children: [
                Expanded(child: Text(Formatters.dateTime(value))),
                const Icon(Icons.event_outlined, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
