import 'package:fap3/common/DatabaseManager.dart';
import 'package:fap3/homepage.dart';
import 'package:fap3/userpage.dart';
import 'gamePage.dart';
import 'package:flutter/material.dart';



class MyBottomNavigationBar extends StatelessWidget {
  final DatabaseManager dbManager;

  const MyBottomNavigationBar({super.key, required this.dbManager});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GamePage(dbManager: dbManager),
            ),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserPage(dbManager: dbManager),
            ),
          );
        }else if(index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(dbManager: dbManager),
            ),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '主页',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.games),
          label: '闯关',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '个人主页',
        ),
      ],
    );
  }
}
