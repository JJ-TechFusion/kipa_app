import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ValidatingExtensions on String {
  String? validateAnyField({String? field}) {
    if (toString().isEmpty) {
      return '*Required';
    } else {
      return null;
    }
  }

  String? validateName({String? field}) {
    if (toString().isEmpty) {
      return '$field  is required ';
    } else if (toString().length < 3) {
      return 'Enter valid $field';
    } else {
      return null;
    }
  }

  String? validateTitle() {
    if (isEmpty) {
      return 'Professional title is required';
    } else {
      return null;
    }
  }

  String? validatePhoneNumber() {
    if (isEmpty) {
      return 'Phone number is required';
    }

    final pattern = RegExp(r'^\+?[0-9]{8,}$');

    if (!pattern.hasMatch(this)) {
      return 'Invalid phone number';
    } else if (length < 11) {
      return 'Invalid phone number';
    } else {
      return null;
    }
  }

  String? validateEmail() {
    if (isEmpty) {
      return 'Email is required';
    }

    final pattern = RegExp(
      r"^((([a-zA-Z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-zA-Z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-zA-Z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-zA-Z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-zA-Z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-zA-Z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-zA-Z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-zA-Z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-zA-Z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$",
    );

    if (pattern.hasMatch(this)) {
      return null;
    } else {
      return 'Invalid email';
    }
  }

  String? validatePassword() {
    if (isEmpty) {
      return 'Password is required';
    }

    if (length < 6) {
      return 'Password must contain uppercase, lowercase and number';
    }

    return null;
  }
}

extension Formatter on TextEditingController {
  String get trimmedText => text.trim();
}

extension DateFormatter on DateTime {
  String toAppFormat() => DateFormat.yMMMMd().format(this);

  String get fetchDateOnly => toString().substring(0, 10);

  String get goalsDateFormat => DateFormat('dd MMM yyyy').format(this);
}

extension Retreiver on File {
  String get extension => path.split('.').last;
}

extension DateFormtter on DateTime {
  String formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}, ${date.year}';
  }
}

extension TimeFormatter on DateTime {
  String formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $period';
  }
}
