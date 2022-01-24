// Flutter Packages
import 'package:flutter/material.dart';

// My Packages
import 'package:fittrack/misc/Functions.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

Future<void> showPopupWeightUnit(
  BuildContext context,
  Function refreshSettings,
  Function updateSettingsState,
) async {
  String weightUnit = globals.settings.weightUnit;

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 250.0,
                maxHeight: MediaQuery.of(context).size.height * 0.80,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[50],
                border: Border.all(
                  width: 0,
                ),
              ),
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
              child: SingleChildScrollView(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Color.fromRGBO(70, 70, 70, 1),
                    unselectedWidgetColor: Color.fromRGBO(
                      200,
                      200,
                      200,
                      1,
                    ),
                  ),
                  child: Material(
                    color: Colors.grey[50],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Weight Unit',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        InkWell(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Radio(
                                    value: 'kg',
                                    groupValue: weightUnit,
                                    onChanged: (String value) {
                                      setState(() {
                                        weightUnit = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    'Metric (kg)',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              weightUnit = 'kg';
                            });
                          },
                        ),
                        InkWell(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Radio(
                                    groupValue: weightUnit,
                                    value: 'lbs',
                                    onChanged: (String value) {
                                      setState(() {
                                        weightUnit = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    'Imperial (lbs)',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              weightUnit = 'lbs';
                            });
                          },
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
                            onPressed: () async {
                              globals.settings.weightUnit = weightUnit;

                              globals.settings.weightHistory.forEach((weight) {
                                if (weight['weightUnit'] != weightUnit) {
                                  weight['weightUnit'] = weightUnit;
                                  weight['weight'] = recalculateWeights(
                                    double.parse(weight['weight'].toString()),
                                    weightUnit,
                                  );
                                }
                              });

                              if (globals.settings.weightGoal.weightUnit !=
                                  weightUnit) {
                                globals.settings.weightGoal.goal =
                                    recalculateWeights(
                                  globals.settings.weightGoal.goal,
                                  weightUnit,
                                );
                                globals.settings.weightGoal.weightUnit =
                                    weightUnit;
                              }

                              updateSettingsState();
                              popContextWhenPossible(context);
                            },
                          ),
                        ),
                      ],
                    ),
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