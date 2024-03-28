class TaskModel {
  final String task_completed;
  final String task_name;
  final String task_discription;
  final String task_date;
  final String task_time;
  final int task_priority;

  const TaskModel({
    required this.task_completed,
    required this.task_name,
    required this.task_discription,
    required this.task_date,
    required this.task_time,
    required this.task_priority,
  });

  Map<String,Object?> toMap() {
    return {
      'task_completed' : task_completed,
      'task_name' : task_name,
      'task_discription' : task_discription,
      'task_date' : task_date,
      'task_time' : task_time,
      'task_priority' : task_priority,
    };
  }
}
