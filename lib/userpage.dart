import 'dart:collection';

import 'package:fap3/wordCard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'PersonalizationPage.dart';
import 'common/DatabaseManager.dart';
import 'common/UserProvider.dart';
import 'common/constVariable.dart';
import 'followPage.dart';
import 'package:provider/provider.dart';

import 'myBottomNavigationBar.dart';
import 'my_dialog.dart';
import 'utils.dart';

class UserPage extends StatefulWidget {
  final DatabaseManager dbManager;

  const UserPage({super.key, required this.dbManager});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
    initializeEventSource();
  }
  Future<LinkedHashMap<DateTime, List<String>>>? kEventsFuture;
  LinkedHashMap<DateTime, List<String>>? kEvents;

  void initializeEventSource() {
    kEventsFuture = widget.dbManager.readAllEventIn(constUsername).then((eventSource) {
      return createEventsMap(isSameDay, getHashCode, eventSource);
    }).catchError((error) {
      print("Failed to initialize KeventSource: $error");
    });
  }

  List<String> getEventsForDay(DateTime day) {
    return kEvents?[day] ?? [];
  }
  final ColorProvider _colorProvider = ColorProvider();

  @override
  Widget build(BuildContext context) {
    CalendarFormat calendarFormat = CalendarFormat.month;
    DateTime focusedDay = DateTime.now();
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider()),
          ChangeNotifierProvider(create: (context) => _colorProvider),
        ],
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider.value(
                    value: _colorProvider,
                    child: const PersonalizationPage(),
                  ),
                ),
              );
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          body: Stack(
            children: [
              // 背景
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Consumer<ColorProvider>(
                    builder: (context, colorProvider, _) {
                      return Container(
                        height: 220,
                        color: colorProvider.getContainerColor(), // 顶部矩形颜色
                      );
                    },
                  )),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 440,
                  decoration: const BoxDecoration(
                    color: Colors.white, // 底部矩形颜色
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20), // 左上角圆角
                      topRight: Radius.circular(20), // 右上角圆角
                    ),
                  ),
                ),
              ),
              // 头像
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(currentUser!.imageUrl),
                    ),
                  ),
                ),
              ),
              // 查看好友列表
              Positioned(
                top: 150,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFDEFC9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // 将圆角半径设置为10
                      ),
                    ),
                    onPressed: () {
                      widget.dbManager.findAllFollow(currentUser.name).then((followList) {
                        if (kDebugMode) {
                          print(followList);
                        } // 输出followList内容
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FollowPage(followList: followList),
                          ),
                        );
                      }).catchError((error) {
                        // 处理错误情况
                      });
                    },
                    child: const Text('查看好友列表'),
                  ),
                ),
              ),
              // 日历
              Positioned(
                  top: 220,
                  left: 0,
                  right: 0,
                  child: FutureBuilder(
                      future: kEventsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(child: Text('加载数据出错'));
                        }
                        kEvents = snapshot.data;
                        return SizedBox(
                          child: TableCalendar<String>(
                            // shouldFillViewport:true,
                            calendarStyle:const CalendarStyle(
                             cellMargin : EdgeInsets.only(top:6.0),
                             // cellPadding:EdgeInsets.only(top:6.0),
                            ),
                            headerVisible:false,
                            rowHeight:33,
                            firstDay: kFirstDay,
                            lastDay: kLastDay,
                            focusedDay: focusedDay,
                            calendarFormat: calendarFormat,
                            eventLoader: getEventsForDay,
                            startingDayOfWeek: StartingDayOfWeek.monday,
                          ),
                        );
                      },
                    ),
              ),
              Positioned(
                  top: 405,
                  left: 100,
                  right: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.dbManager.addOneCheckIn(constUsername, kToday, "签到").then((value) => !value ? showErrorMessageDialog(context,"你已经签过到了"):null );
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        const StadiumBorder(),
                      ),
                    ),
                    child: const Text("签到"),
                  )),
              // 小树和单词卡片
              Positioned(
                  top: 460,
                  left: 0,
                  right: 0,
                  child: SingleChildScrollView(
                    child: Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAE094), // 设置背景色为FAE094
                            borderRadius:
                                BorderRadius.circular(10), // 设置圆角半径为10
                          ),
                          padding: const EdgeInsets.all(8),
                          // 设置内边距为8
                          child: IconButton(
                            icon: const Icon(Icons.local_florist),
                            onPressed: () {
                              // 进入小树界面
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: 150,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3C4C5), // 设置背景色为F3C4C5
                            borderRadius:
                                BorderRadius.circular(10), // 设置圆角半径为10
                          ),
                          padding: const EdgeInsets.all(8),
                          // 设置内边距为8
                          child: IconButton(
                            icon: const Icon(Icons.collections_bookmark),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const WordCard(key:ValueKey("WordCard"))),
                                );
                              }
                          ),
                        ),
                      ],
                    )),
                  )),
              // 关于我们
              Positioned(
                top: 525,
                left: 0,
                right: 0,
                child: Container(
                  height: 180,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ListView(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // 执行“关于我们”操作
                        },
                        child: const Text('关于我们'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // 执行“问题反馈”操作
                        },
                        child: const Text('问题反馈'),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          bottomNavigationBar: MyBottomNavigationBar(dbManager: widget.dbManager),
        )
    );
  }
}
