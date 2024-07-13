import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  late PackageInfo packageInfo;
  bool isInitialized = false;
  late final AnimationController animationController = AnimationController(
    duration: const Duration(milliseconds: 3000),
    vsync: this,
  );
  late final Animation<double> sizeAnimation = Tween<double>(
    begin: -80.0,
    end: 0.0,
  ).animate(CurvedAnimation(
    parent: animationController,
    curve: Curves.fastOutSlowIn,
  ));

  @override
  void didChangeDependencies() async {
    if (!isInitialized) {
      packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        isInitialized = true;
      });
      animationController.repeat(reverse: true);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(
        children: [
          Image(
            fit: BoxFit.cover,
            height: size.height,
            image: const AssetImage("assets/images/background.png")
          ),
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child){
              return Positioned(
                top: sizeAnimation.value,
                right: sizeAnimation.value,
                child: Image(
                  height: size.height*0.6,
                  fit: BoxFit.cover,
                  image: const AssetImage("assets/images/vector-superior.png")
                ),
              );
            }
          ),
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child){
              return Positioned(
                bottom: sizeAnimation.value,
                left: sizeAnimation.value,
                child: Image(
                  height: size.height * 0.6,
                  fit: BoxFit.fill,
                  image: const AssetImage("assets/images/vector-inferior.png")
                ),
              );
            }
          ),
          Positioned(
            top: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Image(
                  width: size.width-4,
                  fit: BoxFit.fill,
                  image: const AssetImage("assets/images/top-icons.png")
                ),
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.3,
            child: SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image(
                        width: size.width * 0.8,
                        fit: BoxFit.fill,
                        image: const AssetImage("assets/images/logo.png")
                      ),
                      const CircularProgressIndicator(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            child: SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    width: size.width*0.70,
                    fit: BoxFit.fill,
                    image: const AssetImage("assets/images/character-1.png")
                  ),
                ],
              ),
            ),
          ),
          Positioned(bottom: 5, right: 5, child: appVersion()),
        ],
      )
    );
  }

  Widget appVersion() {
    return Text(
      isInitialized ? 'v${packageInfo.version}' : '',
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 18,
        fontWeight: FontWeight.bold
      ),
      textAlign: TextAlign.center,
    );
  }
}
