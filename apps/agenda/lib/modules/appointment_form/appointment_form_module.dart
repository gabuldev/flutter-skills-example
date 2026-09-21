import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_injections/flutter_injections.dart';

import 'appointment_form_controller.dart';
import 'appointment_form_screen.dart';

class AppointmentFormModule extends FlutterModule {
  const AppointmentFormModule({this.appointment, super.key});

  /// Null means create; non-null means edit.
  final Appointment? appointment;

  @override
  List<Inject<Object>> get injections => [
    Inject<AppointmentFormController>.lazySingleton(
      (i) => AppointmentFormController(
        SaveAppointmentUsecase(i.find<AppointmentRepository>()),
      ),
    ),
  ];

  @override
  Widget get child => BlocProvider<AppointmentFormController>(
    create: (_) => FlutterInjections.get<AppointmentFormController>(),
    child: AppointmentFormScreen(appointment: appointment),
  );
}
