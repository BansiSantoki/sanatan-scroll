class WisdomModel {
  const WisdomModel({
    required this.id,
    required this.quote,
    required this.source,
    required this.chapter,
    required this.verse,
    this.sanskrit,
    this.reflection,
    this.sageAdvice,
    this.tags = const [],
  });

  final String id;
  final String quote;
  final String source;
  final String chapter;
  final String verse;
  final String? sanskrit;
  final String? reflection;
  final String? sageAdvice;
  final List<String> tags;
}

class DailyActivity {
  const DailyActivity({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  final String id;
  final String title;
  final bool isCompleted;

  DailyActivity copyWith({bool? isCompleted}) {
    return DailyActivity(
      id: id,
      title: title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
