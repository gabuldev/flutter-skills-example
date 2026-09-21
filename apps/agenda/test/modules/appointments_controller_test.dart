import 'package:app_core/app_core.dart';
import 'package:agenda/modules/appointments/appointments_controller.dart';
import 'package:agenda/modules/appointments/appointments_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements AppointmentRepository {}

void main() {
  late _MockRepository repository;
  late GetAppointmentsUsecase usecase;

  Appointment appointment(String id) => Appointment(
    id: id,
    clientName: 'Client \$id',
    clientPhone: '11912345678',
    scheduledAt: DateTime(2030, 1, 1, 12),
    status: AppointmentStatus.scheduled,
  );

  setUp(() {
    repository = _MockRepository();
    usecase = GetAppointmentsUsecase(repository);
  });

  group('AppointmentsController', () {
    blocTest<AppointmentsController, AppointmentsStatus>(
      'emits loading then success on load',
      build: () {
        when(
          () => repository.getAppointments(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            query: any(named: 'query'),
          ),
        ).thenAnswer(
          (_) async => Paginated<Appointment>(
            items: [appointment('1')],
            total: 1,
            page: 1,
            limit: 20,
          ),
        );
        return AppointmentsController(usecase);
      },
      act: (controller) => controller.load(),
      expect: () => [
        isA<AppointmentsStatusLoading>(),
        isA<AppointmentsStatusSuccess>().having(
          (s) => s.page.items.length,
          'items',
          1,
        ),
      ],
    );

    blocTest<AppointmentsController, AppointmentsStatus>(
      'emits error when the repository fails',
      build: () {
        when(
          () => repository.getAppointments(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            query: any(named: 'query'),
          ),
        ).thenThrow(const NetworkFailure());
        return AppointmentsController(usecase);
      },
      act: (controller) => controller.load(),
      expect: () => [
        isA<AppointmentsStatusLoading>(),
        isA<AppointmentsStatusError>(),
      ],
    );

    blocTest<AppointmentsController, AppointmentsStatus>(
      'appends the next page instead of replacing the list',
      build: () {
        var call = 0;
        when(
          () => repository.getAppointments(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            query: any(named: 'query'),
          ),
        ).thenAnswer((_) async {
          call++;
          return Paginated<Appointment>(
            items: [appointment('\$call')],
            total: 2,
            page: call,
            limit: 1,
          );
        });
        return AppointmentsController(usecase);
      },
      act: (controller) async {
        await controller.load();
        await controller.loadNextPage();
      },
      skip: 2,
      expect: () => [
        isA<AppointmentsStatusSuccess>().having(
          (s) => s.isLoadingMore,
          'isLoadingMore',
          isTrue,
        ),
        isA<AppointmentsStatusSuccess>().having(
          (s) => s.page.items.length,
          'accumulated items',
          2,
        ),
      ],
    );

    blocTest<AppointmentsController, AppointmentsStatus>(
      'does not page past the end',
      build: () {
        when(
          () => repository.getAppointments(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            query: any(named: 'query'),
          ),
        ).thenAnswer(
          (_) async => Paginated<Appointment>(
            items: [appointment('1')],
            total: 1,
            page: 1,
            limit: 20,
          ),
        );
        return AppointmentsController(usecase);
      },
      act: (controller) async {
        await controller.load();
        await controller.loadNextPage();
      },
      skip: 2,
      expect: () => <AppointmentsStatus>[],
    );
  });
}
