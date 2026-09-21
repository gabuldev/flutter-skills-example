import 'package:app_core/app_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppointmentModel', () {
    test('reads the id from _id when present', () {
      final model = AppointmentModel.fromJson({
        '_id': 'abc',
        'clientName': 'Ana',
        'clientPhone': '11912345678',
        'scheduledAt': '2030-01-01T12:00:00.000Z',
        'status': 'confirmed',
      });

      expect(model.id, 'abc');
    });

    test('falls back to id when the backend sends that instead', () {
      final model = AppointmentModel.fromJson({
        'id': 'xyz',
        'clientName': 'Ana',
        'scheduledAt': '2030-01-01T12:00:00.000Z',
      });

      expect(model.id, 'xyz');
    });

    test('parses the UTC date into local time', () {
      final model = AppointmentModel.fromJson({
        'id': '1',
        'clientName': 'Ana',
        'scheduledAt': '2030-01-01T12:00:00.000Z',
      });

      expect(model.scheduledAt.isUtc, isFalse);
      expect(model.scheduledAt.toUtc(), DateTime.utc(2030, 1, 1, 12));
    });

    test('maps an unknown status to scheduled rather than throwing', () {
      final entity = AppointmentModel.fromJson({
        'id': '1',
        'clientName': 'Ana',
        'scheduledAt': '2030-01-01T12:00:00.000Z',
        'status': 'something_new_from_the_api',
      }).toEntity();

      expect(entity.status, AppointmentStatus.scheduled);
    });

    test('omits the id from the payload when creating', () {
      final json = AppointmentModel.fromEntity(
        Appointment(
          id: '',
          clientName: 'Ana',
          clientPhone: '11912345678',
          scheduledAt: DateTime.utc(2030, 1, 1, 12),
          status: AppointmentStatus.scheduled,
        ),
      ).toJson();

      expect(json.containsKey('id'), isFalse);
      expect(json['scheduledAt'], '2030-01-01T12:00:00.000Z');
    });
  });
}
