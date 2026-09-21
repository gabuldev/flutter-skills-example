import 'package:agenda/shared/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final formatter = PhoneInputFormatter();

  String format(String input) {
    return formatter
        .formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: input))
        .text;
  }

  group('PhoneInputFormatter', () {
    test('formats an 11-digit mobile number', () {
      expect(format('11912345678'), '(11) 91234-5678');
    });

    test('formats a 10-digit landline', () {
      expect(format('1132145678'), '(11) 3214-5678');
    });

    test('formats progressively while typing', () {
      expect(format('1'), '(1');
      expect(format('11'), '(11');
      expect(format('119'), '(11) 9');
    });

    test('caps input at 11 digits', () {
      expect(format('119123456789999'), '(11) 91234-5678');
    });

    test('ignores non-digits', () {
      expect(format('(11) 91234-5678'), '(11) 91234-5678');
    });
  });

  group('Formatters.unmaskPhone', () {
    test('strips the mask back to digits', () {
      expect(Formatters.unmaskPhone('(11) 91234-5678'), '11912345678');
    });
  });
}
