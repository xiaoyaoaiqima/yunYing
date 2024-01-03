import 'package:flutter/material.dart';

class FollowPage extends StatelessWidget {
  final List<Map<String, dynamic>> followList;

  const FollowPage({super.key, required this.followList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Follow Page'),
      ),
      body: ListView.separated(
        itemCount: followList.length,
        separatorBuilder: (context, index) => const Divider(color: Colors.grey, height: 1),
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(followList[index]['imageUrl']),
                ),
                title: Text('ID: ${followList[index]['id']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text('Name: ${followList[index]['name']}'),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow),
                        Text('${followList[index]['star_num']}'),
                      ],
                    ),
                    Text('Score: ${followList[index]['score_num']}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}