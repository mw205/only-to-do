import 'package:flutter/services.dart';

class AgeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = int.parse(newValue.text);
    if (text > 0 && text >= 150) {
      return oldValue;
    }
    return newValue;
  }
}
