class DateFormatter {
  static String formatLastSynced(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'Never';
    }

    try {
      if (dateString.contains('T')) {
        final parts = dateString.split('T');
        if (parts.length >= 2) {
          final date = parts[0];
          final time = parts[1].length >= 5 ? parts[1].substring(0, 5) : '';
          return '$date $time';
        }
      }

      return dateString;
    } catch (e) {
      return 'Date format error';
    }
  }
}
