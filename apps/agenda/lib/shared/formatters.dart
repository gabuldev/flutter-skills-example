import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// pt-BR phone mask: (11) 91234-5678 / (11) 1234-5678.
///
/// Formats as the user types and caps the input at 11 digits, so the field
/// cannot hold a value the backend will reject.
class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final capped = digits.length > 11 ? digits.substring(0, 11) : digits;

    final buffer = StringBuffer();
    for (var i = 0; i < capped.length; i++) {
      if (i == 0) buffer.write('(');
      if (i == 2) buffer.write(') ');
      // 11-digit mobile breaks after 7; 10-digit landline after 6.
      if (i == (capped.length > 10 ? 7 : 6)) buffer.write('-');
      buffer.write(capped[i]);
    }

    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// Date and time formatting for display.
abstract final class Formatters {
  static final DateFormat _date = DateFormat('dd/MM/yyyy');
  static final DateFormat _time = DateFormat('HH:mm');
  static final DateFormat _dateTime = DateFormat("dd/MM/yyyy 'at' HH:mm");

  static String date(DateTime value) => _date.format(value);
  static String time(DateTime value) => _time.format(value);
  static String dateTime(DateTime value) => _dateTime.format(value);

  /// Digits only, for sending to the API.
  static String unmaskPhone(String masked) =>
      masked.replaceAll(RegExp(r'\D'), '');
}
