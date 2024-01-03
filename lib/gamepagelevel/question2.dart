import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../common/UserProvider.dart';
import '../common/constVariable.dart';
import '../my_dialog.dart';
import '../user.dart';

class Question2 extends StatefulWidget {
  final Function goToNextPage;
  final Function updateScoreAndStar;
  final Function() currentTimeCallback;
  final int currentLevel;

  const Question2({super.key, required this.goToNextPage, required this.updateScoreAndStar, required this.currentTimeCallback, required this.currentLevel});

  @override
  _Question2State createState() => _Question2State();
}
class MyPair {
  int intValue;
  String stringValue;

  MyPair(this.intValue, this.stringValue);
}
class _Question2State extends State<Question2> {
  int questionScore = 0;
  int failNum = 0;
  bool ifBeginFindAnswer = false;
  int correctNum = 0;
  List correctValues = [];

  MyPair selectedMap = MyPair(0, "f");
  late Map<int, String> correctMap;
  int currentQuestionIndex = 2;

  @override
  void initState() {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    currentQuestionIndex = 2 + 3 * (widget.currentLevel - 1);
    correctMap = allCorrectMap[widget.currentLevel-1]!;
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
      num Time = 60 - widget.currentTimeCallback();
      setState(() {
        if (Time <= 5) {
          questionScore = 100;
        } else {
          questionScore = max(20, 100 - 3 * failNum - 2 * (Time.toInt() - 5));
        }
      });
      widget.updateScoreAndStar(questionScore,currentUser);
      widget.goToNextPage();
  }

  void selectQuestion(int value,User currentUser) {
    selectedMap.intValue = value;
    if(selectedMap.stringValue!="f" && selectedMap.intValue!= 0) {
      checkAnswer(currentUser);
    }
  }
  void selectAnswer(String value,User currentUser) {
    selectedMap.stringValue  = value;
    if(selectedMap.stringValue!="f" && selectedMap.intValue!= 0)
    {
      checkAnswer(currentUser);
    }
  }

  void checkAnswer(User currentUser) {
    if (correctMap.containsKey(selectedMap.intValue) && correctMap[selectedMap.intValue] == selectedMap.stringValue) {
      setState(() {
        correctNum++;
      });
      if(correctNum==5){
        submitAnswer(currentUser);
      }
      correctValues.add(selectedMap.intValue);
      correctValues.add(selectedMap.stringValue);
      selectedMap = MyPair(0, "f");
    }else{
      showSelectDialog(context,"You wrong");
      setState(() {
        failNum++;
      });
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
              image: AssetImage('assets/questionBg_2.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: FloatingActionButton(
              child: Image.asset('assets/submitAnswer.png'),
              onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                widget.goToNextPage();
              });
            },
          ),
        ),
        // 上面一排的文字question
        ...List.generate(5, (index) {
          int questionIndex = index + 1;
          return Positioned(
            bottom: 220,
            left: 40 + index * 130,
            child: GestureDetector(
              onTap: () {
                selectQuestion(questionIndex,currentUser!);
              },
              child: Visibility(
                visible: !correctValues.contains(questionIndex),
                child: IgnorePointer(
                  ignoring: selectedMap.intValue == questionIndex,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedMap.intValue == questionIndex ? Colors.red : Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                    child: Image.asset('assets/question$currentQuestionIndex/q$questionIndex.png'),
                  ),
                ),
              ),
            ),
          );
        }),
        // 下面一排的图片answer
        ...List.generate(5, (index) {
          String answerLetter = String.fromCharCode(97 + index);
          return Positioned(
            bottom: 100,
            left: 40 + index * 130,
            child: GestureDetector(
              onTap: () {
                selectAnswer(answerLetter,currentUser!);
              },
              child: Visibility(
                visible: !correctValues.contains(answerLetter),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedMap.stringValue == answerLetter ? Colors.green : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                  child: Image.asset('assets/question$currentQuestionIndex/a${index + 1}.png'),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
