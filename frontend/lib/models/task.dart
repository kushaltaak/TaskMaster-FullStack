class Task {
  String title;
  bool completed;
  String category;

  Task({
    required this.title,
    this.completed = false,
    this.category = "Personal",
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "completed": completed,
      "category": category,
    };
  }

  factory Task.fromJson(
      Map<String, dynamic> json) {
    return Task(
      title: json["title"],
      completed: json["completed"] ?? false,
      category: json["category"] ?? "Personal",
    );
  }
}