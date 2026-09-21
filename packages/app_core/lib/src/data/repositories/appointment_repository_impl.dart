import 'dart:convert';

import 'package:dio/dio.dart';

import '../../domain/entities/appointment.dart';
import '../../domain/entities/paginated.dart';
import '../../domain/failures/app_failure.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../../shared/storage.dart';
import '../datasources/appointment_datasource.dart';
import '../models/appointment_model.dart';
import '../models/paginated_model.dart';

/// Offline-first implementation.
///
/// The first page is cached, so a cold start with no connection still shows
/// something. Later pages are not - paging while offline is not a promise
/// worth making.
class AppointmentRepositoryImpl implements AppointmentRepository {
  const AppointmentRepositoryImpl(this._datasource, this._storage);

  static const String _cacheKey = 'appointments.first_page';

  final AppointmentDatasource _datasource;
  final Storage _storage;

  @override
  Future<Paginated<Appointment>> getAppointments({
    int page = 1,
    int limit = 20,
    String query = '',
  }) async {
    final isCacheablePage = page == 1 && query.isEmpty;

    try {
      final response = await _datasource.getAppointments(
        page: page,
        limit: limit,
        query: query,
      );

      final json = Map<String, dynamic>.from(response.data as Map);
      final rawItems = (json['items'] as List<dynamic>? ?? <dynamic>[]);

      if (isCacheablePage) {
        await _storage.write(_cacheKey, jsonEncode(json));
      }

      final items = rawItems
          .map(
            (e) => AppointmentModel.fromJson(
              Map<String, dynamic>.from(e as Map),
            ).toEntity(),
          )
          .toList();

      return PaginatedModel<Appointment>.fromJson(
        json: json,
        items: items,
      ).toEntity();
    } on DioException catch (e) {
      // Connectivity failure and a cacheable page: serve what we have.
      if (isCacheablePage && _isConnectivityError(e)) {
        final cached = await _readCache();
        if (cached != null) return cached;
      }
      throw _toFailure(e);
    }
  }

  @override
  Future<Appointment> getAppointment(String id) async {
    try {
      final model = await _datasource.getAppointment(id);
      return model.toEntity();
    } on DioException catch (e) {
      throw _toFailure(e);
    }
  }

  @override
  Future<Appointment> save(Appointment appointment) async {
    final model = AppointmentModel.fromEntity(appointment);
    try {
      final saved = appointment.id.isEmpty
          ? await _datasource.create(model)
          : await _datasource.update(model);
      // The list is stale the moment a write lands.
      await _storage.delete(_cacheKey);
      return saved.toEntity();
    } on DioException catch (e) {
      throw _toFailure(e);
    }
  }

  @override
  Future<void> cancel(String id) async {
    try {
      await _datasource.cancel(id);
      await _storage.delete(_cacheKey);
    } on DioException catch (e) {
      throw _toFailure(e);
    }
  }

  Future<Paginated<Appointment>?> _readCache() async {
    final raw = await _storage.read(_cacheKey);
    if (raw == null) return null;
    try {
      final json = Map<String, dynamic>.from(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      final items = (json['items'] as List<dynamic>? ?? <dynamic>[])
          .map(
            (e) => AppointmentModel.fromJson(
              Map<String, dynamic>.from(e as Map),
            ).toEntity(),
          )
          .toList();
      return PaginatedModel<Appointment>.fromJson(
        json: json,
        items: items,
      ).toEntity();
    } on FormatException {
      // A corrupt cache is not worth crashing over; drop it and go to network.
      await _storage.delete(_cacheKey);
      return null;
    }
  }

  static bool _isConnectivityError(DioException e) {
    return e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout;
  }

  static AppFailure _toFailure(DioException e) {
    if (_isConnectivityError(e)) return const NetworkFailure();

    final status = e.response?.statusCode;
    final data = e.response?.data;
    final message = data is Map && data['message'] is String
        ? data['message'] as String
        : 'Something went wrong. Try again.';

    if (status == 422 || status == 400) return ValidationFailure(message);
    return ServerFailure(message, statusCode: status);
  }
}
