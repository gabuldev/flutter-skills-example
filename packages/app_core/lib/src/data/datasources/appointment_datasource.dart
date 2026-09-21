import 'package:dio/dio.dart';

import '../models/appointment_model.dart';

/// Talks HTTP. Returns models, never entities.
class AppointmentDatasource {
  const AppointmentDatasource(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> getAppointments({
    required int page,
    required int limit,
    required String query,
  }) {
    return _dio.get<dynamic>(
      '/appointments',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (query.isNotEmpty) 'q': query,
      },
    );
  }

  Future<AppointmentModel> getAppointment(String id) async {
    final response = await _dio.get<Map<String, dynamic>>('/appointments/\$id');
    return AppointmentModel.fromJson(response.data!);
  }

  Future<AppointmentModel> create(AppointmentModel model) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/appointments',
      data: model.toJson(),
    );
    return AppointmentModel.fromJson(response.data!);
  }

  Future<AppointmentModel> update(AppointmentModel model) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '/appointments/\${model.id}',
      data: model.toJson(),
    );
    return AppointmentModel.fromJson(response.data!);
  }

  Future<void> cancel(String id) =>
      _dio.post<void>('/appointments/\$id/cancel');
}
