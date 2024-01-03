import 'package:fap3/gamepagelevel/gamepagelevel1.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'common/DatabaseManager.dart';
import 'common/UserProvider.dart';
import 'myBottomNavigationBar.dart';

class GamePage extends StatefulWidget {
  final DatabaseManager dbManager;

  const GamePage({super.key, required this.dbManager});
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<int> scores;
  int currentPage = 1;
  Map<int, String> buttonImages = {
    1: 'a',
    2: 'b',
    3: 'c',
    4: 'd'
  };
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  void nextPage() {
    setState(() {
      if (currentPage < 5) {
        currentPage += 1;
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('恭喜'),
            content: const Text('您已经达到巅峰，没有更多的地图了'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('好的'),
              ),
            ],
          ),
        );
      }
    });
  }
  void previousPage() {
    setState(() {
      if (currentPage > 1) {
        currentPage -= 1;
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('警告'),
            content: const Text('不要往下翻啦，这已经是最简单的地图'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('好的'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;
    String mapImageName = 'assets/map/map_$currentPage.png';
    List<int?> currentLevelStarNum = List.filled(6, 0);

    return Scaffold(
      body: Stack(
        children: [
          Lottie.asset(
            'assets/gamemap_bg.json',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            repeat: true,
          ),
          Image.asset(
            mapImageName,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                nextPage();
              },
              child: Text('切换地图${currentPage + 1}'),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                previousPage();
              },
              child: Text('切换地图${currentPage - 1}'),
            ),
          ),
        // 六个进入关卡按钮
          Stack(
            children: [
              // 按钮1
              Positioned(
                left: 180, // 按钮左边距离屏幕左侧的距离
                bottom: 30,
                child: FutureBuilder(
                  future: widget.dbManager.getUserCurrentLevelStarNum(currentUser!.name,1),
                  builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
                    if (snapshot.hasData) {
                      // 将结果赋值给临时变量
                      if(snapshot.data!=0){
                        currentLevelStarNum[0] = (snapshot.data! + 1);
                      }
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Gamepagelevel1(dbManager: widget.dbManager, currentLevel: 1,))
                          );
                        },
                        child: SizedBox(
                          height: 100,
                          width:  100,
                          child: Image.asset(
                          'assets/btn/btn1/${snapshot.data!+1}.png',
                        ),
                        )

                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
              //按钮 2
              Positioned(
                left: 150, // 按钮左边距离屏幕左侧的距离
                bottom: 160,
                child: FutureBuilder(
                  future: widget.dbManager.getUserCurrentLevelStarNum(currentUser.name,2),
                  builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
                    if (snapshot.hasData) {
                      // print(snapshot.data);
                      // 将结果赋值给临时变量
                      if(snapshot.data!>0){
                        currentLevelStarNum[1] = (snapshot.data! + 1);
                      }
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Gamepagelevel1(dbManager: widget.dbManager, currentLevel: 2,))
                            );
                          },
                          child: SizedBox(
                            height: 100,
                            width:  100,
                            child: Image.asset(
                              'assets/btn/btn2/${snapshot.data!+1}.PNG',
                            ),
                          )

                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
              //按钮 3
              Positioned(
                left: 125, // 按钮左边距离屏幕左侧的距离
                bottom: 300,
                child: FutureBuilder(
                  future: widget.dbManager.getUserCurrentLevelStarNum(currentUser.name,3),
                  builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
                    if (snapshot.hasData) {
                      // print(snapshot.data);
                      // 将结果赋值给临时变量
                      if(snapshot.data!=0){
                        currentLevelStarNum[2] = (snapshot.data! + 1);
                      }
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Gamepagelevel1(dbManager: widget.dbManager, currentLevel: 3,))
                            );
                          },
                          child: SizedBox(
                            height: 100,
                            width:  100,
                            child: Image.asset(
                              'assets/btn/btn3/${snapshot.data!+1}.PNG',
                            ),
                          )

                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
              //按钮 4
              Positioned(
                left: 245, // 按钮左边距离屏幕左侧的距离
                bottom: 380,
                child: FutureBuilder(
                  future: widget.dbManager.getUserCurrentLevelStarNum(currentUser.name,4),
                  builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
                    if (snapshot.hasData) {
                      // 将结果赋值给临时变量
                      if(snapshot.data!=0){
                        currentLevelStarNum[3] = (snapshot.data! + 1);
                      }
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Gamepagelevel1(dbManager: widget.dbManager, currentLevel: 4,))
                            );
                          },
                          child: SizedBox(
                            height: 120,
                            width:  120,
                            child: Image.asset(
                              'assets/btn/btn4/${snapshot.data!+1}.PNG',
                            ),
                          )

                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
              //按钮 5
              Positioned(
                left: 260, // 按钮左边距离屏幕左侧的距离
                bottom: 500,
                child: FutureBuilder(
                  future: widget.dbManager.getUserCurrentLevelStarNum(currentUser.name,5),
                  builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
                    if (snapshot.hasData) {
                      if(snapshot.data!=0){
                        currentLevelStarNum[4] = (snapshot.data! + 1);
                      }
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Gamepagelevel1(dbManager: widget.dbManager, currentLevel: 5,))
                            );
                          },
                          child: SizedBox(
                            height: 100,
                            width:  100,
                            child: Image.asset(
                              'assets/btn/btn5/${snapshot.data!+1}.PNG',
                            ),
                          )

                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
              //按钮 6
              Positioned(
                left: 100, // 按钮左边距离屏幕左侧的距离
                bottom: 560,
                child: FutureBuilder(
                  future: widget.dbManager.getUserCurrentLevelStarNum(currentUser.name,6),
                  builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
                    if (snapshot.hasData) {
                      if(snapshot.data!=0){
                        currentLevelStarNum[5] = (snapshot.data! + 1);
                      }
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Gamepagelevel1(dbManager: widget.dbManager, currentLevel: 6,))
                            );
                          },
                          child: SizedBox(
                            height: 120,
                            width:  120,
                            child: Image.asset(
                              'assets/btn/btn6/${snapshot.data! + 1}.PNG',
                            ),
                          )

                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(dbManager: widget.dbManager),
    );
  }
}


