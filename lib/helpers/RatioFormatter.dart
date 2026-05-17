import 'package:flutter/services.dart';

class RatioInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;

    if (newText.isEmpty) {
      return newValue;
    }

    final validCharacters = RegExp(r'^[0-9]*$');
    if (!validCharacters.hasMatch(newText)) {
      return oldValue;
    }

    // Limit each part to one digit
    final formattedText =
        newText.length > 1 ? '${newText[0]}:${newText[1]}' : newText;

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow only digits and a single decimal point
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');

    // Ensure that only one decimal point exists
    final hasDot = newText.contains('.');
    if (hasDot) {
      final parts = newText.split('.');
      newText = '${parts[0]}.${parts[1].replaceAll('.', '')}';
    }

    return newValue.copyWith(text: newText);
  }
}
