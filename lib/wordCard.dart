import 'package:flutter/material.dart';
import 'common/constVariable.dart';

class WordCard extends StatelessWidget {
  const WordCard({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true, // 将标题居中
          title: const Text('You Word Card'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: PageView.builder(
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return Image.network(imageUrls[index]);
          },
        ),
      ),
    );
  }
}