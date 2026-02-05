import 'dart:math';
import 'package:flutter/services.dart';

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Only allow digits
    final newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    var selectionIndex = newValue.selection.end;
    var substrIndex = 0;
    final StringBuffer newString = StringBuffer();

    // Format as MM/YY
    if (newText.isNotEmpty) {
      // Add first digit of month
      newString.write(
        newText.substring(0, substrIndex = min(1, newText.length)),
      );
      if (substrIndex < selectionIndex) selectionIndex++;
    }

    if (newText.length > 1) {
      // Add second digit of month
      newString.write(
        newText.substring(1, substrIndex = min(2, newText.length)),
      );

      // Add slash after month
      if (newText.length >= 2) {
        newString.write('/');
        if (newText.length == 2 && newValue.selection.end == 2) {
          selectionIndex++;
        }
      }
    }

    if (newText.length > 2) {
      // Add first digit of year
      newString.write(
        newText.substring(2, substrIndex = min(3, newText.length)),
      );
    }

    if (newText.length > 3) {
      // Add second digit of year
      newString.write(
        newText.substring(3, substrIndex = min(4, newText.length)),
      );
    }

    return TextEditingValue(
      text: newString.toString(),
      selection: TextSelection.collapsed(
        offset: min(selectionIndex, newString.length),
      ),
    );
  }
}
