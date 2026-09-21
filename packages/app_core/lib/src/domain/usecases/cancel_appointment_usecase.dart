import '../repositories/appointment_repository.dart';

/// Cancels an appointment.
class CancelAppointmentUsecase {
  const CancelAppointmentUsecase(this._repository);

  final AppointmentRepository _repository;

  Future<void> call(String id) => _repository.cancel(id);
}
