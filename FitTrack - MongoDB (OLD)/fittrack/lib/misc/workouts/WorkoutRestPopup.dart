// Flutter Packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// My Packages
import 'package:fittrack/model/workout/WorkoutChangeNotifier.dart';
import 'package:fittrack/model/workout/WorkoutExercise.dart';
import 'package:fittrack/misc/Functions.dart';

Future<void> showRestDialog(
  BuildContext context,
  WorkoutChangeNotifier workout,
  WorkoutExercise currentExercise,
) async {
  bool currentExerciseRestEnabled = currentExercise.restEnabled ?? true;
  int currentExerciseRestSeconds = currentExercise.restSeconds ?? 60;

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, StateSetter setState) {
          return Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 1.5,
                maxHeight: MediaQuery.of(context).size.height * 0.80,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[50],
                border: Border.all(
                  width: 0,
                ),
              ),
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 8.0),
              child: SingleChildScrollView(
                child: Material(
                  color: Colors.grey[50],
                  child: ListBody(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Enabled',
                            ),
                          ),
                          Spacer(flex: 2),
                          Expanded(
                            child: Switch(
                              value: currentExerciseRestEnabled,
                              onChanged: (bool value) {
                                setState(() {
                                  currentExerciseRestEnabled = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16.0),
                        height: 100.0,
                        child: Opacity(
                          opacity: currentExerciseRestEnabled ? 1 : 0.5,
                          child: AbsorbPointer(
                            absorbing: !currentExerciseRestEnabled,
                            child: CupertinoPicker(
                              scrollController: FixedExtentScrollController(
                                initialItem:
                                    (currentExercise.restSeconds ~/ 5) - 1,
                              ),
                              squeeze: 1.0,
                              looping: true,
                              diameterRatio: 100.0,
                              itemExtent: 40.0,
                              onSelectedItemChanged: (int index) {
                                int seconds = 5 + (index * 5);

                                currentExerciseRestSeconds = seconds;
                              },
                              useMagnifier: true,
                              magnification: 1.5,
                              children: <Widget>[
                                for (int i = 5; i <= 300; i += 5)
                                  Center(
                                    child: Text(
                                      '${(i / 60).floor()}:${(i % 60).toString().padLeft(2, "0")}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          child: Text(
                            'OK',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            currentExercise.restEnabled =
                                currentExerciseRestEnabled;
                            currentExercise.restSeconds =
                                currentExerciseRestSeconds;

                            popContextWhenPossible(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
