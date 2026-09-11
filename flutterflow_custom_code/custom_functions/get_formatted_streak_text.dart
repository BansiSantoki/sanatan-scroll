// Automatic FlutterFlow Custom Function
// Name: getFormattedStreakText
// Description: Formats daily reading streak count according to locale.

String getFormattedStreakText(int streakDays, String languageCode) {
  switch (languageCode) {
    case 'gu':
      return '$streakDays દિવસ સ્ટ્રીક';
    case 'hi':
      return '$streakDays दिन स्ट्रिक';
    case 'en':
    default:
      return '$streakDays Days Streak';
  }
}
