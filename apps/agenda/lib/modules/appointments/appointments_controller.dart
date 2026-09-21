import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'appointments_status.dart';

/// Drives the appointment list: first load, search, and paging.
class AppointmentsController extends Cubit<AppointmentsStatus> {
  AppointmentsController(this._getAppointments)
    : super(const AppointmentsStatusEmpty());

  final GetAppointmentsUsecase _getAppointments;

  static const Duration _debounce = Duration(milliseconds: 400);

  Timer? _debounceTimer;
  String _query = '';

  Future<void> load() async {
    emit(const AppointmentsStatusLoading());
    await _fetch(page: 1);
  }

  /// Debounced so typing does not fire a request per keystroke.
  void search(String query) {
    _query = query;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounce, () {
      unawaited(_fetch(page: 1));
    });
  }

  Future<void> loadNextPage() async {
    final current = state;
    if (current is! AppointmentsStatusSuccess) return;
    if (current.isLoadingMore || !current.page.hasNextPage) return;

    emit(current.copyWith(isLoadingMore: true));

    try {
      final next = await _getAppointments(
        page: current.page.page + 1,
        query: _query,
      );
      emit(
        AppointmentsStatusSuccess(
          page: Paginated<Appointment>(
            items: [...current.page.items, ...next.items],
            total: next.total,
            page: next.page,
            limit: next.limit,
          ),
        ),
      );
    } on AppFailure catch (e) {
      // Paging failure must not wipe the list already on screen.
      emit(current.copyWith(isLoadingMore: false));
      _lastPagingError = e.message;
    }
  }

  String? _lastPagingError;
  String? get lastPagingError => _lastPagingError;

  Future<void> _fetch({required int page}) async {
    try {
      final result = await _getAppointments(page: page, query: _query);
      emit(AppointmentsStatusSuccess(page: result));
    } on AppFailure catch (e) {
      emit(AppointmentsStatusError(e.message));
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
