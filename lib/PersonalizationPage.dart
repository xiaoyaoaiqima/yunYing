import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonalizationPage extends StatelessWidget {
  const PersonalizationPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('个性化设置'),
        ),
        body: ListView(
          children: [
            ListTile(
              title: const Text('修改头像'),
              onTap: () {
                // 处理修改头像的逻辑
              },
            ),
            ListTile(
              title: const Text('修改昵称ID'),
              onTap: () {
                // 处理修改昵称ID的逻辑
              },
            ),
            ListTile(
              title: const Text('修改字体大小'),
              onTap: () {
                // 处理修改昵称ID的逻辑
              },
            ),
            Consumer<ColorProvider>(
              builder: (context, colorProvider, _) => SwitchListTile(
                title: const Text('切换主题色'),
                onChanged: (value) {
                  colorProvider.toggleDarkMode();
                },
                value: colorProvider.isDarkMode,
              ),
            ),
          ],
        ),
      );

  }
}



class ColorProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void setDarkMode(bool value) {
    _isDarkMode = value;
    if (hasListeners) {
      notifyListeners();
    }
  }

  void toggleDarkMode() {
    // 切换主题模式的方法
    _isDarkMode = !_isDarkMode;
    if (hasListeners) {
      notifyListeners();
    }
  }

  Color getContainerColor() {
    return _isDarkMode ? const Color(0xffFAE094) : const Color(0xffD9BB97);
  }
}
