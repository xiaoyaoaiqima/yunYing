import 'dart:async';
import 'package:fap3/gamePage.dart';
import 'package:fap3/gamepagelevel/question1.dart';
import 'package:fap3/gamepagelevel/question2.dart';
import 'package:fap3/gamepagelevel/question3.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../common/DatabaseManager.dart';
import '../common/UserProvider.dart';
import '../user.dart';

class GameData {
  final int index;
  final int star_num;
  final int score_num;

  const GameData({
    required this.index,
    required this.star_num,
    required this.score_num,
  });
}

class Gamepagelevel1 extends StatefulWidget {
  final DatabaseManager dbManager;
  final int currentLevel;
  const Gamepagelevel1({super.key, required this.dbManager,required this.currentLevel});
  @override
  _Gamepagelevel1State createState() => _Gamepagelevel1State();
}

class _Gamepagelevel1State extends State<Gamepagelevel1> {
  int star_num = 0; // 星星数量
  int score_num = 0; // 得分
  int currentTime = 60; // 剩余时间
  int currentLevelQuestionIndex = 1;// 当前题目编号 1-3
  int currentQuestionIndex = 1;  //总题目编号 1-18
  int fail_num = 0; // 失败次数
  Timer? timer; // 计时器


  int getCurrentTime() {
    return currentTime; // 返回当前的currentTime
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    currentQuestionIndex = 1 + 3 * widget.currentLevel;
    // initData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (currentTime > 0) {
        setState(() {
          currentTime--;
        });
      } else {
        timer.cancel();
        showTimeUpDialog();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Time Up'),
          content: const Text('Time is up. Do you want to retry or exit?'),
          actions: [
            TextButton(
              child: const Text('Retry'),
              onPressed: () {
                Navigator.of(context).pop();
                retryCurrentQuestion();
              },
            ),
            TextButton(
              child: const Text('Exit'),
              onPressed: () {
                // Navigator.of(context).pop();
                exitChallenge();
              },
            ),
          ],
        );
      },
    );
  }

  void retryCurrentQuestion() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16.0),
                Text('Loading...'),
              ],
            ),
          ),
        );
      },
    );
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop(); // 修改此处
      // Reload the question page here
    }).then((_) {
      setState(() {
        fail_num++;
        currentTime = 60;
        startTimer();
      });
    });
  }

  void exitChallenge() {
    Navigator.pop(context, star_num);
  }

  void goToNextPage() {
    timer?.cancel();
    if (currentLevelQuestionIndex < 3) {
      // 假设总共有3道题目
      setState(() {
        currentLevelQuestionIndex++;
        currentTime = 60;
        startTimer();
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Congratulations'),
            content: const Text('You have completed all questions.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => GamePage(dbManager: widget.dbManager)),
                  );
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(body: buildGamePage());
  }


  void updateScoreAndStar(int score, User currentUser) {
    setState(() {
      score_num += score; // 假设每道题目满分为100
      star_num = star_num + 1;
    });
    //更新数据库操作
    widget.dbManager.changeUserLevelIndexStarAndScoreNum(currentUser.name,widget.currentLevel,star_num,score_num);
  }

  Widget buildGamePage() {
    return Stack(
      children: [
        Positioned.fill(child: buildQuestion(currentLevelQuestionIndex)), // 展现题目内容
        buildHeader(),
        buildStars()
      ],
    );
  }

  Widget buildHeader() {
    return Positioned(
      top: 2,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildTimer(),
          // buildStars(),
          buildScoreProgressBar(),
          buildExitButton(),
        ],
      ),
    );
  }

  Widget buildTimer() {
    return Row(
      children: [
        const Icon(Icons.timer),
        // 计时器图标
        Text(' $currentTime', style: const TextStyle(fontWeight: FontWeight.bold))
        // 计时器数字
      ],
    );
  }

  Widget buildStars() {
    return Positioned(
      top: 40,
      left: 300,
      child: Align(
        alignment: Alignment.center,
        child: Image.asset(
          getStarImagePath(currentLevelQuestionIndex),
          width: 120,
          height: 35,
        ),
      ),
    );
  }


  Widget buildExitButton() {
    return IconButton(
      icon: const Icon(Icons.exit_to_app),
      onPressed: () => exitChallenge(),
    );
  }

  Widget buildScoreProgressBar() {
    return
     Align(
        alignment: Alignment.center,
        child: Container(
          width: 300,
          height: 20,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFB96721), width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: LinearProgressIndicator(
            value: score_num / 300.0,
            backgroundColor: Colors.white,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF3C4C5)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

  }

  String getStarImagePath(int index) {
    switch (index) {
      case 1:
        return 'images/0_star.png';
      case 2:
        return 'images/1_star.png';
      case 3:
        return 'images/2_star.png';
      default:
        return 'images/0_star.png';
    }
  }

  Widget buildQuestion(int currentLevelQuestionIndex) {
    switch (currentLevelQuestionIndex) {
      case 1:
        return Question1(
          goToNextPage: goToNextPage,
          updateScoreAndStar: updateScoreAndStar,
          currentTimeCallback: getCurrentTime,
          currentLevel: widget.currentLevel,
        );
      case 2:
        return Question2(
          goToNextPage: goToNextPage,
          updateScoreAndStar: updateScoreAndStar,
          currentTimeCallback: getCurrentTime,
          currentLevel: widget.currentLevel,
        );
      case 3:
        return Question3(
          goToNextPage: goToNextPage,
          updateScoreAndStar: updateScoreAndStar,
          currentTimeCallback: getCurrentTime,
          currentLevel: widget.currentLevel,
        );
      default:
        return Container(); // 处理无效的currentLevelQuestionIndex
    }
  }
}
