import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() => runApp(CountdownApp());

class CountdownApp extends StatefulWidget {
  @override
  _CountdownAppState createState() => _CountdownAppState();
}

class _CountdownAppState extends State<CountdownApp>
    with SingleTickerProviderStateMixin {
  int _countdown = 10;
  bool _isFlashing = false;
  late AnimationController _flashController;

  @override
  void initState() {
    super.initState();
    _flashController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _flashController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isFlashing = false;
        });
      }
    });
  }

  void startCountdown() {
    setState(() {
      _countdown = 10;
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isFlashing = true;
          _flashController.forward(from: 0.0);
          _countdown = 10;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: GestureDetector(
            onDoubleTap: () {
              startCountdown();
            },
            child: Stack(
              children: [
                Center(
                  child: Text(
                    '$_countdown',
                    style: const TextStyle(fontSize: 310, color: Colors.white),
                  ),
                ),
                if (_isFlashing)
                  ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.modulate,
                    ),
                    child: SizedBox.expand(
                      child: AnimatedBuilder(
                        animation: _flashController,
                        builder: (context, child) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(
                                1 - _flashController.value,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }
}
