import 'package:dio/dio.dart';
import 'package:flutter_injections/flutter_injections.dart';

import 'src/data/datasources/appointment_datasource.dart';
import 'src/data/repositories/appointment_repository_impl.dart';
import 'src/domain/repositories/appointment_repository.dart';
import 'src/shared/storage.dart';

/// Everything that lives for the whole app.
///
/// Feature controllers are NOT here - they belong to their module, so they are
/// built when the feature opens and disposed when it closes.
abstract final class CoreInjections {
  static List<Inject<Object>> core({required String baseUrl}) => [
    ...services(baseUrl: baseUrl),
    ...appointments(),
  ];

  static List<Inject<Object>> services({required String baseUrl}) => [
    Inject<Dio>.singleton(
      (i) => Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      ),
    ),
    Inject<Storage>.singleton((i) => const PreferencesStorage()),
  ];

  static List<Inject<Object>> appointments() => [
    Inject<AppointmentDatasource>((i) => AppointmentDatasource(i.find<Dio>())),
    Inject<AppointmentRepository>(
      (i) => AppointmentRepositoryImpl(
        i.find<AppointmentDatasource>(),
        i.find<Storage>(),
      ),
    ),
  ];
}
