import 'package:flutter_observable_state/flutter_observable_state.dart';
import 'package:simplicity/model/task.dart';

class TasksState {
  final tasks = Observable<List<Task>>([]);
}
