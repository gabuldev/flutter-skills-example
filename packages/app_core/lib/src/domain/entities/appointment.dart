import 'package:equatable/equatable.dart';

/// Where an appointment is in its lifecycle.
///
/// Sealed as an enum rather than a free string so an unknown value from the
/// API fails at the model boundary instead of halfway through a screen.
enum AppointmentStatus {
  scheduled,
  confirmed,
  cancelled,
  done;

  static AppointmentStatus fromWire(String value) {
    return AppointmentStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => AppointmentStatus.scheduled,
    );
  }
}

/// A scheduled appointment.
///
/// Pure domain: no JSON, no Dio, no Flutter. Conversion lives in
/// `AppointmentModel`.
class Appointment extends Equatable {
  const Appointment({
    required this.id,
    required this.clientName,
    required this.clientPhone,
    required this.scheduledAt,
    required this.status,
    this.notes,
  });

  final String id;
  final String clientName;
  final String clientPhone;
  final DateTime scheduledAt;
  final AppointmentStatus status;
  final String? notes;

  /// Whether this appointment can still be cancelled.
  ///
  /// A cancelled or completed appointment cannot; this is the one business
  /// rule the UI is allowed to ask about directly.
  bool get isCancellable =>
      status == AppointmentStatus.scheduled ||
      status == AppointmentStatus.confirmed;

  Appointment copyWith({
    String? id,
    String? clientName,
    String? clientPhone,
    DateTime? scheduledAt,
    AppointmentStatus? status,
    String? notes,
  }) {
    return Appointment(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    clientName,
    clientPhone,
    scheduledAt,
    status,
    notes,
  ];
}
