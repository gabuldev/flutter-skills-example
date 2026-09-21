import 'package:app_core/app_core.dart';

sealed class AppointmentDetailStatus {
  const AppointmentDetailStatus();
}

class AppointmentDetailStatusLoading extends AppointmentDetailStatus {
  const AppointmentDetailStatusLoading();
}

class AppointmentDetailStatusSuccess extends AppointmentDetailStatus {
  const AppointmentDetailStatusSuccess(
    this.appointment, {
    this.isCancelling = false,
  });

  final Appointment appointment;
  final bool isCancelling;

  AppointmentDetailStatusSuccess copyWith({
    Appointment? appointment,
    bool? isCancelling,
  }) {
    return AppointmentDetailStatusSuccess(
      appointment ?? this.appointment,
      isCancelling: isCancelling ?? this.isCancelling,
    );
  }
}

class AppointmentDetailStatusError extends AppointmentDetailStatus {
  const AppointmentDetailStatusError(this.message);

  final String message;
}
