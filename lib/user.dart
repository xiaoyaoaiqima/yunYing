class User {
  final int id;
  final String name;
  final String imageUrl;
  final int starNum;
  final int scoreNum;

  User({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.starNum,
    required this.scoreNum,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'starNum': starNum,
      'scoreNum': scoreNum,
    };
  }
}

class UserVerify {
  final String name;
  final String password;

  UserVerify({
    required this.name,
    required this.password,
  });
}

List<UserVerify> initUserVerifyList = [
  UserVerify(name: 'user1', password: '123'),
  UserVerify(name: 'user2', password: '123'),
  UserVerify(name: 'user3', password: '123'),
  UserVerify(name: 'user4', password: '123'),
  UserVerify(name: 'user5', password: '123'),
  UserVerify(name: 'user6', password: '123'),
  UserVerify(name: 'user7', password: '123'),
  UserVerify(name: 'user8', password: '123'),
];

List<User> initUserList = [
  User(
    id: 1,
    name: 'user1',
    imageUrl: 'images/avatar/1.png',
    starNum: 10,
    scoreNum: 1588,
  ),
  User(
    id: 2,
    name: 'user2',
    imageUrl: 'images/avatar/2.png',
    starNum: 9,
    scoreNum: 1699,
  ),
  User(
    id: 3,
    name: 'user3',
    imageUrl: 'images/avatar/3.png',
    starNum: 20,
    scoreNum: 1700,
  ),
  User(
    id: 4,
    name: 'user4',
    imageUrl: 'images/avatar/4.png',
    starNum: 25,
    scoreNum: 500,
  ),
  User(
    id: 5,
    name: 'user5',
    imageUrl: 'images/avatar/5.png',
    starNum: 7,
    scoreNum: 400,
  ),
  User(
    id: 6,
    name: 'user6',
    imageUrl: 'images/avatar/6.png',
    starNum: 45,
    scoreNum: 200,
  ),
  User(
    id: 7,
    name: 'user7',
    imageUrl: 'images/avatar/7.png',
    starNum: 25,
    scoreNum: 2000,
  ),
  User(
    id: 8,
    name: 'user8',
    imageUrl: 'images/avatar/8.png',
    starNum: 32,
    scoreNum: 1800,
  ),
];
