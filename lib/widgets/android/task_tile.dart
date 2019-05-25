import 'package:flutter/material.dart';

import 'package:simplicity/main.dart';
import 'package:simplicity/model/task.dart';
import 'package:simplicity/state/tasks_state.dart';

class TaskTile extends StatelessWidget {
  final tasksState = getIt.get<TasksState>();
  final Task task;

  TaskTile(this.task);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.id),
      onDismissed: (_) => tasksState.tasks.change((tasks) => tasks.where((t) => t.id != task.id).toList()),
      direction: DismissDirection.startToEnd,
      child: ListTile(
        title: Text(
          task.task,
          style: TextStyle(
            decoration: task.completed ? TextDecoration.lineThrough : TextDecoration.none,
            fontWeight: FontWeight.w500,
            color: task.completed ? Colors.grey.shade500 : Theme.of(context).textTheme.subhead.color,
          ),
        ),
        onTap: () {
          tasksState.tasks.change(
              (tasks) => tasks.map((t) => t.id == task.id ? task.copyWith(nCompleted: !task.completed) : t).toList());
        },
      ),
      background: Container(
        color: Colors.red,
        child: Row(
          children: <Widget>[
            SizedBox(width: 12),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            SizedBox(width: 12),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
