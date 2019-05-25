import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:simplicity/main.dart';
import 'package:simplicity/model/task.dart';
import 'package:simplicity/state/tasks_state.dart';

class TaskTileIOS extends StatelessWidget {
  final tasksState = getIt.get<TasksState>();
  final Task task;

  TaskTileIOS({Key key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Dismissible(
        key: ValueKey(task.id),
        onDismissed: (_) => tasksState.tasks.change((tasks) => tasks.where((t) => t.id != task.id).toList()),
        direction: DismissDirection.startToEnd,
        child: ListTile(
          title: Text(
            task.task,
            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  decoration: task.completed ? TextDecoration.lineThrough : TextDecoration.none,
                  fontWeight: FontWeight.w500,
                  color: task.completed ? Colors.grey.shade500 : CupertinoTheme.of(context).textTheme.textStyle.color,
                ),
          ),
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
      ),
    );
  }
}
