import 'package:fap3/common/DatabaseManager.dart';
import 'package:fap3/userSearchBar.dart';
import 'package:flutter/material.dart';
import 'package:fap3/user.dart';
import 'package:fap3/my_dialog.dart';
import 'package:provider/provider.dart';

import 'common/UserProvider.dart';
import 'followingRankPage.dart';
import 'myBottomNavigationBar.dart';

class HomePage extends StatefulWidget {
  final DatabaseManager dbManager;
  const HomePage({super.key, required this.dbManager});

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  List<User> users = [];
  String searchResult = '';

  @override
  void initState() {
    super.initState();
    users = initUserList; // 在 initState 中获取用户数据
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.dbManager.getRankingList(currentUser!.name),
      builder: (context, snapshot) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                topContainer(userProvider),
                UserSearchBar(
                  onSearch: (searchResult) {
                    widget.dbManager.ifNameExist(searchResult).then((isExist) {
                      if (isExist) {
                        widget.dbManager.getCurrentUser(searchResult).then((result) {
                          widget.dbManager.ifFollow(currentUser.name, searchResult).then((value) {
                            showMyDialog(context, result!, value, (isFollowed) {
                              if (isFollowed) {
                                widget.dbManager.insertFollow(currentUser.name, result['name']);
                              }
                            });
                          });
                        });
                      } else {
                        showDialogWithTitleAndContent(context, '用户不存在', '请重新输入用户名');
                      }
                    });
                  },
                ),
                Expanded(
                  child: snapshot.connectionState == ConnectionState.done && snapshot.hasData
                      ? FollowingRankPage(followingRankList: snapshot.data!)
                      : const Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
          bottomNavigationBar: MyBottomNavigationBar(dbManager: widget.dbManager),
        );
      },
    );
  }

}

Widget topContainer(UserProvider userProvider) {
  final currentUser = userProvider.currentUser;
  return Container(
    padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('欢迎您，${currentUser?.name}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Arial',
                )),
            const Text('Firday 1 December',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Arial',
                )),
          ],
        ),
        const SizedBox(width: 16),
        CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage(currentUser!.imageUrl),
        ),
      ],
    ),
  );
}

