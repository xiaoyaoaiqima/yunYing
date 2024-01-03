import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:fap3/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../common/UserProvider.dart';
import '../common/constVariable.dart';

class Question3 extends StatefulWidget {
  final Function goToNextPage;
  final Function updateScoreAndStar;
  final Function() currentTimeCallback;
  final int currentLevel;

  const Question3(
      {super.key, required this.goToNextPage,
      required this.updateScoreAndStar,
      required this.currentTimeCallback,
        required this.currentLevel});

  @override
  _Question3State createState() => _Question3State();
}

enum FrogState { zero, normal, listening,sleep,  win }

class _Question3State extends State<Question3> {
  bool ifRight = false;
  int questionScore = 0;
  String result = "";
  int failNum = 0;
  int listenTime = 0;
  int frogstate = FrogState.normal.index;

  Timer? _timer; // 计时器
  final player = AudioPlayer();
  int currentQuestionIndex = 3;

  @override
  void initState() {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    currentQuestionIndex = 3 + 3 * (widget.currentLevel - 1);
    // 初始化计时器
    _timer = Timer(const Duration(seconds: 5), () {
      setState(() {
        frogstate = FrogState.sleep.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel(); // 销毁计时器
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }


  void resetTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 5), () {
      setState(() {
        frogstate = FrogState.sleep.index;
      });
    });
  }

  void submitAnswer(User currentUser) {
    if (result == resultQ3[widget.currentLevel-1]) {
      setState(() {
        ifRight = true;
        frogstate = FrogState.win.index;
      });
      num Time = 60 - widget.currentTimeCallback();
      setState(() {
        if (Time <= 5) {
          questionScore = 100;
        } else {
          questionScore = max(20, 100 - 2 * failNum -3* listenTime - 2 * (Time.toInt() - 5));
        }
      });
      widget.updateScoreAndStar(questionScore,currentUser);
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
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;
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
                frogstate = FrogState.listening.index;
              });
              await player.play(AssetSource('sounds/au${widget.currentLevel}.mp3'));
              // 播放音频
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  frogstate = FrogState.normal.index;
                  resetTimer();
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
            child: Image.asset(
              'assets/frog$frogstate.png',
              key: ValueKey<int>(frogstate),
              scale: 0.7,
            ),
          ),
        ),

        // 提交按钮
        Positioned(
          bottom: 175,
          right: 55,
          child: FloatingActionButton(
            child: Image.asset('assets/submitAnswer.png'),
              onPressed: () {
                submitAnswer(currentUser!);
              },
          ),
        ),
        // 选项a
        Positioned(
          bottom: 70,
          left: 50,
          child: GestureDetector(
            onTap: () {
              setState(() {
                result = "a";
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
                'assets/question$currentQuestionIndex/a1.png', // 假设这里是a选项
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
                result = "b";
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
                'assets/question$currentQuestionIndex/a2.png', // 假设这里是b选项
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
                result = "c";
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
                'assets/question$currentQuestionIndex/a3.png', // 假设这里是c选项
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
                result = "d";
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
                'assets/question$currentQuestionIndex/a4.png', // 假设这里是d选项
                scale: 0.8,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
