class SacredTextModel {
  const SacredTextModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.chapters,
    required this.verses,
    required this.pages,
    required this.gradientIndex,
    this.keyTeachings = const [],
    this.isFeatured = false,
    this.iconEmoji = '📿',
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String category;
  final int chapters;
  final int verses;
  final int pages;
  final int gradientIndex;
  final List<String> keyTeachings;
  final bool isFeatured;
  final String iconEmoji;
}
