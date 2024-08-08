class Goal {
  final String title;
  final String description;
  final String dueDate;

  const Goal({
    required this.title,
    required this.description,
    required this.dueDate,
  });

   factory Goal.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'title': String title,
        'description': String description,
        'dueDate': String dueDate,
      } =>
        Goal(
          title: title,
          description: description,
          dueDate: dueDate,
        ),
      _ => throw const FormatException('Failed to load Goal.'),
    };
  }
}
