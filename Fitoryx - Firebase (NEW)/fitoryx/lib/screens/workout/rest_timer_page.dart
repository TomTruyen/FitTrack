import 'dart:async';

import 'package:fitoryx/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class RestTimerPage extends StatefulWidget {
  final int restSeconds;

  const RestTimerPage({Key? key, required this.restSeconds}) : super(key: key);

  @override
  State<RestTimerPage> createState() => _RestTimerPageState();
}

class _RestTimerPageState extends State<RestTimerPage>
    with TickerProviderStateMixin {
  late int _remaining;
  late Timer _timer;

  void _vibrate() async {
    bool? hasVibrate = await Vibration.hasVibrator();

    if (hasVibrate != null && hasVibrate) {
      Vibration.vibrate(duration: 1000);
    }
  }

  String get time {
    int minutes = _remaining ~/ 60;
    int seconds = _remaining % 60;

    if (_remaining <= 5 && _remaining % 2 != 0) {
      _vibrate();
    }

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_remaining == 0) {
        timer.cancel();

        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        return;
      }

      setState(() {
        _remaining--;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _remaining = widget.restSeconds;

    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.grey[50],
            floating: true,
            pinned: true,
            automaticallyImplyLeading: false,
            title: const Text(
              'Rest Timer',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: FractionalOffset.center,
              child: Align(
                alignment: FractionalOffset.center,
                child: Text(
                  time,
                  style: const TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        width: MediaQuery.of(context).size.width,
        child: GradientButton(
          text: 'Skip Rest',
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}