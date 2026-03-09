import 'dart:math';
import 'package:flutter/services.dart';

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    var selectionIndex = newValue.selection.end;
    var substrIndex = 0;
    final StringBuffer newString = StringBuffer();
    if (newText.isNotEmpty) {
      newString.write(
        newText.substring(0, substrIndex = min(1, newText.length)),
      );
      if (substrIndex < selectionIndex) selectionIndex++;
    }

    if (newText.length > 1) {
      newString.write(
        newText.substring(1, substrIndex = min(2, newText.length)),
      );
      if (newText.length >= 2) {
        newString.write('/');
        if (newText.length == 2 && newValue.selection.end == 2) {
          selectionIndex++;
        }
      }
    }

    if (newText.length > 2) {
      newString.write(
        newText.substring(2, substrIndex = min(3, newText.length)),
      );
    }

    if (newText.length > 3) {
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
