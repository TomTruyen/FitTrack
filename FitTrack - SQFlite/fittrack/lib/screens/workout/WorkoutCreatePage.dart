import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fittrack/models/workout/WorkoutChangeNotifier.dart';
import 'package:fittrack/screens/exercises/ExercisesPage.dart';
import 'package:fittrack/shared/Functions.dart';
import 'package:fittrack/shared/Loader.dart';

class WorkoutCreatePage extends StatefulWidget {
  @override
  _WorkoutCreatePageState createState() => _WorkoutCreatePageState();
}

class _WorkoutCreatePageState extends State<WorkoutCreatePage> {
  @override
  Widget build(BuildContext context) {
    WorkoutChangeNotifier workout =
        Provider.of<WorkoutChangeNotifier>(context) ?? null;

    return workout == null
        ? Loader()
        : Scaffold(
            body: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.grey[50],
                  floating: true,
                  pinned: true,
                  title: Text(
                    'Create Workout',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  leading: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      tryPopContext(context);
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Text(
                    'Current selected exercise count: ${workout.exercises.length}',
                  ),
                ),
                SliverToBoxAdapter(
                  child: Text(
                    'Make the create workout page here, for each exercise use \'Cards\' widget',
                  ),
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add_outlined),
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (_) => ExercisesPage(
                      isSelectActive: true,
                      workout: workout,
                    ),
                  ),
                );
              },
            ),
          );
  }
}
