import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:simplicity/main.dart';
import 'package:simplicity/state/settings_state.dart';
import 'package:simplicity/state/tasks_state.dart';
import 'package:simplicity/widgets/android/add_task_tile.dart';
import 'package:simplicity/widgets/ios/task_tile_ios.dart';
import 'package:simplicity/widgets/android/task_tile.dart';

import 'package:flutter_observable_state/flutter_observable_state.dart';

class HomePage extends StatelessWidget {
  final settingsState = getIt.get<SettingsState>();
  final tasksState = getIt.get<TasksState>();

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: observe(
          () => CustomScrollView(
                slivers: <Widget>[
                  CupertinoSliverNavigationBar(
                    largeTitle: Text('Tasks'),
                    trailing: CupertinoButton(
                      child: Icon(Icons.lightbulb_outline),
                      onPressed: () => settingsState.darkmode.change((darkmode) => darkmode = !darkmode),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => TaskTileIOS(task: tasksState.tasks.get().elementAt(index)),
                      childCount: tasksState.tasks.get().length,
                    ),
                  ),
                ],
              ),
        ),
      );
    }
    return Scaffold(
      body: observe(
        () => CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: 150,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text('Tasks'),
                    centerTitle: true,
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.lightbulb_outline),
                      onPressed: () => settingsState.darkmode.change((darkmode) => darkmode = !darkmode),
                    )
                  ],
                ),
                SliverToBoxAdapter(
                  child: AddTaskTile(),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => TaskTile(tasksState.tasks.get().elementAt(index)),
                    childCount: tasksState.tasks.get().length,
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
