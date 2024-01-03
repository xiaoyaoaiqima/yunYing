import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../common/UserProvider.dart';
import '../common/constVariable.dart';
import '../user.dart';

class Question1 extends StatefulWidget {
  final Function goToNextPage;
  final Function updateScoreAndStar;
  final Function() currentTimeCallback;
  final int currentLevel;

  const Question1({super.key, required this.goToNextPage, required this.updateScoreAndStar, required this.currentTimeCallback, required this.currentLevel});

  @override
  _Question1State createState() => _Question1State();
}

class _Question1State extends State<Question1> {
  int questionScore = 0;
  String result = "";
  int failNum = 0;
  int currentQuestionIndex = 1;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    currentQuestionIndex = 1 + 3 * (widget.currentLevel - 1);
    super.initState();
  }
  @override
  void dispose() {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    super.dispose();
  }
  void submitAnswer(User currentUser) {
    if (result == resultQ1[widget.currentLevel - 1]) {
      num Time = 60 - widget.currentTimeCallback();
      setState(() {
        if(Time<=5){
          questionScore = 100;
        }else{
          questionScore = max(20, 100 - 3*failNum - 2*(Time.toInt()- 5));
        }

      });
      widget.updateScoreAndStar(questionScore,currentUser);
      widget.goToNextPage();
    }
    else {
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
              image: AssetImage('assets/questionBg_1.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // 题目
        Positioned(
            bottom: 100,
            right: 60,
            child: SizedBox(
              width: 600,
              child: Image.asset('assets/question$currentQuestionIndex/q1.png'),
            )
        ),
        // 选项a
        ...List.generate(
          optionsQ1.length,
              (index) => Positioned(
            bottom: q1AnswerButtonBottom,
            left: 80 + index * 120,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  result = optionsQ1[index];
                });
              },
              child: Container(
                width: q1AnswerButtonWidth,
                height: q1AnswerButtonHeight,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: result == optionsQ1[index]
                        ? Colors.blue
                        : Colors.transparent,
                    width: 2.0,
                  ),
                ),
                child: Image.asset('assets/question$currentQuestionIndex/a${index + 1}.png'),
              ),
            ),
          ),
        ),
        // 按钮
        Positioned(
          bottom: q1SubmitButtonBottom,
          left: q1SubmitButtonLeft,
          child: SizedBox(
            width: q1SubmitButtonWidth,
            height: q1SubmitButtonHeight,
            child: FloatingActionButton(
              child: Image.asset('assets/submitAnswer.png'),
              onPressed:() => submitAnswer(currentUser!),
            ),),
        ),
      ],
    );
  }
}