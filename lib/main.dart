import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Ensure you have this import
import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart'; // Import the assets_audio_player package

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Timer',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.green),
      ),
      home: PomodoroTimer(),
    );
  }
}

class PomodoroTimer extends StatefulWidget {
  @override
  _PomodoroTimerState createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> with SingleTickerProviderStateMixin {
  static const int workTime = 10; // 10 seconds
  static const int breakTime = 5; // 5 seconds
  int remainingTime = workTime;
  bool isRunning = false;
  bool isWorkTime = true;
  Timer? timer;
  late AnimationController _controller;
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer(); // Initialize the AssetsAudioPlayer

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: workTime));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startTimer() {
    if (isRunning) return;
    setState(() {
      isRunning = true;
    });
    _controller.forward(from: _controller.value);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          isWorkTime = !isWorkTime;
          remainingTime = isWorkTime ? workTime : breakTime;
          isRunning = false;
          timer.cancel();
          _controller.stop();
          _controller.value = 1.0; // Finish the animation

          // Play the times up sound effect
          _assetsAudioPlayer.open(
            Audio('assets/animation/timesup.mp3'),
          );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NextPage()),
          );
        }
      });
    });
  }

  void stopTimer() {
    setState(() {
      isRunning = false;
      timer?.cancel();
      _controller.stop();
    });
  }

  void resetTimer() {
    setState(() {
      isRunning = false;
      timer?.cancel();
      remainingTime = isWorkTime ? workTime : breakTime;
      _controller.reset();
    });
  }

  // Function to play the button click sound
  void playButtonClickSound() {
    _assetsAudioPlayer.open(
      Audio('assets/animation/Tap.mp3'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Timer'),
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/animation/homescreen.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: Colors.yellow.withOpacity(0.5), // Optional overlay for better contrast
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Lottie.asset(
                    'assets/animation/cell.json',
                    controller: _controller,
                    onLoaded: (composition) {
                      _controller.duration = Duration(seconds: workTime); // Set duration to work time
                    },
                  ), // Lottie animation
                  SizedBox(height: 20),
                  Text(
                    isWorkTime ? 'Pomodoro Timer' : 'Time\'s Up!',
                    style: TextStyle(fontSize: 32),
                  ),
                  Text(
                    '${(remainingTime ~/ 60).toString().padLeft(2, '0')}:${(remainingTime % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 48),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          playButtonClickSound();
                          stopTimer();
                        },
                        child: Text('Stop'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange, // Background color
                          foregroundColor: Colors.white, // Text color
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          playButtonClickSound();
                          startTimer();
                        },
                        child: Text('Start'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Background color
                          foregroundColor: Colors.white, // Text color
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          playButtonClickSound();
                          resetTimer();
                        },
                        child: Text('Reset'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange, // Background color
                          foregroundColor: Colors.white, // Text color
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer(); // Initialize the AssetsAudioPlayer

  // Function to play the button click sound
  void playButtonClickSound() {
    _assetsAudioPlayer.open(
      Audio('assets/animation/Tap.mp3'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time\'s Up!'),
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/animation/homescreen.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: Colors.yellow.withOpacity(0.5), // Optional overlay for better contrast
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 400, // Set the desired width
                    height: 400, // Set the desired height
                    child: Lottie.asset(
                      'assets/animation/wiggle.json',
                      repeat: true, // Make the animation loop
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Time\'s Up!',
                    style: TextStyle(fontSize: 32),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      playButtonClickSound();
                      // Define your continue action here
                    },
                    child: Text('Continue'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Background color
                      foregroundColor: Colors.white, // Text color
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}