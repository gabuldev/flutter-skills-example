import 'package:app_core/app_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_injections/flutter_injections.dart';

import 'appointments_controller.dart';
import 'appointments_screen.dart';

/// Feature module: owns the controller for as long as the feature is open.
///
/// Extends [FlutterModule], which wraps [child] in a `FlutterInjectionsWidget`
/// and disposes these injections when the module leaves the tree.
class AppointmentsModule extends FlutterModule {
  const AppointmentsModule({super.key});

  @override
  List<Inject<Object>> get injections => [
    Inject<AppointmentsController>.lazySingleton(
      (i) => AppointmentsController(
        GetAppointmentsUsecase(i.find<AppointmentRepository>()),
      ),
    ),
  ];

  @override
  Widget get child => BlocProvider<AppointmentsController>(
    create: (_) => FlutterInjections.get<AppointmentsController>()..load(),
    child: const AppointmentsScreen(),
  );
}
