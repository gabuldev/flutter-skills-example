import 'package:app_core/app_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'appointment_detail_status.dart';

class AppointmentDetailController extends Cubit<AppointmentDetailStatus> {
  AppointmentDetailController(this._getAppointment, this._cancelAppointment)
    : super(const AppointmentDetailStatusLoading());

  final GetAppointmentUsecase _getAppointment;
  final CancelAppointmentUsecase _cancelAppointment;

  Future<void> load(String id) async {
    emit(const AppointmentDetailStatusLoading());
    try {
      emit(AppointmentDetailStatusSuccess(await _getAppointment(id)));
    } on AppFailure catch (e) {
      emit(AppointmentDetailStatusError(e.message));
    }
  }

  /// Returns true when the cancellation went through.
  Future<bool> cancel() async {
    final current = state;
    if (current is! AppointmentDetailStatusSuccess) return false;

    emit(current.copyWith(isCancelling: true));
    try {
      await _cancelAppointment(current.appointment.id);
      emit(
        AppointmentDetailStatusSuccess(
          current.appointment.copyWith(status: AppointmentStatus.cancelled),
        ),
      );
      return true;
    } on AppFailure catch (e) {
      emit(AppointmentDetailStatusError(e.message));
      return false;
    }
  }
}
