import '../entities/appointment.dart';
import '../failures/app_failure.dart';
import '../repositories/appointment_repository.dart';

/// Creates or updates an appointment.
///
/// The scheduling rules live here rather than in the controller, so the phone
/// app and any future admin panel cannot disagree about them.
class SaveAppointmentUsecase {
  const SaveAppointmentUsecase(this._repository);

  final AppointmentRepository _repository;

  Future<Appointment> call(Appointment appointment) {
    if (appointment.clientName.trim().isEmpty) {
      throw const ValidationFailure(
        'Client name is required.',
        fieldErrors: {'clientName': 'Required'},
      );
    }
    if (appointment.scheduledAt.isBefore(DateTime.now())) {
      throw const ValidationFailure(
        'An appointment cannot be scheduled in the past.',
        fieldErrors: {'scheduledAt': 'Pick a future date'},
      );
    }
    return _repository.save(appointment);
  }
}
