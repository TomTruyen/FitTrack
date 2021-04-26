// Flutter Packages
import 'package:fittrack/services/Database.dart';
import 'package:flutter/material.dart';

// PubDev Packages

// My Packages
import 'package:fittrack/model/exercise/ExerciseFilter.dart';
import 'package:fittrack/model/workout/WorkoutChangeNotifier.dart';
import 'package:fittrack/pages/exercise/ExercisePage.dart';
import 'package:fittrack/misc/workouts/WorkoutExerciseBuilder.dart';
import 'package:fittrack/misc/Functions.dart';
import 'package:fittrack/shared/Globals.dart' as globals;
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';
import 'package:fittrack/shared/Snackbars.dart';

class WorkoutEditPage extends StatefulWidget {
  final Function refreshWorkouts;

  WorkoutEditPage({this.refreshWorkouts});

  @override
  _WorkoutEditPageState createState() => _WorkoutEditPageState();
}

class _WorkoutEditPageState extends State<WorkoutEditPage> {
  WorkoutChangeNotifier workout;
  ExerciseFilter exerciseFilter;

  @override
  Widget build(BuildContext context) {
    final WorkoutChangeNotifier _workout =
        Provider.of<WorkoutChangeNotifier>(context);
    final ExerciseFilter _exerciseFilter = Provider.of<ExerciseFilter>(context);

    if (workout == null && _workout != null) {
      workout = _workout;
    }

    if (exerciseFilter == null && _exerciseFilter != null) {
      exerciseFilter = _exerciseFilter;
    }

    return _WorkoutEditPageView(this);
  }
}

class _WorkoutEditPageView extends StatelessWidget {
  final _WorkoutEditPageState state;

  _WorkoutEditPageView(this.state);

  @override
  Widget build(BuildContext context) {
    final WorkoutChangeNotifier _workout = state.workout;
    final ExerciseFilter _exerciseFilter = state.exerciseFilter;

    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              forceElevated: true,
              floating: true,
              pinned: true,
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  popContextWhenPossible(context);
                },
              ),
              title: Text('Edit workout'),
              actions: [
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () async {
                    if (_workout.exercises.length > 0) {
                      if (_workout.weightUnit != globals.settings.weightUnit) {
                        // Check if value was changed (if not convert to new weightUnit when needed)
                        _workout.exercises.forEach((_exercise) {
                          _exercise.sets.forEach((_set) {
                            if (!_set.isEdited) {
                              _set.weight = recalculateWeights(
                                _set.weight,
                                globals.settings.weightUnit,
                              );
                            }
                          });
                        });

                        _workout.weightUnit = globals.settings.weightUnit;
                      }

                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      ScaffoldMessenger.of(context)
                          .showSnackBar(savingSnackbar);

                      bool isSaved = await Database(uid: globals.uid)
                          .editWorkout(_workout, globals.workouts);

                      if (isSaved) {
                        await state.widget.refreshWorkouts();

                        ScaffoldMessenger.of(context).hideCurrentSnackBar();

                        ScaffoldMessenger.of(context)
                            .showSnackBar(saveSuccessSnackbar);

                        Future.delayed(
                          Duration(milliseconds: 1500),
                          () {
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                            popContextWhenPossible(context);
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();

                        ScaffoldMessenger.of(context)
                            .showSnackBar(saveFailSnackbar);
                      }
                    }
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  autofocus: false,
                  initialValue: _workout.name,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Workout Name',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    _workout.updateName(value);
                  },
                ),
              ),
            ),
            ReorderableSliverList(
              delegate: ReorderableSliverChildListDelegate([
                for (int i = 0; i < _workout.exercises.length; i++)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: buildWorkoutExercises(
                      context,
                      _workout,
                      i,
                      globals.exerciseFilter,
                      true,
                    ),
                    key: UniqueKey(),
                  )
              ]),
              onReorder: (int oldIndex, int newIndex) {
                _workout.moveListItem(oldIndex, newIndex);
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _exerciseFilter.clearFilters();

          _workout.backupExercises = [..._workout.exercises];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExercisePage(
                isSelectActive: true,
              ),
            ),
          );
        },
      ),
    );
  }
}
