import '../entities/appointment.dart';
import '../entities/paginated.dart';

/// The contract the domain depends on. Implemented in the data layer.
abstract interface class AppointmentRepository {
  /// One page of appointments, newest first.
  ///
  /// [query] filters by client name when non-empty.
  Future<Paginated<Appointment>> getAppointments({
    int page = 1,
    int limit = 20,
    String query = '',
  });

  Future<Appointment> getAppointment(String id);

  /// Creates when [appointment] has an empty id, updates otherwise.
  Future<Appointment> save(Appointment appointment);

  Future<void> cancel(String id);
}
