import '../entities/appointment.dart';
import '../entities/paginated.dart';
import '../repositories/appointment_repository.dart';

/// Fetches one page of appointments.
class GetAppointmentsUsecase {
  const GetAppointmentsUsecase(this._repository);

  final AppointmentRepository _repository;

  Future<Paginated<Appointment>> call({
    int page = 1,
    int limit = 20,
    String query = '',
  }) {
    return _repository.getAppointments(page: page, limit: limit, query: query);
  }
}
