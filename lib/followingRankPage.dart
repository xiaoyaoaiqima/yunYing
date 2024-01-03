import 'package:fap3/user.dart';
import 'package:flutter/material.dart';

class FollowingRankPage extends StatelessWidget {
  final List<Map<String, dynamic>> followingRankList;

  const FollowingRankPage({super.key, required this.followingRankList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200, // Specify a definite height
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: 200, // Specify a definite height
                    child: Stack(
                      children: [
                        for (var i = followingRankList.length - 1; i >= 0; i--)
                          Positioned(
                            left: i == 0 ? 100 : (i == 1 ? 190 : 10),
                            top: i == 0 ? 0 : (i == 1 ? 20 : 40),
                            child: BadgePlayerCard(
                              user: User(
                                id: followingRankList[i]['id'],
                                imageUrl: followingRankList[i]['imageUrl'],
                                name: followingRankList[i]['name'],
                                starNum: followingRankList[i]['star_num'],
                                scoreNum: followingRankList[i]['score_num'],
                              ),
                              rank: i + 1,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: followingRankList.length < 3 ? 0 : (followingRankList.length - 3),
                itemBuilder: (context, index) {
                  return PlayerCard(
                    user: User(
                      id: followingRankList[index + 3]['id'],
                      imageUrl: followingRankList[index + 3]['imageUrl'],
                      name: followingRankList[index + 3]['name'],
                      starNum: followingRankList[index + 3]['star_num'],
                      scoreNum: followingRankList[index + 3]['score_num'],
                    ),
                    rank: index + 4,
                    isFirst: index == 3,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

  }
}

class BadgePlayerCard extends StatefulWidget {
  final User user;
  final int rank;

  const BadgePlayerCard({Key? key, required this.user, required this.rank})
      : super(key: key);

  @override
  _BadgePlayerCardState createState() => _BadgePlayerCardState();
}

class _BadgePlayerCardState extends State<BadgePlayerCard> {
  bool isClicked = false;
  late User _user;
  late int _rank;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _rank = widget.rank;
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    if (widget.rank == 1) {
      backgroundColor = const Color(0xFFA1DAE9);
    } else if (widget.rank == 2) {
      backgroundColor = const Color(0xFFF3C4C5);
    } else if (widget.rank == 3) {
      backgroundColor = const Color(0xFFFAE094);
    } else {
      backgroundColor = Colors.transparent;
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          isClicked = !isClicked;
        });
        if (isClicked) {
          ClickRankDialog(context, _user);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(16),
          color: backgroundColor,
        ),
        margin:  const EdgeInsets.only(left: 15.0, top: 10.0),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 排名
            Text(
              _rank == 1
                  ? '🥇'
                  : _rank == 2
                  ? '🥈'
                  : '🥉',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            // 头像和昵称
            Column(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(_user.imageUrl),
                ),
                const SizedBox(height: 8),
                Text(_user.name),
              ],
            ),
            const SizedBox(height: 4),
            // 星星数量
            Text("分数：${_user.scoreNum}"),
          ],
        ),
      ),
    );
  }
}
class PlayerCard extends StatefulWidget {
  final User user;
  final int rank;
  final bool isFirst;

  const PlayerCard(
      {Key? key, required this.user, required this.rank, this.isFirst = false})
      : super(key: key);

  @override
  _PlayerCardState createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  bool isClicked = false;
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isClicked = !isClicked;
        });
        if (isClicked) {
          ClickRankDialog(context, _user);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        margin: EdgeInsets.fromLTRB(
          20,
          widget.isFirst ? 0 : 3,
          20,
          3,
        ),
        width: isClicked ? 300 : 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          color: isClicked
              ? const Color(0x00a2d18b).withOpacity(1)
              : const Color(0x00a2d18b).withOpacity(0.65),
          child: Row(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: Text(
                  '${widget.rank}',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage(widget.user.imageUrl),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(widget.user.name),
              const Spacer(),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                child:  Text("分数：${widget.user.scoreNum}"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void ClickRankDialog(BuildContext context, User user) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          user.name,
          style: const TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(color: Colors.grey),
            const SizedBox(height: 10),
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(user.imageUrl),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "分数：${user.scoreNum}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "星星数量：${user.starNum}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text(
              '关闭',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      );
    },
  );
}