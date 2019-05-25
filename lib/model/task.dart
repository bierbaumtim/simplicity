class Task {
  final int id;
  final String task;
  final bool completed;

  const Task({this.task, this.completed, this.id});

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        task: json['task'] as String,
        completed: json['completed'] as bool,
        id: json['id'] as int,
      );

  Map<String, dynamic> toJson() => {
        'task': this.task,
        'completed': this.completed,
        'id': this.id,
      };

  Task copyWith({String nTask, bool nCompleted}) => Task(
        task: nTask ?? this.task,
        completed: nCompleted ?? this.completed,
        id: this.id,
      );
}
