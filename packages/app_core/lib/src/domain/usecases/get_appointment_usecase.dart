import '../entities/appointment.dart';
import '../repositories/appointment_repository.dart';

/// Fetches a single appointment by id.
class GetAppointmentUsecase {
  const GetAppointmentUsecase(this._repository);

  final AppointmentRepository _repository;

  Future<Appointment> call(String id) => _repository.getAppointment(id);
}
