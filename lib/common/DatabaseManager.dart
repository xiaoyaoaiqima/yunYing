import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:table_calendar/table_calendar.dart';
import '../user.dart';

class DatabaseManager {
  late Database _database;

  // 单例模式
  static final DatabaseManager _instance = DatabaseManager._internal();

  factory DatabaseManager() {
    return _instance;
  }

  DatabaseManager._internal();

  Future<void> initializeDatabase() async {
    try
    {
      String path = join(await getDatabasesPath(), 'my_database.db');
      // 是否重写数据库
      // bool exists = await databaseExists(path);
      //
      // if (exists) {
      //   await deleteDatabase(path);
      // }
      _database = await openDatabase(
        path,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE User (
            id INTEGER PRIMARY KEY,
            name TEXT,
            star_num INTEGER,
            score_num INTEGER,
            imageUrl TEXT,
            gamecoin_num INTEGER
          )
        ''');

          await db.execute('''
          CREATE TABLE Follow (
            id INTEGER PRIMARY KEY,
            follower_name TEXT,
            following_name TEXT,
            following_score_num INTEGER,
            FOREIGN KEY (follower_name) REFERENCES User(name),
            FOREIGN KEY (following_name) REFERENCES User(name),
            FOREIGN KEY (following_score_num) REFERENCES User(score_num)
          )
        ''');

          await db.execute('''
          CREATE TABLE CheckIn (
            id INTEGER PRIMARY KEY,
            user_name TEXT,
            checkin_year INTEGER,
            checkin_month INTEGER,
            checkin_day INTEGER,
            FOREIGN KEY (user_name) REFERENCES User(name)
          )
        ''');

          await db.execute('''
          CREATE TABLE calendarEvent (
            id INTEGER PRIMARY KEY,
            userName TEXT,
            time TEXT,
            event TEXT
          )
        ''');
          await db.insert(
            'calendarEvent',
            {
              'userName': '123',
              'time': DateTime.now().toIso8601String(),
              'event': '签到',
            },
          );
          await db.insert(
            'calendarEvent',
            {
              'userName': '123',
              'time': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
              'event': '签到',
            },
          );
          await db.execute('''
          CREATE TABLE UserVerify (
            id INTEGER PRIMARY KEY,
            user_name TEXT,
            user_password TEXT,
            FOREIGN KEY (user_name) REFERENCES User(name)
          )
        ''');
          // 创建UserUserLevel表
          await db.execute('''
            CREATE TABLE UserLevel (
              id INTEGER PRIMARY KEY,
              name TEXT,
              LevelIndex INTEGER,
              LevelIndexStarNum INTEGER,
              LevelIndexScoreNum INTEGER,
              FOREIGN KEY (name) REFERENCES User(name)
            )
          ''');
          await db.insert(
            'User',
            {
              'name': '123',
              'star_num': 0,
              'score_num': 0,
              'imageUrl': 'images/cow_avatar.png',
              'gamecoin_num':300
            },
          );
          await db.insert(
            'UserVerify',
            {
              'user_name': '123',
              'user_password':'123'
            },
          );
          await db.insert(
            'Follow',
            {
              'follower_name': 123,
              'following_name': 123,
              'following_score_num': 300,
            },
          );
          for (User user in initUserList) {
            await db.insert(
              'User',
              {
                'name': user.name,
                'star_num': user.starNum,
                'score_num': user.scoreNum,
                'imageUrl': user.imageUrl,
                'gamecoin_num': 0,
              },
            );
          }
          for (UserVerify userVerify in initUserVerifyList){
            await db.insert('UserVerify', {
              'user_name':userVerify.name,
              'user_password':userVerify.password
            });
          }
        },
        version: 2,
      );
    }catch (e) {
      if (kDebugMode) {
        print('Failed to open database: $e');
      }
    }
  }
  Future<bool> addOneCheckIn(String userName, DateTime time, String event) async {
    List<Map<String, dynamic>> existingEvents = await _database.query('calendarEvent', where: 'userName = ? AND event = ?', whereArgs: [userName, event]);
    for (var item in existingEvents) {
      var existingTime = DateTime.parse(item['time']);
      if (isSameDay(time, existingTime)) {
        return false;
      }
    }
    await _database.insert(
      'calendarEvent',
      {
        'userName': userName,
        'time': time.toIso8601String(),
        'event': "签到",
      },
    );
    return true;
  }
  Future<bool> addOneEventIn(String userName, DateTime time, String event) async {
    await _database.insert(
      'calendarEvent',
      {
        'userName': userName,
        'time': time.toIso8601String(),
        'event': event,
      },
    );
    return true;
  }
  Future<Map<DateTime, List<String>>> readAllEventIn(String userName) async {
    // 从数据库查询所有的事件
    final List<Map<String, dynamic>> maps = await _database.query('calendarEvent', where: 'userName = ?', whereArgs: [userName]);

    // 用于存储结果的映射
    var events = <DateTime, List<String>>{};

    for(var row in maps) {
      var event = row['event'];
      var time = DateTime.parse(row['time']);

      // 如果映射中已经有这个时间，就添加到它对应的列表中
      if(events.containsKey(time)) {
        events[time]?.add(event);

      } else {
        events[time] = [event];
      }
    }

    return events;
  }
  // 验证用户名和密码是否匹配
  Future<bool> verify(String name, String password) async {
    final db = _database;

    final result = await db.query(
      'UserVerify',
      columns: ['user_password'],
      where: 'user_name = ?',
      whereArgs: [name],
    );

    if(result.isNotEmpty) {
      final userPassword = result.first['user_password'] as String?;
      return userPassword == password;
    }

    return false;
  }
// 插入用户名和密码
  Future<void> insert(String name, String password) async {
    final db = _database;
    await db.insert(
      'UserVerify',
      {
        'user_name': name,
        'user_password': password,
      },
    );
  }
  // 检查用户名是否已存在
  Future<bool> ifNameExist(String name) async {
    final db = _database;

    final result = await db.query(
      'UserVerify',
      columns: ['user_name'],
      where: 'user_name = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getRankingList(String name) async {
    return await _database.rawQuery('''
      SELECT u.*
      FROM User u 
      INNER JOIN Follow f ON u.name = f.following_name
      WHERE f.follower_name = ?
      ORDER BY u.score_num DESC
      LIMIT 8
    ''', [name]);
  }

  Future<Map<String, dynamic>?> getCurrentUser(String name) async {
    final List<Map<String, dynamic>> result = await _database.query(
      'User',
      where: 'name = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty ? result.first : null;
  }

  String formatResult(Map<String, dynamic>? result) {
    if (result == null) {
      return '用户不存在';
    } else {
      return '用户名: ${result['name']}\n'
          '星级数量: ${result['star_num']}\n'
          '评分数量: ${result['score_num']}\n'
          '头像URL: ${result['imageUrl']}\n'
          '游戏币数量: ${result['gamecoin_num']}';
    }
  }

  User mapToUser(Map<String, dynamic> userMap) {
    return User(
      id: userMap['id'] as int,
      name: userMap['name'] as String,
      imageUrl: userMap['imageUrl'] != null ? userMap['imageUrl'] as String : '',
      starNum: userMap['star_num'] != null ? userMap['star_num'] as int : 0,
      scoreNum: userMap['score_num'] != null ? userMap['score_num'] as int : 0,
    );
  }

  Future<List<Map<String, dynamic>>> getCheckinList(
      String name, int checkinMonth, int checkinDay) async {
    return await _database.rawQuery('''
      SELECT checkin_day,
             CASE WHEN checkin_day IS NOT NULL THEN 1 ELSE 0 END AS checkin_status
      FROM CheckIn
      WHERE user_name = ? AND checkin_month = ? AND checkin_day <= ?
    ''', [name, checkinMonth, checkinDay]);
  }

  Future<void> insertUser(String name) async {
    await _database.insert(
      'User',
      {
        'name': name,
        'star_num': 0,
        'score_num': 0,
        'imageUrl': 'images/cow_avatar.png',
        'gamecoin_num': 0,
      },
    );
  }

  Future<void> insertFollow(String followerName, String followingName) async {
    final db = _database;

    final result = await db.query(
      'Follow',
      columns: ['id'],
      where: 'follower_name = ? AND following_name = ?',
      whereArgs: [followerName, followingName],
    );

    if(result.isEmpty) {
      final Map<String, dynamic>? followingUser = await getCurrentUser(followingName);
      if (followingUser != null) {
        await db.insert(
          'Follow',
          {
            'follower_name': followerName,
            'following_name': followingName,
            'following_score_num': followingUser['score_num'],
          },
        );
      }
    }
  }

  Future<bool> ifFollow(String followerName, String followingName) async {
    final db = _database;

    final result = await db.query(
      'Follow',
      columns: ['id'],
      where: 'follower_name = ? AND following_name = ?',
      whereArgs: [followerName, followingName],
    );

    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> findAllFollow(String name) async {
    final List<Map<String, dynamic>> result = await _database.query(
      'Follow',
      columns: ['following_name'],
      where: 'follower_name = ?',
      whereArgs: [name],
    );

    List<Map<String, dynamic>> followList = [];

    for (Map<String, dynamic> follow in result) {
      final String followingName = follow['following_name'] as String;
      final List<Map<String, dynamic>> userResult = await _database.query(
        'User',
        columns: ['id','name', 'imageUrl', 'star_num', 'score_num'],
        where: 'name = ?',
        whereArgs: [followingName],
      );
      if (userResult.isNotEmpty) {
        followList.add(userResult.first);
      }
    }
    return followList;
  }

  Future<void> insertNewCheck(String name, int year, int month, int day) async {
    await _database.insert(
      'CheckIn',
      {'user_name': name, 'checkin_year': year, 'checkin_month': month, 'checkin_day': day},
    );
  }

  Future<int?> NameToid(String name) async {
    final List<Map<String, dynamic>> result = await _database.rawQuery('''
      SELECT id FROM User WHERE name = ?
    ''', [name]);
    return result.isNotEmpty ? result.first['id'] : null;
  }

  Future<int?> getUserCurrentLevelStarNum(String name, int levelIndex) async {
    try {
      final result = await _database.query(
        'UserLevel',
        where: 'name = ? AND LevelIndex = ?',
        whereArgs: [name, levelIndex],
      );
      if (result.isNotEmpty) {
        return result.first['LevelIndexStarNum'] as int?;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get user current level star num: $e');
      }
    }
    return 0;
  }

  Future<void> changeUserLevelIndexStarAndScoreNum(String name, int levelindex, int starNum, int scoreNum) async {
    final db = _database;

    final oldData = await db.query(
      'UserLevel',
      where: 'name = ? AND LevelIndex = ?',
      whereArgs: [name, levelindex],
    );
    // Update the User table
    final user = await db.query(
      'User',
      where: 'name = ?',
      whereArgs: [name],
    );
    final oldUserStarNum = user.first['star_num'] as int;
    final oldUserScoreNum = user.first['score_num'] as int;
    if (oldData.isNotEmpty) {
      final oldStarNum = oldData.first['LevelIndexStarNum'] as int;
      final oldScoreNum = oldData.first['LevelIndexScoreNum'] as int;

      if (starNum > oldStarNum || scoreNum > oldScoreNum) {

        // Update the UserLevel table
        await db.update(
          'UserLevel',
          {
            'LevelIndexStarNum': starNum,
            'LevelIndexScoreNum': scoreNum,
          },
          where: 'name = ? AND LevelIndex = ?',
          whereArgs: [name, levelindex],
        );
          await db.update(
            'User',
            {
              'star_num': oldUserStarNum + (starNum - oldStarNum),
              'score_num': oldUserScoreNum + (scoreNum - oldScoreNum),
            },
            where: 'name = ?',
            whereArgs: [name],
          );
      }
    } else {
      // Insert new data if oldData is empty
      await db.insert(
        'UserLevel',
        {
          'name': name,
          'LevelIndex': levelindex,
          'LevelIndexStarNum': starNum,
          'LevelIndexScoreNum': scoreNum,
        },
      );
      await db.update(
        'User',
        {
          'star_num': oldUserStarNum + starNum,
          'score_num': oldUserScoreNum + scoreNum,
        },
        where: 'name = ?',
        whereArgs: [name],
      );
    }
    print("已经修改");
  }

  Future<Map<String, int>> getAllUserStarAndScore(String name) async {
    final data = await _database.query(
      'UserLevel',
      where: 'name = ?',
      whereArgs: [name],
    );

    int allStarNum = 0;
    int allScoreNum = 0;

    for (final row in data) {
      allStarNum += row['LevelIndexStarNum'] as int;
      allScoreNum += row['score_num'] as int;
    }

    await _database.update(
      'User',
      {
        'star_num': allStarNum,
        'score_num': allScoreNum,
      },
      where: 'name = ?',
      whereArgs: [name],
    );

    return {'allStarNum': allStarNum, 'allScoreNum': allScoreNum};
  }
}
