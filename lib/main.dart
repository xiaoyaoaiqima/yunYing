import 'package:provider/provider.dart';
import 'common/DatabaseManager.dart';
import 'package:flutter/material.dart';
import 'SplashScreen.dart';
import 'package:fap3/userpage.dart';
import 'common/UserProvider.dart';
import 'gamePage.dart';
import 'homepage.dart';
import 'loginPage.dart';

void main() async {
  // 创建dbManager实例
  DatabaseManager dbManager = DatabaseManager();
  await dbManager.initializeDatabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        // ChangeNotifierProvider(create: (context) => ColorProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login App',
        home: const SplashScreen(key: ValueKey<int>(1)),
        routes: {
          '/LoginPage': (context) => const LoginPage(), // 将dbManager传递给LoginPage
          '/HomePage': (context) => HomePage(dbManager: dbManager),
          '/GamePage': (context) => GamePage(dbManager: dbManager),
          '/UserPage': (context) => UserPage(dbManager: dbManager),
        },
      ),
    ),
  );
}
