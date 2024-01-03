import 'package:fap3/user.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'common/DatabaseManager.dart';
import 'common/UserProvider.dart';
import 'common/constVariable.dart';
import 'draw.dart';
import 'customWidget/gradient_button.dart';

import 'my_dialog.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late DatabaseManager dbManager;
  bool isLoginMode = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    dbManager = DatabaseManager();
    await dbManager.initializeDatabase();
  }

  void toggleMode() {
    setState(() {
      isLoginMode = !isLoginMode;
    });
  }
  login(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // 验证用户名和密码是否存在
    await dbManager.verify(username, password).then((isVerified) {
      if (isVerified) {
        return getUserInfo(username);
      } else {
        throw Exception("用户名或密码错误");
      }
    }).then((user) {
      saveUserInfoToProvider(context, user);
      if (kDebugMode) {
        print(user.toMap().toString());
      }
    }).then((_) {
      // 导航到下一个页面
      Navigator.pushNamed(context, '/HomePage');
    }).catchError((error) async {
      // 登录失败，展示错误信息
      await dbManager.ifNameExist(username).then((isNameExist) =>
          showLoginErrorDialog(context, isNameExist));
    });
  }
// 展示登录失败对话框

// 获取用户信息
  Future<User> getUserInfo(String username) async {
    final userMap = await dbManager.getCurrentUser(username);
    return dbManager.mapToUser(userMap!);
  }

// 保存用户信息到Provider
  void saveUserInfoToProvider(BuildContext context, User user) {
    constUsername = user.name;
    Provider.of<UserProvider>(context, listen: false).setCurrentUser(user);

  }

  Future<User> getUserInfo2(String username) async {
    await dbManager.insertUser(username);
    await Future.delayed(const Duration(milliseconds: 300));
    // 添加适当的延迟，确保插入操作完成后再进行查询
    final userMap = await dbManager.getCurrentUser(username);
    return dbManager.mapToUser(userMap!);
  }
    void showUsernameExistDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("用户名已存在"),
            content: const Text("请重新输入用户名"),
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

  void navigateToHomePage(BuildContext context) {
      Navigator.pushNamed(context, '/HomePage');
    }

  void register(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    if (username.isNotEmpty && password.isNotEmpty) {
      dbManager.ifNameExist(username).then((isNameExist) {
        if (isNameExist) {
          // 用户名已存在，显示弹窗
          showUsernameExistDialog(context);
        } else {
          return dbManager.insert(username, password);
        }
      }).then((_) {
        // 注册成功，获取用户信息，并保存到 Provider 中
        return getUserInfo2(username);
      }).then((user) {
        saveUserInfoToProvider(context, user);
            }).then((_) {
        // 导航到首页
        navigateToHomePage(context);
      }).catchError((error) {
        // 处理获取用户信息或导航过程中出现的错误
        showErrorMessageDialog(context, error.toString());
        debugPrint(error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 250,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/loginEllipse.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Center(
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text(
                  "登录",
                  style: TextStyle(
                    fontSize: isLoginMode ? 20 : 16,
                    fontWeight: isLoginMode ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    isLoginMode = true;
                  });
                },
              ),
              const SizedBox(width: 10), // 调整按钮之间的间距
              CustomPaint(
                painter: LinePainter(
                    const Offset(0, -10),
                    const Offset(0, 40)
                ),
                size: const Size(2, 20),
              ),
              const SizedBox(width: 10), // 调整按钮之间的间距
              ElevatedButton(
                child: Text(
                  "注册",
                  style: TextStyle(
                    fontSize: !isLoginMode ? 20 : 16,
                    fontWeight: !isLoginMode ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    isLoginMode = false;
                  });
                },
              ),
            ],
          ),

            const SizedBox(height: 10),
            // Divider(height: 2),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: "用户名",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "密码",
                    ),
                  ),
                  const SizedBox(height: 20),
                  GradientButton(
                    colors: const [Colors.orange, Colors.red],
                    height: 50.0,
                    onPressed: isLoginMode
                        ? () => login(context)
                        : () => register(context),
                    child: Text(
                      isLoginMode ? "登录" : "注册",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}



