sealed class AppointmentFormStatus {
  const AppointmentFormStatus();
}

class AppointmentFormStatusEditing extends AppointmentFormStatus {
  const AppointmentFormStatusEditing({this.fieldErrors = const {}});

  final Map<String, String> fieldErrors;
}

class AppointmentFormStatusSaving extends AppointmentFormStatus {
  const AppointmentFormStatusSaving();
}

class AppointmentFormStatusSaved extends AppointmentFormStatus {
  const AppointmentFormStatusSaved();
}

class AppointmentFormStatusError extends AppointmentFormStatus {
  const AppointmentFormStatusError(this.message);

  final String message;
}
