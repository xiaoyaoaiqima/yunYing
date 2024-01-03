import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import 'loginPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({required Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: (200)),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      body:  Center(child: Column(
        children: [
          const SizedBox(
            width: 10,
            height: 20,
          ),
          const Image(image: AssetImage("images/openicon.png"),
            width: 300,
            height: 300,
            fit: BoxFit.contain,
          ),
          SizedBox(
            width: 200,
            height: 200,
            child:   DotLottieLoader.fromAsset("assets/load1m.lottie",
                frameBuilder: (ctx, dotlottie) {
                  if (dotlottie != null) {
                    return Lottie.memory(
                      dotlottie.animations.values.single,
                      controller: _controller,
                      onLoaded: (composition) {
                        _controller
                          ..duration = composition.duration
                          ..forward().whenComplete(() => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          ));
                      },
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
        ],
      ),)

    );
  }
}

