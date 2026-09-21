import 'package:app_core/app_core.dart';

/// The four states every list screen has.
///
/// Sealed, so a `switch` over it is exhaustive and adding a fifth variant is a
/// compile error in every screen instead of a silently missing branch.
sealed class AppointmentsStatus {
  const AppointmentsStatus();
}

class AppointmentsStatusEmpty extends AppointmentsStatus {
  const AppointmentsStatusEmpty();
}

class AppointmentsStatusLoading extends AppointmentsStatus {
  const AppointmentsStatusLoading();
}

class AppointmentsStatusSuccess extends AppointmentsStatus {
  const AppointmentsStatusSuccess({
    required this.page,
    this.isLoadingMore = false,
  });

  final Paginated<Appointment> page;
  final bool isLoadingMore;

  AppointmentsStatusSuccess copyWith({
    Paginated<Appointment>? page,
    bool? isLoadingMore,
  }) {
    return AppointmentsStatusSuccess(
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class AppointmentsStatusError extends AppointmentsStatus {
  const AppointmentsStatusError(this.message);

  final String message;
}
