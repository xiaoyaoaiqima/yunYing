import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Question3 extends StatefulWidget {
  final Function goToNextPage;
  final Function updateScoreAndStar;
  final Function() currentTimeCallback;

  const Question3({super.key, required this.goToNextPage, required this.updateScoreAndStar, required this.currentTimeCallback});

  @override
  _Question3State createState() => _Question3State();
}

class _Question3State extends State<Question3> {
  bool ifRight = false;
  int questionScore = 0;
  String result = "";
  int failNum = 0;
  int listenTime = 0;
  bool frogState = true; // 青蛙状态

  Timer? _timer; // 计时器
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
// 初始化计时器
    _timer = Timer(const Duration(seconds: 5), () {
      setState(() {
        frogState = false;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // 销毁计时器
    super.dispose();
  }

  void resetTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 5), () {
      setState(() {
        frogState = false;
      });
    });
  }

  void submitAnswer() {
    if (result == "d") {
      setState(() {
        ifRight = true;
      });
      num Time = 60 - widget.currentTimeCallback();
      setState(() {
        if (Time <= 5) {
          questionScore = 100;
        } else {
          questionScore = max(20, 100 - 3 * failNum - 2 * (Time.toInt() - 5));
        }
      });
      widget.updateScoreAndStar(questionScore, ifRight);
      widget.goToNextPage();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Incorrect Answer'),
            content: const Text('Your answer is incorrect. Please try again.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    failNum++;
                  });
                  resetTimer();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/questionBg_3.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
// 喇叭
        Positioned(
          bottom: 208,
          left: 36,
          child: GestureDetector(
            onTap: () async {
              setState(() {
                listenTime++;
                frogState = true;
              });
              resetTimer();
              await player.play(AssetSource('sounds/au1.mp3'));
// 播放音频
              Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  frogState = false;
                });
              });
            },
            child: Image.asset(
              'assets/listenIcon.png',
              width: 80.0,
              height: 80.0,
            ),
          ),
        ),
// 青蛙
        Positioned(
          bottom: 150,
          left: 275,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: frogState
                ? Image.asset(
              'assets/frog${listenTime > 0 ? 2 : 3}.png',
              key: ValueKey<int>(listenTime),
              scale: 0.7,
            )
                : Image.asset(
              'assets/frog1.png',
              key: ValueKey<int>(listenTime),
              scale: 0.7,
            ),
          ),
        ),
// 提交按钮
        Positioned(
          bottom: 175,
          right: 55,
          child: FloatingActionButton(
            onPressed: submitAnswer,
            child: Image.asset('assets/submitAnswer.png'),
          ),
        ),
// 选项a
        Positioned(
          bottom: 70,
          left: 50,
          child: GestureDetector(
            onTap: () {
              setState(() {
                frogState = true;
                result = "a";
              });
              resetTimer();
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  frogState = false;
                });
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: result == "a" ? Colors.red : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Image.asset(
                'assets/question3/a1.png', // 假设这里是a选项
                scale: 0.8,
              ),
            ),
          ),
        ),
// 选项b
        Positioned(
          bottom: 70,
          left: 390,
          child: GestureDetector(
            onTap: () {
              setState(() {
                frogState = true;
                result = "b";
              });
              resetTimer();
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  frogState = false;
                });
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: result == "b" ? Colors.red : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Image.asset(
                'assets/question3/a2.png', // 假设这里是b选项
                scale: 0.8,
              ),
            ),
          ),
        ),
// 选项c
        Positioned(
          bottom: 20,
          left: 50,
          child: GestureDetector(
            onTap: () {
              setState(() {
                frogState = true;
                result = "c";
              });
              resetTimer();
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  frogState = false;
                });
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: result == "c" ? Colors.red : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Image.asset(
                'assets/question3/a3.png', // 假设这里是c选项
                scale: 0.8,
              ),
            ),
          ),
        ),
// 选项d
        Positioned(
          bottom: 20,
          left: 390.0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                frogState = true;
                result = "d";
              });
              resetTimer();
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  frogState = false;
                });
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: result == "d" ? Colors.red : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Image.asset(
                'assets/question3/a4.png', // 假设这里是d选项
                scale: 0.8,
              ),
            ),
          ),
        ),
      ],
    );
  }
}