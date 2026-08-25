import '../models/wisdom_model.dart';

class MockWisdomData {
  MockWisdomData._();

  static const WisdomModel dailyWisdom = WisdomModel(
    id: 'w1',
    quote:
        'You have the right to perform your duty, but not to the fruits of your actions.',
    source: 'Bhagavad Gita',
    chapter: 'Chapter 2',
    verse: 'Verse 47',
    sanskrit: 'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन',
    reflection:
        'This teaching reminds us to focus on our efforts rather than outcomes. When we release attachment to results, we find freedom in action and peace in the present moment.',
    sageAdvice:
        'Perform your duties with full dedication, but surrender the results to the Divine. This is the path to inner peace.',
    tags: ['#WisdomReflection', '#KarmaYoga', '#DailyWisdom'],
  );

  static const List<DailyActivity> dailyActivities = [
    DailyActivity(id: 'a1', title: "Read today's verse", isCompleted: true),
    DailyActivity(id: 'a2', title: 'Take one mindful breath', isCompleted: true),
    DailyActivity(
      id: 'a3',
      title: 'Reflect on the teaching',
      isCompleted: false,
    ),
    DailyActivity(
      id: 'a4',
      title: 'Write a gratitude note',
      isCompleted: false,
    ),
    DailyActivity(
      id: 'a5',
      title: 'Share wisdom with someone',
      isCompleted: false,
    ),
  ];

  static const String reflectionQuestion =
      'What can you let go of today?';

  static const String dailyFlowSubtitle =
      'Take a few moments to reconnect with yourself.';

  static const String morningWisdomReflection =
      'As the sun rises, let this wisdom illuminate your path. The Gita teaches that true freedom lies not in avoiding action, but in acting without attachment. Today, practice doing your best while releasing worry about outcomes.';

  static const List<String> todayPractice = [
    "Read today's verse",
    'Take one mindful breath',
    'Reflect on the teaching',
  ];
}
