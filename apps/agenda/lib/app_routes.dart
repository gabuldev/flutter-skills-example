import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

import 'app_route_names.dart';

export 'app_route_names.dart';
import 'modules/appointment_detail/appointment_detail_module.dart';
import 'modules/appointment_form/appointment_form_module.dart';
import 'modules/appointments/appointments_module.dart';

/// The route table. Screens and [MaterialApp] import this; nothing else should.
///
/// Re-exports [AppRouteNames] at the library level, so importing this file also
/// gives you the names. Note it is an `export`, not inheritance: Dart does not
/// inherit static members, so `AppRoutes.appointments` would never resolve.
/// Call them by their own class: `AppRouteNames.appointments`.
abstract final class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      AppRouteNames.appointments => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const AppointmentsModule(),
      ),
      AppRouteNames.appointmentDetail => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => AppointmentDetailModule(
          appointmentId: settings.arguments! as String,
        ),
      ),
      AppRouteNames.appointmentForm => MaterialPageRoute<bool>(
        settings: settings,
        builder: (_) => AppointmentFormModule(
          appointment: settings.arguments as Appointment?,
        ),
      ),
      _ => MaterialPageRoute<void>(
        builder: (_) =>
            const Scaffold(body: Center(child: Text('Route not found'))),
      ),
    };
  }
}
