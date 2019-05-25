import 'package:flutter/material.dart';
import 'package:simplicity/main.dart';
import 'package:simplicity/model/task.dart';
import 'package:simplicity/state/tasks_state.dart';

class AddTaskTile extends StatefulWidget {
  const AddTaskTile({Key key}) : super(key: key);

  @override
  _AddTaskTileState createState() => _AddTaskTileState();
}

class _AddTaskTileState extends State<AddTaskTile> {
  final tasksState = getIt.get<TasksState>();
  TextEditingController _textEditingController;
  FocusNode _editingFocus;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _editingFocus = FocusNode();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextField(
        focusNode: _editingFocus,
        controller: _textEditingController,
        decoration: InputDecoration.collapsed(hintText: 'New Task...'),
      ),
      trailing: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          _editingFocus.unfocus();
          tasksState.tasks.change(
            (tasks) => tasks
              ..insert(
                0,
                Task(
                  task: _textEditingController.text,
                  completed: false,
                  id: DateTime.now().millisecondsSinceEpoch,
                ),
              ),
          );
          _textEditingController.text = '';
        },
      ),
    );
  }
}
