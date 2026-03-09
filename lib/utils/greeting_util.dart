class GreetingUtil {
  static String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  static String getPersonalizedGreeting(String? firstName) {
    if (firstName == null || firstName.isEmpty) {
      return getGreeting();
    }

    return '${getGreeting()}, $firstName';
  }
}
