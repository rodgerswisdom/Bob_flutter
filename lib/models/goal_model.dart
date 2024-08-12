class Goal {
  final String? id;
  final String title;
  final String description;
  final String dueDate;
  final bool achieved;

  const Goal({
    this.id, 
    required this.title,
    required this.description,
    required this.dueDate,
    required this.achieved,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: json['dueDate'] as String,
      achieved: json['achieved'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'achieved': achieved,
    };
  }
}
