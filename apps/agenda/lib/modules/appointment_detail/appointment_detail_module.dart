import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_injections/flutter_injections.dart';

import 'appointment_detail_controller.dart';
import 'appointment_detail_screen.dart';

class AppointmentDetailModule extends FlutterModule {
  const AppointmentDetailModule({required this.appointmentId, super.key});

  final String appointmentId;

  @override
  List<Inject<Object>> get injections => [
    Inject<AppointmentDetailController>.lazySingleton(
      (i) => AppointmentDetailController(
        GetAppointmentUsecase(i.find<AppointmentRepository>()),
        CancelAppointmentUsecase(i.find<AppointmentRepository>()),
      ),
    ),
  ];

  @override
  Widget get child => BlocProvider<AppointmentDetailController>(
    create: (_) =>
        FlutterInjections.get<AppointmentDetailController>()
          ..load(appointmentId),
    child: const AppointmentDetailScreen(),
  );
}
