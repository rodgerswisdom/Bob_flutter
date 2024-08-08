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
    return Goal(
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: json['dueDate'] as String,
    );
  }
}
