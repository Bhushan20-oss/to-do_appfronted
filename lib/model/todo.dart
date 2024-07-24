// lib/models/todo.dart
class ToDo {
  String? id;
  String? title;
  bool status;

  ToDo({
    required this.id,
    required this.title,
    required this.status,
  });

  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      id: json['id'].toString(),
      title: json['title'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'title': title,
      'status': status,
    };
  }
}
