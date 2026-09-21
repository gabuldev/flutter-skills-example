import 'package:app_core/app_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAppointmentRepository extends Mock
    implements AppointmentRepository {}

void main() {
  late _MockAppointmentRepository repository;
  late SaveAppointmentUsecase usecase;

  Appointment validAppointment() => Appointment(
    id: '',
    clientName: 'Ana',
    clientPhone: '11912345678',
    scheduledAt: DateTime.now().add(const Duration(days: 1)),
    status: AppointmentStatus.scheduled,
  );

  setUpAll(() {
    registerFallbackValue(validAppointment());
  });

  setUp(() {
    repository = _MockAppointmentRepository();
    usecase = SaveAppointmentUsecase(repository);
  });

  group('SaveAppointmentUsecase', () {
    test('delegates to the repository when the appointment is valid', () async {
      final appointment = validAppointment();
      when(() => repository.save(any())).thenAnswer((_) async => appointment);

      final result = await usecase(appointment);

      expect(result, equals(appointment));
      verify(() => repository.save(appointment)).called(1);
    });

    test('rejects an empty client name without touching the repository', () {
      final appointment = validAppointment().copyWith(clientName: '   ');

      expect(
        () => usecase(appointment),
        throwsA(
          isA<ValidationFailure>().having(
            (f) => f.fieldErrors,
            'fieldErrors',
            containsPair('clientName', 'Required'),
          ),
        ),
      );
      verifyNever(() => repository.save(any()));
    });

    test('rejects a date in the past', () {
      final appointment = validAppointment().copyWith(
        scheduledAt: DateTime.now().subtract(const Duration(minutes: 1)),
      );

      expect(
        () => usecase(appointment),
        throwsA(
          isA<ValidationFailure>().having(
            (f) => f.fieldErrors,
            'fieldErrors',
            contains('scheduledAt'),
          ),
        ),
      );
      verifyNever(() => repository.save(any()));
    });
  });
}
