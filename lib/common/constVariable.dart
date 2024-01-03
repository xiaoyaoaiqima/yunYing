
List<String> optionsQ1 = ["a", "b", "c", "d"];

List<String> resultQ1 = ["d","b","c","c","a","c"];
List<String> resultQ3 = ["b","a","d","c","b","c"];

List<String> optionsQ2 = ["a", "b", "c", "d","e"];

// Q1

const double q1SubmitButtonWidth = 60;
const double q1SubmitButtonHeight = 60;
const double q1SubmitButtonLeft = 580;
const double q1SubmitButtonBottom = 52;

const double q1AnswerButtonBottom = 30;
const double q1AnswerButtonWidth = 100;
const double q1AnswerButtonHeight = 100;

class MyPair {
  int intValue;
  String stringValue;

  MyPair(this.intValue, this.stringValue);
}


Map<int, String> map1 = {1: "b", 2: "a", 3: "e", 4: "c", 5: "d"};
Map<int, String> map2 = {1: "b", 2: "a", 3: "e", 4: "c", 5: "d"};
Map<int, String> map3 = {1: "c", 2: "a", 3: "e", 4: "b", 5: "d"};
Map<int, String> map4 = {1: "c", 2: "e", 3: "a", 4: "d", 5: "b"};
Map<int, String> map5 = {1: "c", 2: "d", 3: "a", 4: "e", 5: "b"};
Map<int, String> map6 = {1: "e", 2: "c", 3: "a", 4: "b", 5: "d"};

Map<int, Map<int, String>> allCorrectMap = {
  0: map1,
  1: map2,
  2: map3,
  3: map4,
  4: map5,
  5: map6,
};

late final constUsername;


final List<String> imageUrls = [
  'https://i.miji.bid/2023/12/24/202ea99a66bd07df59de7fa0f5c8c61f.png',
  'https://i.miji.bid/2023/12/24/da8e7626ff26703a8933d697bb43f46f.png',
  'https://i.miji.bid/2023/12/24/384df38e903cab323e48a01679c36e69.png',
  'https://i.miji.bid/2023/12/24/b6d34f7e71dfa2cc2e1e354d7a1e7b8b.png',
  'https://i.miji.bid/2023/12/24/040aaefc475136f5af1458391b81b437.png',
  'https://i.miji.bid/2023/12/24/e90af12969e50b8cec6d4861d52541e5.png',
  'https://i.miji.bid/2023/12/24/11ff6613b4fb47e595e8007da542caa7.png',
  'https://i.miji.bid/2023/12/24/6c06060a0725fe8d19d4691d04d8e49c.png',
  'https://i.miji.bid/2023/12/24/be7146d5bd6e8678b541bded309bfd04.png',
  'https://i.miji.bid/2023/12/24/ca736876fb25295f831834c747a104b4.png',
  'https://i.miji.bid/2023/12/24/3e08529477deda16402710c8f28346bd.png',
  'https://i.miji.bid/2023/12/24/2405380aa7c2956372bfe9185f45beda.png',
  'https://i.miji.bid/2023/12/24/fd741c4c5736658ca15cf1389430828d.png',
  'https://i.miji.bid/2023/12/24/cdcd84a042ec24734ba7a7ddfa162076.png',
  'https://i.miji.bid/2023/12/24/507a657f9523aa3eac6fa996750ea7b2.png',
  'https://i.miji.bid/2023/12/24/4dfacefae393b213be89a4f9821b0e42.png'

];