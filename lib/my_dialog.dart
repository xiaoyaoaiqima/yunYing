import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
class MyInheritedWidget extends InheritedWidget {
  final Function(bool) onDialogClose;

  const MyInheritedWidget({
    Key? key,
    required Widget child,
    required this.onDialogClose,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(MyInheritedWidget oldWidget) {
    // 这里可以根据需要决定是否触发子组件的重新构建
    return false;
  }
}
class MyDialog extends StatefulWidget {
  final Map<String, dynamic> userMap;
  final bool iffollow;
  final Function(bool) onDialogClose;

  const MyDialog({super.key, required this.userMap, required this.iffollow, required this.onDialogClose});

  @override
  _MyDialogState createState() => _MyDialogState();
}
class _MyDialogState extends State<MyDialog> {
  bool isFollowed = false;
  late Completer<bool> _completer;
  MyInheritedWidget? ancestorWidget;
  @override
  void initState() {
    super.initState();
    _completer = Completer<bool>();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('提示'),
      content: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: widget.userMap['imageUrl'] != null
                    ? AssetImage(widget.userMap['imageUrl'])
                    : const AssetImage('images/cow_avatar.png'),
              ),
              const SizedBox(height: 8),
              Text(widget.userMap['name']),
              const SizedBox(height: 4),
              Text('Star num: ${widget.userMap['star_num']}'),
              const SizedBox(height: 4),
              Text('Score num: ${widget.userMap['score_num']}'),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
              widget.onDialogClose(isFollowed);
          },
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              isFollowed = !isFollowed;
            });
          },
          child: Text(isFollowed ? '已关注' : '关注'),
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ancestorWidget = context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
  }

  @override
  void dispose() {
    if (ancestorWidget != null) {
      ancestorWidget!.onDialogClose(isFollowed);
    }
    super.dispose();
  }
}


void showDialogWithTitleAndContent(
    BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text('确定'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
void showSelectDialog(BuildContext context,String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("提示"),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text("确定"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
void showLoginErrorDialog(BuildContext context,bool isNameExist){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("登录失败"),
        content: isNameExist ? const Text("密码错误") : const Text("用户名不存在，请先注册"),
        actions: [
          TextButton(
            child: const Text("确定"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
void showErrorMessageDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text("错误"),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text("确定"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}
//
// void showMyDialog(BuildContext context, Map<String, dynamic> userMap,
//     bool iffollow, Function(bool) onDialogClose) {
//   Completer<bool> _completer = Completer<bool>();
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return MyDialog(userMap: userMap, iffollow: iffollow, onDialogClose: onDialogClose);
//     },
//   ).then((value) => onDialogClose(value));
// }

Widget buildLoginErrorDialog(BuildContext context, bool isNameExist) {
  return AlertDialog(
    title: const Text("登录失败"),
    content: isNameExist ? const Text("用户名或密码错误") : const Text("用户名不存在，请先注册"),
    actions: [
      TextButton(
        child: const Text("确定"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}
void showMyDialog(BuildContext context, Map<String, dynamic> userMap,
    bool iffollow, Function(bool) onDialogClose) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('提示'),
        content: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: userMap['imageUrl'] != null
                      ? AssetImage(userMap['imageUrl'])
                      : const AssetImage('images/cow_avatar.png'),
                ),
                const SizedBox(height: 8),
                Text(userMap['name']),
                const SizedBox(height: 4),
                Text('Star num: ${userMap['star_num']}'),
                const SizedBox(height: 4),
                Text('Score num: ${userMap['score_num']}'),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDialogClose(false);
            },
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              onDialogClose(true);
            },
            child: Text(iffollow ? '已关注' : '关注'),
          ),
        ],
      );
    },
  );
}
