/// Route names, in a file that imports nothing.
///
/// This separation is load-bearing. `app_routes.dart` holds the route *table*,
/// and the table imports every screen. A use case, repository or interceptor
/// that reaches for a route name must not drag all of that in with it - on web
/// that chain ends at `dart:ui_web` and takes the VM test suite down with it.
abstract final class AppRouteNames {
  static const String appointments = '/';
  static const String appointmentDetail = '/appointment';
  static const String appointmentForm = '/appointment/form';
}
