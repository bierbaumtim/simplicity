import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:simplicity/model/task.dart';
import 'package:simplicity/pages/homepage.dart';
import 'package:simplicity/state/settings_state.dart';
import 'package:simplicity/state/tasks_state.dart';

import 'package:flutter_observable_state/flutter_observable_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

final getIt = GetIt.instance;

void main() {
  getIt.registerSingleton(SettingsState());
  getIt.registerSingleton(TasksState());
  runApp(SimplicityApp());
}

class SimplicityApp extends StatefulWidget {
  @override
  _SimplicityAppState createState() => _SimplicityAppState();
}

class _SimplicityAppState extends State<SimplicityApp> {
  final settingsState = getIt.get<SettingsState>();
  final tasksState = getIt.get<TasksState>();
  StreamSubscription _tasksStreamSubscription, _settingsStreamSubscription;

  @override
  void initState() {
    super.initState();
    loadTasks();
    loadSettings();
  }

  @override
  void dispose() {
    _tasksStreamSubscription.cancel();
    _settingsStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return observe(
        () => CupertinoApp(
              home: HomePage(),
              theme: settingsState.darkmode.get()
                  ? CupertinoThemeData(brightness: Brightness.dark)
                  : CupertinoThemeData(brightness: Brightness.light),
            ),
      );
    }
    return observe(
      () => MaterialApp(
            home: HomePage(),
            theme: settingsState.darkmode.get() ? ThemeData.dark() : ThemeData.light(),
          ),
    );
  }

  Future<void> loadTasks() async {
    final dir = await getApplicationDocumentsDirectory();
    var file = File(join(dir.path, 'tasks.json'));
    if (!await file.exists()) {
      file = await File(join(dir.path, 'tasks.json')).create();
    }
    final tasksJson = await file.readAsString();
    debugPrint(tasksJson);
    final List<Task> tasks =
        tasksJson.isNotEmpty ? jsonDecode(tasksJson).map<Task>((t) => Task.fromJson(t)).toList() : <Task>[];
    tasksState.tasks.set(tasks);

    _tasksStreamSubscription = tasksState.tasks.$stream.listen((tasks) async {
      final dir = await getApplicationDocumentsDirectory();
      var file = File(join(dir.path, 'tasks.json'));
      if (!await file.exists()) {
        file = await File(join(dir.path, 'tasks.json')).create();
      }
      file.writeAsString(jsonEncode(tasks));
    });
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final darkmode = prefs.getBool('darkmode') ?? true;
    settingsState.darkmode.set(darkmode);
    _settingsStreamSubscription = settingsState.darkmode.$stream.listen((darkmode) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('darkmode', darkmode);
    });
  }
}
