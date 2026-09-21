import 'package:app_core/app_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'appointment_form_status.dart';

/// One controller for both create and edit.
///
/// Which one it is depends on whether the entity passed in has an id - there
/// is no second screen and no second controller.
class AppointmentFormController extends Cubit<AppointmentFormStatus> {
  AppointmentFormController(this._saveAppointment)
    : super(const AppointmentFormStatusEditing());

  final SaveAppointmentUsecase _saveAppointment;

  Future<void> save(Appointment appointment) async {
    emit(const AppointmentFormStatusSaving());
    try {
      await _saveAppointment(appointment);
      emit(const AppointmentFormStatusSaved());
    } on ValidationFailure catch (e) {
      // Field-level errors go back to the fields, not into a snackbar.
      emit(AppointmentFormStatusEditing(fieldErrors: e.fieldErrors));
    } on AppFailure catch (e) {
      emit(AppointmentFormStatusError(e.message));
    }
  }
}
