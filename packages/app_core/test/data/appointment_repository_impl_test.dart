import 'dart:convert';

import 'package:app_core/app_core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDatasource extends Mock implements AppointmentDatasource {}

/// An in-memory [Storage]. A fake, not a mock: it behaves like the real thing
/// with simplified internals, so the test asserts on outcomes rather than on
/// which methods were called.
class _FakeStorage implements Storage {
  final Map<String, String> _values = {};

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async => _values[key] = value;

  @override
  Future<void> delete(String key) async => _values.remove(key);
}

void main() {
  late _MockDatasource datasource;
  late _FakeStorage storage;
  late AppointmentRepositoryImpl repository;

  final pageJson = {
    'items': [
      {
        'id': '1',
        'clientName': 'Ana',
        'clientPhone': '11912345678',
        'scheduledAt': '2030-01-01T12:00:00.000Z',
        'status': 'scheduled',
      },
    ],
    'total': 1,
    'page': 1,
    'limit': 20,
  };

  Response<dynamic> responseWith(Map<String, dynamic> json) =>
      Response<dynamic>(
        data: json,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/appointments'),
      );

  DioException connectionError() => DioException(
    type: DioExceptionType.connectionError,
    requestOptions: RequestOptions(path: '/appointments'),
  );

  setUp(() {
    datasource = _MockDatasource();
    storage = _FakeStorage();
    repository = AppointmentRepositoryImpl(datasource, storage);
  });

  group('getAppointments', () {
    test('caches the first unfiltered page', () async {
      when(
        () => datasource.getAppointments(
          page: any(named: 'page'),
          limit: any(named: 'limit'),
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async => responseWith(pageJson));

      await repository.getAppointments();

      final cached = await storage.read('appointments.first_page');
      expect(cached, isNotNull);
      expect(jsonDecode(cached!), equals(pageJson));
    });

    test('serves the cache when the network is unreachable', () async {
      await storage.write('appointments.first_page', jsonEncode(pageJson));
      when(
        () => datasource.getAppointments(
          page: any(named: 'page'),
          limit: any(named: 'limit'),
          query: any(named: 'query'),
        ),
      ).thenThrow(connectionError());

      final result = await repository.getAppointments();

      expect(result.items.single.clientName, 'Ana');
    });

    test('throws NetworkFailure offline when there is no cache', () {
      when(
        () => datasource.getAppointments(
          page: any(named: 'page'),
          limit: any(named: 'limit'),
          query: any(named: 'query'),
        ),
      ).thenThrow(connectionError());

      expect(
        () => repository.getAppointments(),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('does not serve the cache for page 2', () {
      when(
        () => datasource.getAppointments(
          page: any(named: 'page'),
          limit: any(named: 'limit'),
          query: any(named: 'query'),
        ),
      ).thenThrow(connectionError());

      expect(
        () => repository.getAppointments(page: 2),
        throwsA(isA<NetworkFailure>()),
      );
    });
  });

  group('cancel', () {
    test('invalidates the cached list', () async {
      await storage.write('appointments.first_page', jsonEncode(pageJson));
      when(() => datasource.cancel(any())).thenAnswer((_) async {});

      await repository.cancel('1');

      expect(await storage.read('appointments.first_page'), isNull);
    });
  });
}
