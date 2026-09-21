import '../../domain/entities/appointment.dart';

/// JSON <-> [Appointment].
///
/// The entity has no `fromJson`; that separation is what lets the API shape
/// change without touching the domain.
class AppointmentModel {
  const AppointmentModel({
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
  final String status;
  final String? notes;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      // Some backends send `_id`, some `id`. Read both rather than discover
      // this in production.
      id: (json['_id'] ?? json['id']) as String,
      clientName: json['clientName'] as String,
      clientPhone: json['clientPhone'] as String? ?? '',
      // Dates arrive as UTC ISO strings; show them in the device's zone.
      scheduledAt: DateTime.parse(json['scheduledAt'] as String).toLocal(),
      status: json['status'] as String? ?? 'scheduled',
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id.isNotEmpty) 'id': id,
    'clientName': clientName,
    'clientPhone': clientPhone,
    'scheduledAt': scheduledAt.toUtc().toIso8601String(),
    'status': status,
    if (notes != null) 'notes': notes,
  };

  Appointment toEntity() => Appointment(
    id: id,
    clientName: clientName,
    clientPhone: clientPhone,
    scheduledAt: scheduledAt,
    status: AppointmentStatus.fromWire(status),
    notes: notes,
  );

  static AppointmentModel fromEntity(Appointment entity) => AppointmentModel(
    id: entity.id,
    clientName: entity.clientName,
    clientPhone: entity.clientPhone,
    scheduledAt: entity.scheduledAt,
    status: entity.status.name,
    notes: entity.notes,
  );
}
