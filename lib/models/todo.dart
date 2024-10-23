class Todo {
  final int userId;
  final int id;
  final String title;
  bool completed;

  Todo({
    required this.userId,
    required this.id,
    required this.title,
    this.completed = false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {;
    return Todo(
      userId: json['userId'], 
      id: json['id'], 
      title: json['title'],
      completed: json['completed'],
      );
  }

  Map<String, dynamic>toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'completed': completed,
    };
  }
}