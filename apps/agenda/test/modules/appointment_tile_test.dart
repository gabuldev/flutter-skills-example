import 'package:agenda/modules/appointments/widgets/appointment_tile.dart';
import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Appointment appointment({
    AppointmentStatus status = AppointmentStatus.scheduled,
  }) => Appointment(
    id: '1',
    clientName: 'Ana Souza',
    clientPhone: '11912345678',
    scheduledAt: DateTime(2030, 1, 1, 12),
    status: status,
  );

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('shows the client name and the formatted subtitle', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        AppointmentTile(
          appointment: appointment(),
          subtitle: '01/01/2030 at 12:00',
        ),
      ),
    );

    expect(find.text('Ana Souza'), findsOneWidget);
    expect(find.text('01/01/2030 at 12:00'), findsOneWidget);
  });

  testWidgets('labels the status in text, not only in colour', (tester) async {
    await tester.pumpWidget(
      wrap(
        AppointmentTile(
          appointment: appointment(status: AppointmentStatus.confirmed),
          subtitle: 'whenever',
        ),
      ),
    );

    expect(find.text('Confirmed'), findsOneWidget);
  });

  testWidgets('is not announced as a button when it has no onTap', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(AppointmentTile(appointment: appointment(), subtitle: 'whenever')),
    );

    expect(find.byType(InkWell), findsNothing);
  });

  testWidgets('calls onTap when tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(
        AppointmentTile(
          appointment: appointment(),
          subtitle: 'whenever',
          onTap: () => tapped = true,
        ),
      ),
    );

    await tester.tap(find.byType(AppointmentTile));
    expect(tapped, isTrue);
  });
}
