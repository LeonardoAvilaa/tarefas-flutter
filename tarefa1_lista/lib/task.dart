// variaveis usadas para criação da lista
class Task {
  final int id;
  final String title;
  final String description;
  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.completed = false,
  });
}