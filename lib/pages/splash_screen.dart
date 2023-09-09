import 'package:flutter/material.dart';
import 'package:mypos_task/routes.dart';
import 'package:mypos_task/utils/navigation_util.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void pageMap() {
    Future.delayed(
            const Duration(
              milliseconds: 3000,
            ),
            () async {})
        .then(
      (value) => moveToScreen(
        context,
        ScreenRoutes.toHomeScreen,
      ),
    );
  }

  @override
  void initState() {
    pageMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                height: size.height * 0.3,
                width: size.width,
                image: const AssetImage('assets/images/myPos.jpeg'),
              ),
            ],
          )),
    );
  }
}
